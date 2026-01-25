import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/models/category_model.dart';
import '../../providers/add_transaction_provider.dart';

class AddTransactionView extends HookConsumerWidget {
  final TransactionType type;

  const AddTransactionView({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addTransactionProvider(type));
    final notifier = ref.read(addTransactionProvider(type).notifier);

    // Hooks for text editing
    final amountController = useTextEditingController(text: state.amount);
    final noteController = useTextEditingController(text: state.note);

    // Determine colors based on Type
    final primaryColor = type == TransactionType.income ? AppColors.success : AppColors.error;
    final categories = type == TransactionType.income
        ? AppCategories.getIncomeCategories()
        : AppCategories.getExpenseCategories();

    // Sync controllers with state
    useEffect(() {
      void listener() {
        notifier.setAmount(amountController.text);
      }
      amountController.addListener(listener);
      return () => amountController.removeListener(listener);
    }, [amountController]);


    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.black, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          type == TransactionType.income ? "Add Income" : "Add Expense",
          style: TextStyleHelper.textStyle18(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
// Replace the TextButton in your AppBar actions with this:
          TextButton(
            onPressed: state.isLoading
            //t
                ? null // Disable while saving to prevent double-taps
                : () async {
              // 1. Call the save method from the notifier
              final success = await notifier.saveTransaction();
print('success $success');
              if (context.mounted) {
                if (success) {
                  // 2. Success: Show feedback and go back
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transaction added successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  // 3. Error: Show the specific error from Appwrite
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? 'Failed to save transaction'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: state.isLoading
                ? SizedBox(
              width: 20.w,
              height: 20.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: primaryColor,
              ),
            )
                : Text(
              "Save",
              style: TextStyleHelper.textStyle16(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 24.h),

            // 1. Category Field
            _buildInputField(
              context: context,
              icon: FontAwesomeIcons.layerGroup, // Generic icon
              label: state.selectedCategory?.name ?? "Select Category",
              onTap: () => _showCategoryPicker(context, ref, categories, primaryColor),
              isSelected: state.selectedCategory != null,
              primaryColor: primaryColor,
            ),

            // 2. Amount Field
            _buildInputField(
              context: context,
              icon: FontAwesomeIcons.moneyBill,
              label: state.amount.isEmpty ? "Enter Amount" : state.amount,
              controller: amountController,
              keyboardType: TextInputType.number,
              primaryColor: primaryColor,
              isAmount: true,
            ),

            // 3. Date & Time Field
            _buildInputField(
              context: context,
              icon: FontAwesomeIcons.calendar,
              label: _formatDate(context, state.selectedDate, state.selectedTime),
              onTap: () => _showDatePicker(context, ref, state.selectedDate, state.selectedTime),
              isSelected: true,
              primaryColor: primaryColor,
            ),

            // 4. Note Field
            _buildInputField(
              context: context,
              icon: FontAwesomeIcons.pen,
              label: "Write a Note (Optional)",
              controller: noteController,
              primaryColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required BuildContext context,
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    TextEditingController? controller,
    TextInputType? keyboardType,
    bool isSelected = false,
    required Color primaryColor,
    bool isAmount = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Row(
            children: [
              FaIcon(
                icon,
                color: primaryColor, // Dynamic Color (Green/Red)
                size: 20.sp,
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: onTap != null
                    ? GestureDetector(
                  onTap: onTap,
                  child: Text(
                    label,
                    style: TextStyleHelper.textStyle16(
                      color: isSelected || isAmount ? AppColors.black : AppColors.grey,
                      fontWeight: isSelected || isAmount ? FontWeight.w600 : FontWeight.w400,
                      fontSize: isAmount ? 24.sp : 16.sp, // Bigger text for amount
                    ),
                  ),
                )
                    : TextField(
                  controller: controller,
                  keyboardType: keyboardType ?? TextInputType.text,
                  style: TextStyleHelper.textStyle16(
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: isAmount ? 24.sp : 16.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: label,
                    hintStyle: TextStyleHelper.textStyle16(color: AppColors.grey),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(color: AppColors.grey.withOpacity(0.2), height: 1),
      ],
    );
  }

  void _showCategoryPicker(BuildContext context, WidgetRef ref, List<CategoryModel> categories, Color color) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24.w),
          height: 400.h,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(icon: Icon(Icons.arrow_back_ios, size: 20.sp), onPressed: () => Navigator.pop(context)),
                  Expanded(child: Text("Select a Category", style: TextStyleHelper.textStyle18(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                  SizedBox(width: 48.w),
                ],
              ),
              SizedBox(height: 32.h),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 24.h,
                  crossAxisSpacing: 20.w,
                  children: categories.map((cat) {
                    return _CategoryItem(
                      category: cat,
                      onTap: () {
                        ref.read(addTransactionProvider(type).notifier).setCategory(cat);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDatePicker(BuildContext context, WidgetRef ref, DateTime currentDate, TimeOfDay currentTime) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(icon: Icon(Icons.arrow_back_ios, size: 20.sp), onPressed: () => Navigator.pop(context)),
                      Expanded(child: Text("Select Date & Time", style: TextStyleHelper.textStyle18(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                      SizedBox(width: 48.w),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 300.h,
                    child: CalendarDatePicker(
                      initialDate: currentDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      onDateChanged: (DateTime picked) {
                        // ref.read(addTransactionProvider.notifier).setDate(picked);
                        ref.read(addTransactionProvider(type).notifier).setDate(picked);
                        // Optionally trigger modal rebuild if needed
                      },
                    ),
                  ),
                  Divider(height: 32.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Time", style: TextStyleHelper.textStyle16(fontWeight: FontWeight.w500)),
                      InkWell(
                        onTap: () async {
                          final TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: currentTime,
                          );
                          if (time != null) {
                            setModalState(() => ref.read(addTransactionProvider(type).notifier).setTime(time));
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            currentTime.format(context),
                            style: TextStyleHelper.textStyle14(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: const Text("Done", style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(BuildContext context, DateTime date, TimeOfDay time) {
    final now = DateTime.now();
    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      return "Today, ${time.format(context)}";
    }
    return "${date.day}/${date.month}/${date.year}, ${time.format(context)}";
  }
}

class _CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const _CategoryItem({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.12), // Subtle background
              shape: BoxShape.circle,
            ),
            child: Center(child: FaIcon(category.icon, color: category.color, size: 28.sp)),
          ),
          SizedBox(height: 8.h),
          Text(
            category.name,
            style: TextStyleHelper.textStyle14(color: AppColors.black, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}