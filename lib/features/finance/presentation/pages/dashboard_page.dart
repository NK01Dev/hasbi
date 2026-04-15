import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hasbi/core/theme/app_colors.dart';
import 'package:hasbi/features/finance/presentation/views/goals_view.dart';
import 'package:hasbi/features/finance/presentation/views/home_view.dart';
import 'package:hasbi/features/finance/presentation/views/stats_view.dart';
import 'package:hasbi/features/finance/presentation/views/transaction_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/router/app_route_paths.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/states/auth_state.dart';
import '../../providers/dashboard_nav_provider.dart';
import '../views/debts_view.dart';
import '../widgets/curved_nav_bar.dart';
import '../widgets/expandable_fab.dart';

class DashboardPage extends HookConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final index = ref.watch(navIndexProvider);
    final pageController = usePageController(initialPage: index);

    ref.listen<int>(navIndexProvider, (prev, next) {
      pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
    // Logout Listener
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthStateUnauthenticated) {
        context.go(AppRoutePaths.root);
      }
    });

    final pages = [
      HomeView(),
      const StatsView(),
      TransactionView(),
      GoalsView(),
      DebtsView(),
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
      floatingActionButton: ExpandableFab(
        // --- Add Transaction ---
        onTransaction: () => context.push(AppRoutePaths.addExpense),
        // --- Add Goals ---
        onGoals: () => context.push(AppRoutePaths.addGoal),
        // --- Add Debts ---
        onDebts: () => context.push(AppRoutePaths.addDebt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: AppColors.surface,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: SalomonNavBar(),
        ),
      ),
    );
  }
}
