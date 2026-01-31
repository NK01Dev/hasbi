import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/widgets/loading_widget.dart';
import '../../../../core/common/widgets/error_widget.dart' as custom;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/models/category_model.dart';
import '../../data/models/finance_enums.dart';
import '../../providers/add_goal_provider.dart';
import '../../providers/goals_provider.dart';
import '../../utils/date_format_helper.dart';
import '../widgets/amount_input_field.dart';
import '../widgets/transaction_field_tile.dart';
import '../widgets/note_input_field.dart';
import '../widgets/category_picker_sheet.dart';
import '../widgets/date_time_picker_sheet.dart';

class AddGoalView extends HookConsumerWidget {
  final String? goalId;

  const AddGoalView({super.key, this.goalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addGoalProvider);
    final notifier = ref.read(addGoalProvider.notifier);

    // Initialize controllers
    final titleController = useTextEditingController(text: "");
    final targetController = useTextEditingController(text: "");
    final currentController = useTextEditingController(
      text: "",
    ); // Removed current amount edit for simplicity in MVP, or can add back if needed

    // Logic to set controllers when data loads
    useEffect(() {
      if (goalId != null && state.id == null && !state.isLoading) {
        Future.microtask(() => notifier.loadGoal(goalId!));
      }
      return null;
    }, [goalId]);

    // Update controllers when state changes (one-way sync on load)
    useEffect(() {
      if (state.id != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state.title.isNotEmpty && titleController.text != state.title) {
            titleController.text = state.title;
          }
          if (state.targetAmount.isNotEmpty &&
              targetController.text != state.targetAmount) {
            targetController.text = state.targetAmount;
          }
          if (state.currentAmount.isNotEmpty &&
              currentController.text != state.currentAmount) {
            currentController.text = state.currentAmount;
          }
        });
      }
      return null;
    }, [state.id]);

    // Currency Formatter
    final currencyFormatter = CurrencyTextInputFormatter.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 0,
      enableNegative: false,
    );

    // Categories (reuse income/expense or define goal specific?)
    // Using expense categories for now as they represent spending/saving areas
    final categories = AppCategories.getExpenseCategories();
    final selectedCategory = categories.firstWhere(
      (c) => c.name.toLowerCase() == state.categoryId.toLowerCase(),
      orElse: () => categories.first,
    );

    final isEditing = goalId != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black, size: 24.sp),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEditing ? "Edit Goal" : "New Goal",
          style: TextStyleHelper.textStyle18(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        // actions: [
        //   TextButton(
        //     onPressed: state.isLoading
        //         ? null
        //         : () async {
        //             final success = await notifier.saveGoal(
        //               title: titleController.text,
        //               targetAmount: targetController.text,
        //               currentAmount: currentController.text,
        //             );
        //             if (context.mounted) {
        //               if (success) {
        //                 Navigator.pop(context);
        //               } else {
        //                 final errorMsg = ref.read(addGoalProvider).errorMessage;
        //                 if (errorMsg != null) {
        //                   ScaffoldMessenger.of(context).showSnackBar(
        //                     SnackBar(
        //                       content: Text(errorMsg),
        //                       backgroundColor: Colors.red,
        //                     ),
        //                   );
        //                 }
        //               }
        //             }
        //           },
        //     child: state.isLoading
        //         ? SizedBox(
        //             width: 20.w,
        //             height: 20.w,
        //             child: CircularProgressIndicator(
        //               strokeWidth: 2,
        //               color: AppColors.primary,
        //             ),
        //           )
        //         : Text(
        //             "Save",
        //             style: TextStyleHelper.textStyle16(
        //               color: AppColors.primary,
        //               fontWeight: FontWeight.w600,
        //             ),
        //           ),
        //   ),
        // ],
      ),
      body: _buildBody(
        context,
        ref,
        state,
        notifier,
        titleController,
        targetController,
        currentController,
        currencyFormatter,
        categories,
        selectedCategory,
        isEditing,
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AddGoalState state,
    AddGoalNotifier notifier,
    TextEditingController titleController,
    TextEditingController targetController,
    TextEditingController currentController,
    TextInputFormatter formatter,
    List<CategoryModel> categories,
    CategoryModel selectedCategory,
    bool isEditing,
  ) {
    if (state.isLoading && state.id == null && isEditing) {
      return const LoadingWidget(message: "Loading goal...");
    }

    if (state.errorMessage != null && state.id == null && isEditing) {
      return custom.ErrorWidget(
        errorMessage: state.errorMessage!,
        onRetry: () => notifier.loadGoal(goalId!),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),

          // Target Amount
          AmountInputField(
            controller: targetController,
            formatter: formatter,
            primaryColor: AppColors.primary,
            hintText: "\$0",
            title: "Target Amount",
          ),

          SizedBox(height: 20.h),

          // Title
          NoteInputField(
            controller: titleController,
            hintText: "Goal Title (e.g. New Car)",
            icon: FontAwesomeIcons.bullseye,
          ),
          Divider(height: 1, color: Colors.grey.withOpacity(0.2)),

          SizedBox(height: 20.h),

          // Category
          TransactionFieldTile(
            icon: selectedCategory.icon,
            label: "Category",
            value: selectedCategory.name,
            iconColor: selectedCategory.color,
            onTap: () {
              CategoryPickerSheet.show(
                context: context,
                ref: ref,
                categories: categories,
                selectedCategory: selectedCategory, // Pass current
                onCategorySelected: (cat) => notifier.setCategoryId(cat.id),
              );
            },
          ),
          SizedBox(height: 20.h),

          // 3. DATE
          TransactionFieldTile(
            icon: FontAwesomeIcons.calendarDays,
            label: "Deadline",
            value: DateFormatHelper.formatDate(state.deadline),
            onTap: () => DateTimePickerSheet.show(
              context: context,
              ref: ref,
              currentDate: state.deadline,
              currentTime: state.selectedTime,
              onDateChanged: (date) => notifier.setDate(date),
              onTimeChanged: (time) => notifier.setTime(time),
            ),
          ),

          if (isEditing) ...[
            SizedBox(height: 20.h),
            _buildStatusDropdown(context, state.status, notifier),
            SizedBox(height: 20.h),
            // Current Amount (editable during edit)
            AmountInputField(
              controller: currentController,
              formatter: formatter,
              primaryColor: AppColors.primary,
              hintText: "\$0",
              title: "Current Amount",
            ),
          ],

          SizedBox(height: 40.h),
          ElevatedButton(

            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.cyan),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              fixedSize: MaterialStateProperty.all(Size(double.infinity, 50.h)),
            ),
    onPressed: state.isLoading
    ? null
        : () async {
    final success = await notifier.saveGoal(
    title: titleController.text,
    targetAmount: targetController.text,
    currentAmount: currentController.text,
    );
    if (context.mounted) {
    if (success) {
    context.pop();
    } else {
    final errorMsg = ref.read(addGoalProvider).errorMessage;
    if (errorMsg != null) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text(errorMsg),
    backgroundColor: Colors.red,
    ),
    );
    }
    }
    }
    },
    child: state.isLoading
    ? SizedBox(
    width: 20.w,
    height: 20.w,
    child: CircularProgressIndicator(
    strokeWidth: 2,
    color: AppColors.primary,
    ),
    )
        : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                 'Save',
                  style: TextStyleHelper.textStyle20(
                    color: AppColors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.black.withOpacity(0.8),
                  size: 24.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(
    BuildContext context,
    GoalStatus currentStatus,
    AddGoalNotifier notifier,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<GoalStatus>(
          value: currentStatus,
          isExpanded: true,
          items: GoalStatus.values.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(
                status.name.toUpperCase(),
                style: TextStyleHelper.textStyle14(
                  color: _getStatusColor(status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) notifier.setStatus(val);
          },
        ),
      ),
    );
  }

  Color _getStatusColor(GoalStatus status) {
    switch (status) {
      case GoalStatus.active:
        return AppColors.primary;
      case GoalStatus.reached:
        return AppColors.success;
      case GoalStatus.paused:
        return AppColors.warning;
      case GoalStatus.cancelled:
        return AppColors.error;
      case GoalStatus.failed:
        return AppColors.error;
      default:
        return Colors.black;
    }
  }
}
