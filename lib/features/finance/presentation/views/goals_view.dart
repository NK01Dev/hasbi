import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hasbi/core/common/widgets/empty_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/spacing_helper.dart';
import '../../data/models/goal_model.dart';
import '../../providers/goals_provider.dart';
import '../widgets/goal_chart_widget.dart';
import '../widgets/goal_progress_item.dart';
import 'add_goal_view.dart';

class GoalsView extends ConsumerWidget {
  const GoalsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(goalsProvider);

    // FIX 2: Accessing getters via state object
    final totalSaved = state.totalSaved;
    final totalTarget = state.totalTarget;

    final currencyFormat = NumberFormat.currency(symbol: '\$ ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: state.isLoading && state.goals.isEmpty
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: SpacingHelper.lg, vertical: SpacingHelper.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SpacingHelper.md),

              // --- Header Section ---
              _buildHeader(context, currencyFormat.format(totalSaved), totalSaved, totalTarget),

              SizedBox(height: SpacingHelper.xl),

              // --- Chart Section ---
              if (state.goals.isNotEmpty)
                _buildChartSection(state.goals),

              if (state.goals.isEmpty) ...[
                Center(
                  child: EmptyWidget(message: 'No goals yet. Start saving!')
                ),
                SizedBox(height: 100.h),
              ],

              SizedBox(height: SpacingHelper.xl),

              // --- Active Goals List ---
              if (state.goals.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active Goals',
                        style: TextStyleHelper.textStyle20(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SpacingHelper.md),

                  ...state.goals.map((goal) => Padding(
                    padding: EdgeInsets.only(bottom: SpacingHelper.md),
                    child: GoalProgressItem(goal: goal),
                  )),

                  SizedBox(height: 80.h), // Space for FAB
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String amount, double saved, double target) {
    final trend = (target > 0 ? (saved / target * 100) : 0).toStringAsFixed(0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SpacingHelper.lg),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.savings_outlined, color: Colors.white, size: 24.w),
              ),
              SizedBox(width: SpacingHelper.sm),
              Text(
                "Total Saved",
                style: TextStyleHelper.textStyle14(color: Colors.white70),
              ),
            ],
          ),
          SizedBox(height: SpacingHelper.md),
          Text(
            amount,
            style: TextStyleHelper.textStyle32(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: SpacingHelper.sm),
          Row(
            children: [
              Icon(Icons.arrow_upward, color: AppColors.successLight, size: 16.w),
              SizedBox(width: 4.w),
              Text(
                "$trend% of total goal reached",
                style: TextStyleHelper.textStyle12(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(List<GoalModel> goals) {
    return Container(
      padding: EdgeInsets.all(SpacingHelper.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            "Distribution",
            style: TextStyleHelper.textStyle16(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: SpacingHelper.md),
          SizedBox(
            height: 200.h,
            // FIX 3: Explicitly passing List<GoalModel>
            child: GoalChartWidget(goals: goals),
          ),
        ],
      ),
    );
  }
}