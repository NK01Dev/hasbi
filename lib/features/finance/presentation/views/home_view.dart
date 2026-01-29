import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

// Core
import '../../../../core/common/widgets/empty_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing_helper.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../generated/assets.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/states/auth_state.dart';
import '../../../auth/presentation/widgets/home_header_widget.dart';
import '../../providers/home_provider.dart';
import '../widgets/dashboard_animations.dart';
import '../widgets/finance_pie_chart.dart';
import '../widgets/finance_stat.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);
    final sections = homeNotifier.getExpensePieSections();

    final userId = authState.maybeWhen(
      authenticated: (user) => user.id,
      orElse: () => '',
    );

    final userName = authState.maybeWhen(
      authenticated: (user) => user.fullName,
      orElse: () => "User",
    );

    // 1. Loading State
    if (homeState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 2. Error State
    if (homeState.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48.sp, color: AppColors.error),
              SizedBox(height: 16.h),
              Text(
                'Failed to load data',
                style: TextStyleHelper.textStyle16(color: AppColors.textSecondary),
              ),
              SizedBox(height: 8.h),
              ElevatedButton(
                onPressed: () => homeNotifier.loadFinanceData(userId),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Empty State - No transactions yet
    final hasAnyData = homeState.data != null &&
        (homeState.data!.totalIncome > 0 || homeState.data!.totalExpense > 0);

    if (!hasAnyData) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 1,
          toolbarHeight: 100.h,
          title: const HomeHeaderWidget(),
        ),
        body: EmptyWidget(
          message: 'No transactions yet.\nTap + to add your first income or expense!',
          lottieAsset: Assets.animationsEmpty,
        ),
      );
    }

    // 4. Data State - Show Dashboard
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 1,
        toolbarHeight: 100.h,
        title: const HomeHeaderWidget(),
      ),
      body: SingleChildScrollView(
        padding: SpacingHelper.pHMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SpacingHelper.sm),

            // Balance Card
            StaggeredEntrance(
              index: 1,
              child: Container(
                padding: SpacingHelper.pAllSmall,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Current Wallet Balance",
                        style: TextStyleHelper.textStyle14(color: AppColors.textSecondary),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedNumberText(
                          value: homeState.data?.totalBalance ?? 0.0,
                          style: TextStyleHelper.textStyle36(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (homeState.data != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: (homeState.data?.balancePercentageChange ?? 0) >= 0
                                  ? AppColors.success.withOpacity(0.1)
                                  : AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  (homeState.data?.balancePercentageChange ?? 0) >= 0
                                      ? Icons.trending_up
                                      : Icons.trending_down,
                                  size: 14.sp,
                                  color: (homeState.data?.balancePercentageChange ?? 0) >= 0
                                      ? AppColors.success
                                      : AppColors.error,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "${(homeState.data?.balancePercentageChange ?? 0).abs().toStringAsFixed(1)}%",
                                  style: TextStyleHelper.textStyle12(
                                    color: (homeState.data?.balancePercentageChange ?? 0) >= 0
                                        ? AppColors.success
                                        : AppColors.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: SpacingHelper.lg),
                    Row(
                      children: [
                        Expanded(
                          child: FinanceStat(
                            label: 'Income',
                            amount: '\$ ${homeState.data?.totalIncome.toStringAsFixed(2) ?? '0.00'}',
                            iconData: Icons.trending_up_outlined,
                            color: const Color(0xff22c55e),
                            bgColor: const Color(0xffdcfce7),
                          ),
                        ),
                        SizedBox(width: SpacingHelper.sm),
                        Expanded(
                          child: FinanceStat(
                            label: 'Expense',
                            amount: '\$ ${homeState.data?.totalExpense.toStringAsFixed(2) ?? '0.00'}',
                            iconData: Icons.trending_down_outlined,
                            color: const Color(0xffef4444),
                            bgColor: const Color(0xfffee2e2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: SpacingHelper.xl),

            // Chart Section
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Expense Chart',
                  style: TextStyleHelper.textStyle18(color: Colors.black),
                ),
                SizedBox(
                  width: 130.w,
                  child: DropdownButtonFormField<FinanceFilter>(
                    isExpanded: true,
                    value: homeState.selectedFilter,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    items: FinanceFilter.values.map((filter) {
                      return DropdownMenuItem(
                        value: filter,
                        child: Text(
                          filter.name.toUpperCase(),
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      );
                    }).toList(),
                    onChanged: (FinanceFilter? newValue) {
                      if (newValue != null && userId.isNotEmpty) {
                        homeNotifier.setFilter(newValue, userId);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Chart or Empty
            if (sections.isEmpty)
              Container(
                width: double.infinity,
                height: 200.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Lottie.asset(Assets.animationsEmpty)),
                      SizedBox(height: 8.h),
                      Text(
                        'No expenses for this period',
                        style: TextStyleHelper.textStyle14(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: SizedBox(
                  height: 350.h,
                  width: double.infinity,

                  child: FinancePieChart(
                    financeData: homeState.data,
                    touchedIndex: homeState.touchedIndex,
                    onSectionTouched: homeNotifier.setTouchedIndex,
                  ),
                ),
              ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}