import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Core
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/spacing_helper.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/states/auth_state.dart';
import '../../providers/mocking_finance_provider.dart';
import '../widgets/finance_pie_chart.dart';
import '../widgets/finance_stat.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    // Watch the current state
    final financeState = ref.watch(financeProvider);
    final notifier = ref.read(financeProvider.notifier); // Get User Name helper
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
                "Total Balance",
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
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,

            children: [
              Icon(
                Icons.attach_money,
                color: Colors.black,
                size: SpacingHelper.xl,
              ),
              Text(
                "3000.00",
                style: TextStyleHelper.textStyle36(
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
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
                  amount: r'$ 30,000',                  iconData: Icons.arrow_upward,
                  color: Color(0xff22c55e),
                  bgColor: Color(0xffdcfce7),
                ),
              ),
              SizedBox(width: SpacingHelper.sm),
              Expanded(
                child: FinanceStat(
                  label: 'Expense',
                  amount: r'$ 48,000',                  iconData: Icons.arrow_downward,
                  color: Color(0xffef4444),
                  bgColor: Color(0xfffee2e2),
                ),
              ),
            ],
          ),

          // // --- Balance Card (Example) ---
          // Container(
          //   width: double.infinity,
          //   padding: EdgeInsets.all(SpacingHelper.lg),
          //   decoration: BoxDecoration(
          //     gradient: AppColors.primaryGradient,
          //     borderRadius: BorderRadius.circular(20.r),
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text("Total Balance", style: TextStyleHelper.textStyle14(color: Colors.white70)),
          //       SizedBox(height: SpacingHelper.xs),
          //       Text("\$7,765.00", style: TextStyleHelper.textStyle36(color: Colors.white, fontWeight: FontWeight.bold)),
          //     ],
          //   ),
          // ),
          SizedBox(height: SpacingHelper.xl),

          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment:
                CrossAxisAlignment.center, // Align items vertically
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expense Chart',
                style: TextStyleHelper.textStyle18(color: Colors.black),
              ),

              // FIX: Wrap the dropdown in a SizedBox
              SizedBox(
                width: 130.w, // Give it a specific width using ScreenUtil
                child: DropdownButtonFormField<FinanceFilter>(
                  isExpanded:
                      true, // Ensures the text doesn't overflow inside the dropdown
                  value: financeState.selectedFilter,
                  decoration: InputDecoration(
                    // Use a smaller padding and font for the compact filter look
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
                    if (newValue != null) {
                      notifier.setFilter(newValue);
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
              color: AppColors.white, // Pure white background
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: Colors.grey.shade100), // Subtle border
              // No box shadow / No elevation
            ),
            child: SizedBox(
              height: 280.h, // Adjusted height
              width: double.infinity, // Ensure it fills the width

              child: const FinancePieChart(),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
