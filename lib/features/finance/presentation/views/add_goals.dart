import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class AddGoalView extends HookConsumerWidget {
  const AddGoalView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooks for text editing
    final titleController = useTextEditingController();
    final amountController = useTextEditingController();

    // Hook for Date
    final selectedDate = useState<DateTime>(DateTime.now());

    final currencyFormat = NumberFormat.currency(symbol: '\$ ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy');

    // Reset logic
    useEffect(() {
      return () {
        // Clear controllers when leaving
        titleController.clear();
        amountController.clear();
      };
    }, []);

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
          "Create New Goal",
          style: TextStyleHelper.textStyle18(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Implement Save Logic
              final title = titleController.text.trim();
              final amount = double.tryParse(amountController.text) ?? 0.0;

              if (title.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter a goal name")),
                );
                return;
              }

              if (amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter a valid amount")),
                );
                return;
              }

              // Call provider logic here, e.g.:
              // ref.read(goalsProvider.notifier).addGoal(...);

              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: TextStyleHelper.textStyle16(
                color: AppColors.primary, // Using Primary brand color
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
Text('Goal name', style: TextStyleHelper.textStyle16(color: AppColors.black,fontWeight: FontWeight.w400),),
            SizedBox(height: 12.h,),
            TextField(
              controller: titleController,

              decoration: InputDecoration(
                filled: true,
fillColor: AppColors.grey.withOpacity(0.1),
                hintText: 'Enter goal name',
                hintStyle: TextStyleHelper.textStyle16(color: AppColors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,


                ),
              ),
            )
,            SizedBox(height: 12.h,),
            Text('Target amount', style: TextStyleHelper.textStyle16(color: AppColors.black,fontWeight: FontWeight.w400),),
                    SizedBox(height: 12.h,),

            TextField(
              controller: amountController,

              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.grey.withOpacity(0.1),
                hintText: 'Enter amount',
                hintStyle: TextStyleHelper.textStyle16(color: AppColors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,


                ),
              ),
            )

,


          ],
        ),
      ),
    );
  }


}