import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/models/goal_model.dart';
import '../../providers/goals_provider.dart';
import '../views/add_goal_view.dart';

class GoalProgressItem extends ConsumerWidget {
  final GoalModel goal;

  const GoalProgressItem({super.key, required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = goal.targetAmount > 0
        ? (goal.currentAmount / goal.targetAmount * 100).clamp(0.0, 100.0)
        : 0.0;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Title and Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  goal.title,
                  style: TextStyleHelper.textStyle16(fontWeight: FontWeight.bold),
                ),
              ),
              // --- ACTION BUTTONS ---
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, size: 20.w, color: AppColors.primary),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () {
                      // Navigate to Edit View
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddGoalView(goalId: goal.id),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 16.w),
                  IconButton(
                    icon: Icon(Icons.delete_outline, size: 20.w, color: AppColors.error),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () {
                      // Show Confirmation Dialog
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Goal'),
                          content: const Text('Are you sure you want to delete this goal?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Call Delete from Provider
                                ref.read(goalsProvider.notifier).deleteGoal(goal.id);
                                Navigator.pop(ctx);
                              },
                              child: const Text('Delete', style: TextStyle(color: AppColors.error)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 12.h),

          // Amount Text
          Text(
            "\$${goal.currentAmount.toStringAsFixed(0)} / \$${goal.targetAmount.toStringAsFixed(0)}",
            style: TextStyleHelper.textStyle14(color: AppColors.textSecondary),
          ),

          SizedBox(height: 8.h),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: AppColors.grey.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 100 ? AppColors.success : AppColors.primary,
              ),
              minHeight: 6.h,
            ),
          ),
        ],
      ),
    );
  }
}