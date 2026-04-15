import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import '../../../../core/common/widgets/loading_widget.dart';
import '../../../../core/common/widgets/error_widget.dart' as custom;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/models/category_model.dart';
import '../../data/models/finance_enums.dart';

import '../../providers/add_transaction_provider.dart';
import '../../utils/date_format_helper.dart';
import '../widgets/amount_input_field.dart';

import '../widgets/category_picker_sheet.dart';
import '../widgets/date_time_picker_sheet.dart';

class AddTransactionView extends HookConsumerWidget {
  final TransactionType type;
  final String? transactionId;

  const AddTransactionView({super.key, required this.type, this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Local state for the toggle
    final currentType = useState<TransactionType>(type);

    final state = ref.watch(addTransactionProvider(currentType.value));
    final notifier = ref.read(
      addTransactionProvider(currentType.value).notifier,
    );

    // Initialize controllers
    final amountController = useTextEditingController();
    final noteController = useTextEditingController();

    final isExpense = currentType.value == TransactionType.expense;
    final primaryColor = isExpense
        ? const Color(0xFFF04A4C)
        : AppColors.success;

    final categories = currentType.value == TransactionType.income
        ? AppCategories.getIncomeCategories()
        : AppCategories.getExpenseCategories();

    // Currency Formatter
    final currencyFormatter = CurrencyTextInputFormatter.currency(
      locale: 'en_US',
      symbol: '', // We render $ manually
      decimalDigits: 2,
      enableNegative: true,
      inputDirection: InputDirection.left,
    );

    // Load Transaction Logic (Initial Load / Edit Mode)
    useEffect(() {
      if (transactionId != null && state.id == null && !state.isLoading) {
        Future.microtask(() => notifier.loadTransaction(transactionId!));
      }
      return null;
    }, [transactionId, currentType.value]);

    // Sync state -> controller
    useEffect(() {
      if (state.id != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state.amount.isNotEmpty &&
              amountController.text != state.amount) {
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
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Center(
            child: InkWell(
              onTap: () => context.pop(),
              borderRadius: BorderRadius.circular(24.r),
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Icon(Icons.arrow_back, color: Colors.black, size: 20.sp),
              ),
            ),
          ),
        ),
        title: Text(
          isEditing ? "Edit Transaction" : "New Transaction",
          style: TextStyleHelper.textStyle18(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(
        state: state,
        isEditing: isEditing,
        amountController: amountController,
        noteController: noteController,
        primaryColor: primaryColor,
        isExpense: isExpense,
        onTypeChanged: (newType) {
          if (isEditing) return; // Disallow changing type in edit mode
          currentType.value = newType;
        },
        currencyFormatter: currencyFormatter,
        categories: categories,
        context: context,
        ref: ref,
        notifier: notifier,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: SizedBox(
            height: 56.h,
            child: ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      final success = await notifier.saveTransaction(
                        amount: amountController.text,
                        note: noteController.text,
                      );
                      if (context.mounted) {
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isEditing ? 'Updated!' : 'Saved!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          context.pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.errorMessage ?? 'Failed'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: state.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      isEditing ? "Update Transaction" : "Save Transaction",
                      style: TextStyleHelper.textStyle16(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody({
    required AddTransactionState state,
    required bool isEditing,
    required TextEditingController amountController,
    required TextEditingController noteController,
    required Color primaryColor,
    required bool isExpense,
    required ValueChanged<TransactionType> onTypeChanged,
    required TextInputFormatter currencyFormatter,
    required List<CategoryModel> categories,
    required BuildContext context,
    required WidgetRef ref,
    required dynamic notifier,
  }) {
    if (isEditing && state.isLoading && state.id == null) {
      return const LoadingWidget(message: 'Loading transaction...');
    }
    if (state.errorMessage != null && state.id == null) {
      return custom.ErrorWidget(
        errorMessage: state.errorMessage!,
        onRetry: () {
          if (transactionId != null) notifier.loadTransaction(transactionId!);
        },
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20.h),

          // Toggle Switch
          if (!isEditing) _buildToggle(isExpense, onTypeChanged),

          SizedBox(height: 48.h),

          // Amount
          AmountInputField(
            controller: amountController,
            primaryColor: primaryColor,
            formatter: currencyFormatter,
          ),

          SizedBox(height: 48.h),

          // Category
          _buildFieldLabel("CATEGORY"),
          _buildContainerField(
            icon: FontAwesomeIcons.mugHot,
            iconColor: primaryColor,
            text: state.selectedCategory?.name ?? "Select Category",
            textColor: state.selectedCategory != null
                ? Colors.black
                : Colors.grey,
            onTap: () => CategoryPickerSheet.show(
              context: context,
              ref: ref,
              categories: categories,
              selectedCategory: state.selectedCategory,
              onCategorySelected: (cat) => notifier.setCategory(cat),
              accentColor: primaryColor,
            ),
            trailingIcon: FontAwesomeIcons.chevronDown,
          ),

          SizedBox(height: 24.h),

          // Date
          _buildFieldLabel("DATE"),
          _buildContainerField(
            icon: FontAwesomeIcons.calendar,
            iconColor: AppColors.primary,
            text: DateFormatHelper.formatDate(state.selectedDate),
            textColor: Colors.black,
            onTap: () => DateTimePickerSheet.show(
              context: context,
              ref: ref,
              currentDate: state.selectedDate,
              currentTime: state.selectedTime,
              onDateChanged: (date) => notifier.setDate(date),
              onTimeChanged: (time) => notifier.setTime(time),
            ),
            trailingIcon: FontAwesomeIcons.chevronDown,
          ),

          SizedBox(height: 24.h),

          // Note
          _buildFieldLabel("NOTE"),
          _buildNoteField(noteController),

          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildToggle(bool isExpense, ValueChanged<TransactionType> onChanged) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(TransactionType.expense),
              child: Container(
                decoration: BoxDecoration(
                  color: isExpense ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: isExpense
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Expense",
                  style: TextStyleHelper.textStyle14(
                    fontWeight: isExpense ? FontWeight.w600 : FontWeight.w500,
                    color: isExpense ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(TransactionType.income),
              child: Container(
                decoration: BoxDecoration(
                  color: !isExpense ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: !isExpense
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Income",
                  style: TextStyleHelper.textStyle14(
                    fontWeight: !isExpense ? FontWeight.w600 : FontWeight.w500,
                    color: !isExpense ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: Colors.grey.withOpacity(0.8),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildContainerField({
    required IconData icon,
    required Color iconColor,
    required String text,
    required Color textColor,
    required VoidCallback onTap,
    IconData? trailingIcon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: FaIcon(icon, color: iconColor, size: 14.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style: TextStyleHelper.textStyle16(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailingIcon != null)
              FaIcon(
                trailingIcon,
                color: Colors.grey.withOpacity(0.6),
                size: 14.sp,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteField(TextEditingController controller) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: FaIcon(
              FontAwesomeIcons.alignLeft,
              color: Colors.grey,
              size: 14.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Add a note...",
                hintStyle: TextStyleHelper.textStyle16(
                  color: Colors.grey.withOpacity(0.8),
                ),
                border: InputBorder.none,
              ),
              style: TextStyleHelper.textStyle16(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
