import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting

// Assuming you have a barrel file or standard navigation
// If using go_router, keep context.pop(), otherwise use Navigator.pop(context)

import '../../data/models/debt_model.dart';
import '../viewmodels/ debt_viewmodel.dart';
import '../viewmodels/contact_viewmodel.dart'; // Ensure this path is correct

class DebtTransaction extends HookConsumerWidget {
  const DebtTransaction({super.key});

  // Constant Colors
  static const Color _primaryColor = Color(0xFF146C82);
  static const Color _inactiveColor = Color(0xFFEFF2F7);
  static const Color _labelColor = Color(0xFF9EA6BE);
  static const Color _textColor = Color(0xFF2C3E50);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Setup Local State (Hooks)
    final isLent = useState(true);
    final isReminderOn = useState(true);
    final selectedDate = useState<DateTime?>(null);

    // 2. Setup Controllers
    final amountController = useTextEditingController();
    final nameController = useTextEditingController();
    final notesController = useTextEditingController();
    final reasonController = useTextEditingController(text: "General Loan");

    // 3. Access ViewModel
    final debtNotifier = ref.read(debtViewModelProvider.notifier);
    final debtState = ref.watch(debtViewModelProvider);
    final contactNotifier = ref.read(contactViewModelProvider.notifier);
    final contactState = ref.watch(contactViewModelProvider);
    useEffect(() {
      Future.microtask(() => contactNotifier.loadContacts());
      return null;
    }, []);

    // Helper for Date Picker
    Future<void> pickDate() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: _primaryColor,
                onPrimary: Colors.white,
                onSurface: _textColor,
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        selectedDate.value = picked;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          children: [
            // --- Header ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCloseButton(context),
                  const Text(
                    "Create New Debt",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the row
                ],
              ),
            ),

            // --- Form Body ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Lent / Borrowed Toggle
                    _buildToggleSwitch(isLent),

                    const SizedBox(height: 30),

                    // Amount Section
                    Text(
                      "AMOUNT",
                      style: TextStyle(
                        color: _labelColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Amount Input
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "\$",
                          style: TextStyle(
                            color: _labelColor,
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IntrinsicWidth(
                          child: TextField(
                            controller: amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: const TextStyle(
                              color: _textColor,
                              fontSize: 48,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: const InputDecoration(
                              hintText: "0.00",
                              hintStyle: TextStyle(color: Color(0xFFE2E6EE)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Person Name Input
                    _buildLabel("PERSON NAME"),
                    _buildTextField(
                      controller: nameController,
                      hint: "Who is this for?",
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    _buildLabel("Phone Number "),
                    DropdownMenu<Contact>(
                      width: double.infinity,
                      initialSelection: contactState.selectedContact,
                      enableFilter: true, // Enables the "Search" functionality
                      requestFocusOnTap: true, // Opens keyboard immediately
                      leadingIcon: const Icon(Icons.search),
                      label: const Text('Search Name...'),
                      inputDecorationTheme: InputDecorationTheme(
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                      ),
                      onSelected: (Contact? contact) {
                        contactNotifier.pickContact();
                      },
                      dropdownMenuEntries: contactState.contacts!
                          .map<DropdownMenuEntry<Contact>>((Contact contact) {
                            return DropdownMenuEntry<Contact>(
                              value: contact,
                              label: contact.displayName,
                              leadingIcon: Icon(Icons.person),
                            );
                          })
                          .toList(),
                    ),

                    const SizedBox(height: 20),

                    // Reason / Category
                    _buildLabel("REASON / CATEGORY"),
                    _buildDropdownField(text: "General Loan"),

                    const SizedBox(height: 20),

                    // Due Date & Reminder Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("DUE DATE"),
                              GestureDetector(
                                onTap: pickDate,
                                child: AbsorbPointer(
                                  child: _buildTextField(
                                    controller: TextEditingController(
                                      text: selectedDate.value != null
                                          ? DateFormat(
                                              'MM/dd/yyyy',
                                            ).format(selectedDate.value!)
                                          : "",
                                    ),
                                    hint: "mm/dd/yyyy",
                                    suffixIcon: const Icon(
                                      Icons.calendar_today_outlined,
                                      color: _textColor,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("REMINDER"),
                              Container(
                                height: 56,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Notify me",
                                      style: TextStyle(
                                        color: _textColor.withOpacity(0.7),
                                      ),
                                    ),
                                    Transform.scale(
                                      scale: 0.8,
                                      child: Switch(
                                        value: isReminderOn.value,
                                        activeColor: Colors.white,
                                        activeTrackColor: _primaryColor,
                                        inactiveThumbColor: Colors.white,
                                        inactiveTrackColor: _inactiveColor,
                                        trackOutlineColor:
                                            MaterialStateProperty.all(
                                              Colors.transparent,
                                            ),
                                        onChanged: (val) {
                                          isReminderOn.value = val;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Notes
                    _buildLabel("NOTES (OPTIONAL)"),
                    _buildTextField(
                      controller: notesController,
                      hint: "Add a short description...",
                      maxLines: 3,
                    ),

                    const SizedBox(height: 40),

                    // Add Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: debtState.isLoading
                            ? null
                            : () {
                                // TODO: Validation Logic
                                if (amountController.text.isEmpty ||
                                    nameController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please fill in required fields",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // Create the model
                                // final newDebt = DebtModel(
                                //   id: DateTime.now().toString(), // Or generate UUID
                                //   amount: double.tryParse(amountController.text) ?? 0.0,
                                //   fullName: nameController.text,
                                //
                                //   iOwe: !isLent.value, // isLent=true means "I Lent" (Owed to me)
                                //   dueDate: selectedDate.value,
                                //   notes: notesController.text,
                                // );

                                // Call ViewModel
                                // Note: You need a valid userId here from your Auth provider
                                // debtNotifier.addDebt(newDebt, "current_user_id").then((_) {
                                //   if (context.mounted) Navigator.pop(context);
                                // });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          elevation: 2,
                          shadowColor: _primaryColor.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: debtState.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Add Debt Entry",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildCloseButton(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: _inactiveColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          // Use Navigator or GoRouter depending on your setup
          Navigator.of(context).maybePop();
        },
        icon: const Icon(Icons.close, color: _textColor, size: 20),
      ),
    );
  }

  Widget _buildToggleSwitch(ValueNotifier<bool> isLent) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _inactiveColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => isLent.value = true,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isLent.value ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isLent.value
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_outward_rounded,
                      size: 16,
                      color: isLent.value ? _primaryColor : _labelColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "I Lent",
                      style: TextStyle(
                        color: isLent.value ? _primaryColor : _labelColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => isLent.value = false,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isLent.value ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: !isLent.value
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_downward_rounded,
                      size: 16,
                      color: !isLent.value ? _primaryColor : _labelColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "I Borrowed",
                      style: TextStyle(
                        color: !isLent.value ? _primaryColor : _labelColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: TextStyle(
          color: _labelColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    Widget? suffixIcon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: _textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: _textColor.withOpacity(0.5),
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildDropdownField({required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(color: _textColor, fontSize: 15)),
          const Icon(Icons.keyboard_arrow_down, color: _labelColor),
        ],
      ),
    );
  }
}
