import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hasbi/core/theme/app_colors.dart';
import 'package:hasbi/features/finance/presentation/views/goals_view.dart';
import 'package:hasbi/features/finance/presentation/views/home_view.dart';
import 'package:hasbi/features/finance/presentation/views/stats_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/router/app_route_paths.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/states/auth_state.dart';
import '../../../auth/presentation/widgets/home_header_widget.dart';
import '../../data/models/category_model.dart';
import '../../providers/dashboard_nav_provider.dart';
import '../views/add_goals.dart';
import '../views/add_transaction_view.dart';
import '../views/debts_view.dart';
import '../widgets/curved_nav_bar.dart';
import '../widgets/expandable_fab.dart';

class DashboardPage extends HookConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final index = ref.watch(navIndexProvider);


    // Logout Listener
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthStateUnauthenticated) {
        context.go(AppRoutePaths.root);
      }
    });

    final pages = [
      HomeView(),
      const StatsView(),
      GoalsView(),
      DebtsView(),
    ];

    return Scaffold(

      // Slide-out Drawer for Logout
      body: IndexedStack(index: index, children: pages),
      // 1. Define the FAB here
      floatingActionButton: ExpandableFab(
        // onIncome: () => context.push(AppRoutePaths.income),
        // --- Add Income ---
        onIncome: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionView(type: TransactionType.income),
            ),
          );
        },

// --- Add Expense ---
        onExpense: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionView(type: TransactionType.expense),
            ),
          );
        },
        // --- Add Goals (FIXED) ---
        onGoals: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddGoalView(),
            ),
          );
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: BottomAppBar(
          shape:
          const CircularNotchedRectangle(), // Creates the notch for the FAB
          notchMargin: 8.0, // Adjusted for better fit
          color: AppColors.background,

          child: SizedBox(
            height: 60.h,
            child: Row(
              children: [
                // 80% Width for Navigation Items
                Expanded(flex: 4, child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: SalomonNavBar())),
                // 20% Width Empty Space (Where FAB sits)
                const Expanded(flex: 1, child: SizedBox()),
              ],
            ),
          ),
        ),
    );
  }
}
