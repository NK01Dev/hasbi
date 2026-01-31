import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
        ? (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0)
        : 0.0;

    final isCompleted = progress >= 1.0;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Slidable(
        key: ValueKey(goal.id),

        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                Slidable.of(context)?.close();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddGoalView(goalId: goal.id),
                  ),
                );
              },
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
              label: 'Edit',
              borderRadius: BorderRadius.circular(12.r),
            ),
            SlidableAction(
              onPressed: (_) {
                Slidable.of(context)?.close();
                _showDeleteDialog(context, ref);
              },
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12.r),
            ),
          ],
        ),

        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          goal.title,
                          style: TextStyleHelper.textStyle16(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _StatusChip(isCompleted: isCompleted),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  /// AMOUNT
                  Text(
                    "\$${goal.currentAmount.toStringAsFixed(0)} / \$${goal.targetAmount.toStringAsFixed(0)}",
                    style: TextStyleHelper.textStyle14(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  /// PROGRESS BAR (ANIMATED)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: progress),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      builder: (context, value, _) {
                        return LinearProgressIndicator(
                          value: value,
                          backgroundColor:
                          AppColors.grey.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            value >= 1.0
                                ? AppColors.success
                                : AppColors.primary,
                          ),
                          minHeight: 7.h,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Goal'),
        content:
        const Text('Are you sure you want to delete this goal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(goalsProvider.notifier).deleteGoal(goal.id);
              Navigator.pop(ctx);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
class _StatusChip extends StatelessWidget {
  final bool isCompleted;

  const _StatusChip({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.success.withOpacity(0.15)
            : AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        isCompleted ? 'Completed' : 'Active',
        style: TextStyleHelper.textStyle12(
          fontWeight: FontWeight.w600,
          color:
          isCompleted ? AppColors.success : AppColors.primary,
        ),
      ),
    );
  }
}

