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
import '../../utils/date_format_helper.dart';
import '../widgets/amount_input_field.dart';
import '../widgets/transaction_field_tile.dart';
import '../widgets/note_input_field.dart';
import '../widgets/category_picker_sheet.dart';
import '../widgets/date_time_picker_sheet.dart';

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
  })
  {
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
          AmountInputField(
            controller: amountController,
            primaryColor: primaryColor,
            formatter: currencyFormatter,
          ),

          SizedBox(height: 32.h),

          // 2. CATEGORY
          TransactionFieldTile(
            icon: FontAwesomeIcons.basketShopping,
            label: "Category",
            value: state.selectedCategory?.name ?? "Select Category",
            valueColor: state.selectedCategory != null ? Colors.black : Colors.grey,
            onTap: () => CategoryPickerSheet.show(
              context: context,
              ref: ref,
              categories: categories,
              selectedCategory: state.selectedCategory,
              onCategorySelected: (cat) => ref.read(addTransactionProvider(type).notifier).setCategory(cat),
              accentColor: primaryColor,
            ),
          ),

          // 3. DATE
          TransactionFieldTile(
            icon: FontAwesomeIcons.calendarDays,
            label: "Date",
            value: DateFormatHelper.formatDate(state.selectedDate),
            onTap: () => DateTimePickerSheet.show(
              context: context,
              ref: ref,
              currentDate: state.selectedDate,
              currentTime: state.selectedTime,
              onDateChanged: (date) => ref.read(addTransactionProvider(type).notifier).setDate(date),
              onTimeChanged: (time) => ref.read(addTransactionProvider(type).notifier).setTime(time),
            ),
          ),

          // 4. NOTE
          NoteInputField(
            controller: noteController,
            primaryColor: primaryColor,
          ),

          SizedBox(height: 100.h),
        ],
      ),
    );

  }

}