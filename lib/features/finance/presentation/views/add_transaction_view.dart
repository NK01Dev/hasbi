import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import '../../../../core/common/widgets/loading_widget.dart';
import '../../../../core/common/widgets/error_widget.dart' as custom;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/models/category_model.dart';
import '../../providers/add_transaction_provider.dart';

class AddTransactionView extends HookConsumerWidget {
  final TransactionType type;
  final String? transactionId;

  const AddTransactionView({
    super.key,
    required this.type,
    this.transactionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addTransactionProvider(type));
    final notifier = ref.read(addTransactionProvider(type).notifier);

    // Initialize controllers - NO initial text to avoid sync issues
    final amountController = useTextEditingController();
    final noteController = useTextEditingController();

    final primaryColor = type == TransactionType.income ? AppColors.success : AppColors.error;
    final categories = type == TransactionType.income
        ? AppCategories.getIncomeCategories()
        : AppCategories.getExpenseCategories();

    // Currency Formatter
    final currencyFormatter = CurrencyTextInputFormatter.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
      enableNegative: true,
      inputDirection: InputDirection.left
    );

    // Load Transaction Logic (Initial Load / Edit Mode)
    useEffect(() {
      if (transactionId != null && state.id == null && !state.isLoading) {
        // Defer the state modification until after the build phase
        Future.microtask(() => notifier.loadTransaction(transactionId!));
      }
      return null;
    }, [transactionId]);

    // Update controllers when data is loaded (ONE-WAY: State -> Controller)
    // This only happens after loading transaction data, not during typing
    useEffect(() {
      if (state.id != null) {
        // Use post-frame callback to avoid build-phase modifications
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state.amount.isNotEmpty && amountController.text != state.amount) {
            amountController.text = state.amount;
          }
          if (state.note.isNotEmpty && noteController.text != state.note) {
            noteController.text = state.note;
          }
        });
      }
      return null;
    }, [state.id, state.amount, state.note]);

    final isEditing = transactionId != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing
              ? (type == TransactionType.income ? "Edit Income" : "Edit Expense")
              : (type == TransactionType.income ? "Add Income" : "Add Expense"),
          style: TextStyleHelper.textStyle18(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: state.isLoading
                ? null
                : () async {
              // Read amount from controller, not state
              final success = await notifier.saveTransaction(
                amount: amountController.text,
                note: noteController.text,
              );
              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEditing ? 'Transaction updated!' : 'Transaction added!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? 'Failed to save'),
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
          ),
        ],
      ),
      body: _buildBody(
        state: state,
        isEditing: isEditing,
        amountController: amountController,
        noteController: noteController,
        primaryColor: primaryColor,
        currencyFormatter: currencyFormatter,
        categories: categories,
        context: context,
        ref: ref,
      ),
    );
  }

  Widget _buildBody({
    required AddTransactionState state,
    required bool isEditing,
    required TextEditingController amountController,
    required TextEditingController noteController,
    required Color primaryColor,
    required TextInputFormatter currencyFormatter,
    required List<CategoryModel> categories,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    // Show loading state when fetching transaction data
    if (isEditing && state.isLoading && state.id == null) {
      return const LoadingWidget(message: 'Loading transaction...');
    }

    // Show error state if loading failed
    if (state.errorMessage != null && state.id == null) {
      return custom.ErrorWidget(
        errorMessage: state.errorMessage!,
        onRetry: () {
          if (transactionId != null) {
            ref.read(addTransactionProvider(type).notifier).loadTransaction(transactionId!);
          }
        },
      );
    }

    // Show main form
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),

          // 1. AMOUNT FIELD (Large, Prominent)
          _buildAmountField(
            controller: amountController,
            primaryColor: primaryColor,
            formatter: currencyFormatter,
          ),

          SizedBox(height: 32.h),

          // 2. CATEGORY
          _buildListTile(
            icon: FontAwesomeIcons.basketShopping,
            label: "Category",
            value: state.selectedCategory?.name ?? "Select Category",
            valueColor: state.selectedCategory != null ? Colors.black : Colors.grey,
            onTap: () => _showCategoryPicker(context, ref, categories, primaryColor),
          ),

          // 3. DATE
          _buildListTile(
            icon: FontAwesomeIcons.calendarDays,
            label: "Date",
            value: _formatDate(context, state.selectedDate, state.selectedTime),
            onTap: () => _showDatePicker(context, ref, state.selectedDate, state.selectedTime),
          ),

          // 4. NOTE
          _buildNoteField(
            controller: noteController,
            primaryColor: primaryColor,
          ),

          SizedBox(height: 100.h),
        ],
      ),
    );

  }

  // --- Specific Widgets for the Design ---

  Widget _buildAmountField({
    required TextEditingController controller,
    required Color primaryColor,
    required TextInputFormatter formatter,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [formatter],
      style: TextStyle(
        fontSize: 40.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: "\$0.00",
        hintStyle: TextStyle(
          fontSize: 40.sp,
          fontWeight: FontWeight.bold,
          color: Colors.grey.withOpacity(0.3),
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String label,
    required String value,
    Color valueColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                FaIcon(icon, color: Colors.grey, size: 20.sp),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyleHelper.textStyle16(
                      color: valueColor,
                      fontWeight: valueColor == Colors.grey ? FontWeight.w400 : FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
      ],
    );
  }

  Widget _buildNoteField({
    required TextEditingController controller,
    required Color primaryColor,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              FaIcon(FontAwesomeIcons.pen, color: Colors.grey, size: 20.sp),
              SizedBox(width: 16.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyleHelper.textStyle16(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: "Write a note (Optional)",
                    hintStyle: TextStyleHelper.textStyle16(color: Colors.grey),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
      ],
    );
  }

  // --- Unchanged Helper Methods ---

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
                        ref.read(addTransactionProvider(type).notifier).setDate(picked);
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
                      )
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
      return "Today, ${date.day} ${_getMonthAbbreviation(date.month)}, ${date.year}";
    }
    return "${date.day} ${_getMonthAbbreviation(date.month)}, ${date.year}";
  }

  String _getMonthAbbreviation(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
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
              color: category.color.withOpacity(0.12),
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