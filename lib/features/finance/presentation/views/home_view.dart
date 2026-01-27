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

    return SingleChildScrollView(
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
// import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
//
// // Core
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/theme/spacing_helper.dart';
// import '../../../../core/theme/text_styles.dart';
// import '../../../auth/presentation/providers/auth_provider.dart';
// import '../../../auth/presentation/states/auth_state.dart';
// import '../../providers/home_provider.dart';
// import '../widgets/finance_pie_chart.dart';
// import '../widgets/finance_stat.dart';
// import '../widgets/dashboard_animations.dart';
//
// class HomeView extends HookConsumerWidget {
//   const HomeView({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authProvider);
//     final homeState = ref.watch(homeProvider);
//     final homeNotifier = ref.read(homeProvider.notifier);
//     final sections = homeNotifier.getExpensePieSections();
//
//     // Get the current user ID from auth state
//     final userId = authState.maybeWhen(
//       authenticated: (user) => user.id,
//       orElse: () => '',
//     );
//
//     if (homeState.isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     final userName = authState.maybeWhen(
//       authenticated: (user) => "${user.fullName}",
//       orElse: () => "User",
//     );
//
//     return SingleChildScrollView(
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           // --- GLASSMORPHIC WALLET CARD ---
//           StaggeredEntrance(
//             index: 1,
//             child: Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(24.w),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     AppColors.primary,
//                     AppColors.primary.withRed(100), // Slightly warmer tone
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(32.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.primary.withOpacity(0.3),
//                     blurRadius: 20,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Total Balance",
//                         style: TextStyleHelper.textStyle14(
//                           color: Colors.white70,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       Icon(Icons.account_balance_wallet_outlined, color: Colors.white70, size: 20.sp),
//                     ],
//                   ),
//                   SizedBox(height: 8.h),
//                   AnimatedNumberText(
//                     value: homeState.data?.totalBalance ?? 0.0,
//                     style: TextStyleHelper.textStyle36(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 24.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _buildBalanceDetail(
//                         label: "Income",
//                         value: homeState.data?.totalIncome ?? 0.0,
//                         icon: Icons.arrow_downward,
//                         color: Colors.greenAccent,
//                       ),
//                       Container(width: 1, height: 40, color: Colors.white24),
//                       _buildBalanceDetail(
//                         label: "Expenses",
//                         value: homeState.data?.totalExpense ?? 0.0,
//                         icon: Icons.arrow_upward,
//                         color: Colors.redAccent,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           SizedBox(height: 32.h),
//
//           // --- STATS ROW ---
//           StaggeredEntrance(
//             index: 2,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: FinanceStat(
//                     label: 'Income',
//                     amount: (homeState.data?.totalIncome ?? 0.0).toString(),
//                     iconData: Icons.trending_up_outlined,
//                     color: Color(0xff22c55e),
//                     bgColor: Color(0xffdcfce7),
//                   ),
//                 ),
//                 SizedBox(width: 16.w),
//                 Expanded(
//                   child: FinanceStat(
//                     label: 'Expense',
//                     amount: (homeState.data?.totalExpense ?? 0.0).toString(),
//                     iconData: Icons.trending_down_outlined,
//                     color: Color(0xffef4444),
//                     bgColor: Color(0xfffee2e2),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           SizedBox(height: 32.h),
//
//           // --- CHART SECTION ---
//           StaggeredEntrance(
//             index: 3,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Expense Analytics',
//                       style: TextStyleHelper.textStyle18(
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.black,
//                       ),
//                     ),
//                     _buildFilterDropdown(homeState, userId, homeNotifier),
//                   ],
//                 ),
//                 SizedBox(height: 20.h),
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.all(24.w),
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     borderRadius: BorderRadius.circular(32.r),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 20,
//                         offset: const Offset(0, 10),
//                       ),
//                     ],
//                   ),
//                   child: SizedBox(
//                     height: 280.h,
//                     child: FinancePieChart(
//                       financeData: homeState.data,
//                       touchedIndex: homeState.touchedIndex,
//                       sections: sections,
//                       onSectionTouched: homeNotifier.setTouchedIndex,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 32.h),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBalanceDetail({
//     required String label,
//     required double value,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Row(
//       children: [
//         Container(
//           padding: EdgeInsets.all(8.w),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.2),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(icon, color: color, size: 16.sp),
//         ),
//         SizedBox(width: 12.w),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(label, style: TextStyleHelper.textStyle12(color: Colors.white70)),
//             AnimatedNumberText(
//               value: value,
//               style: TextStyleHelper.textStyle16(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFilterDropdown(FinanceState state, String userId, HomeNotifier notifier) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<FinanceFilter>(
//           value: state.selectedFilter,
//           icon: Icon(Icons.keyboard_arrow_down, size: 20.sp),
//           items: FinanceFilter.values.map((filter) {
//             return DropdownMenuItem(
//               value: filter,
//               child: Text(filter.name.toUpperCase(), style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
//             );
//           }).toList(),
//           onChanged: (newValue) {
//             if (newValue != null && userId.isNotEmpty) {
//               notifier.setFilter(newValue, userId);
//             }
//           },
//         ),
//       ),
//     );
//   }
// }