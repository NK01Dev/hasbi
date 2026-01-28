import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Core
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing_helper.dart';
import '../../../../core/theme/text_styles.dart';
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

// Get the current user ID from auth state
    final userId = authState.maybeWhen(
      authenticated: (user) => user.id,
      orElse: () => '',
    );

    if (homeState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final userName = authState.maybeWhen(
      authenticated: (user) => "${user.fullName}",
      orElse: () => "User",
    );

    return Scaffold(
        appBar: AppBar(
      backgroundColor: AppColors.background,
      elevation: 1,
      toolbarHeight: 100.h, // Adjust height as needed
      title: const HomeHeaderWidget(),
    ),

      body: SingleChildScrollView(
        padding: SpacingHelper.pHMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SpacingHelper.sm),

            StaggeredEntrance(
              index: 1,
              child: Container(
                padding: SpacingHelper.pAllSmall,
                decoration: BoxDecoration(
                  color: AppColors.white, // Pure white background
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: Colors.grey.shade200), // Subtle
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
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

                      ],
                    ),

                    SizedBox(height: SpacingHelper.lg),

                    // Row for Income and Expense
                    Row(
                      children: [
                        Expanded(
                          child: FinanceStat(
                            label: 'Income',
                            amount: '\$ ${homeState.data?.totalIncome.toStringAsFixed(2) ?? '0.00'}',
                            iconData: Icons.trending_up_outlined,
                            color: Color(0xff22c55e),
                            bgColor: Color(0xffdcfce7),
                          ),
                        ),
                        SizedBox(width: SpacingHelper.sm),
                        Expanded(
                          child: FinanceStat(
                            label: 'Expense',
                            amount: '\$ ${homeState.data?.totalExpense.toStringAsFixed(2) ?? '0.00'}',
                            iconData: Icons.trending_down_outlined,
                            color: Color(0xffef4444),
                            bgColor: Color(0xfffee2e2),
                          ),
                        ),
                      ],
                    ),


                  ],
                ),
              ),
            ),
            /// --- FLAT CHART CARD ---

            SizedBox(height: SpacingHelper.xl),

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

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w), // Balanced padding
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
                height: 300.h, // Slightly increased to prevent label compression
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
      ) ,
    )
     ;
  }
}