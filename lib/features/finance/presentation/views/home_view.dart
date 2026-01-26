import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Core
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing_helper.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/states/auth_state.dart';
import '../../providers/home_provider.dart';
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

    return SingleChildScrollView(
      padding: SpacingHelper.pHMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SpacingHelper.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Hi, $userName",
                style: TextStyleHelper.textStyle16(
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "View all",
                style: TextStyleHelper.textStyle16(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: SpacingHelper.xs),


              Text(
                "\$ ${homeState.data?.balance.toStringAsFixed(2) ?? '0.00'}",
                style: TextStyleHelper.textStyle36(
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),

          SizedBox(height: SpacingHelper.lg),

          // Row for Income and Expense
          Row(
            children: [
              Expanded(
                child: FinanceStat(
                  label: 'Income',
                  amount: '\$ ${homeState.data?.totalIncome.toStringAsFixed(2) ?? '0.00'}',
                  iconData: Icons.arrow_upward,
                  color: Color(0xff22c55e),
                  bgColor: Color(0xffdcfce7),
                ),
              ),
              SizedBox(width: SpacingHelper.sm),
              Expanded(
                child: FinanceStat(
                  label: 'Expense',
                  amount: '\$ ${homeState.data?.totalExpense.toStringAsFixed(2) ?? '0.00'}',
                  iconData: Icons.arrow_downward,
                  color: Color(0xffef4444),
                  bgColor: Color(0xfffee2e2),
                ),
              ),
            ],
          ),

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

          /// --- FLAT CHART CARD ---
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: SizedBox(
              height: 280.h,
              width: double.infinity,
              child: FinancePieChart(
                financeData: homeState.data,
                touchedIndex: homeState.touchedIndex,
                sections: sections,
                onSectionTouched: homeNotifier.setTouchedIndex,
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}