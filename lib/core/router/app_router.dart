import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hasbi/features/finance/presentation/pages/dashboard_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Config
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/states/auth_state.dart';
import '../../features/finance/data/models/finance_enums.dart';

import '../../features/finance/presentation/views/add_goal_view.dart';
import '../../features/finance/presentation/views/add_transaction_view.dart';
import '../../features/finance/presentation/views/debt_transaction.dart';
import '../../features/finance/presentation/views/profile_view.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../storage/hive_service.dart';
import 'app_route_paths.dart';
import 'app_transitions.dart';

final appRouteProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutePaths.root,
    refreshListenable: RouterRefreshListenable(ref),
    redirect: _handleRootRedirect,
    routes: [
      GoRoute(
        path: AppRoutePaths.root,
        builder: (context, state) => const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      // --- AUTH FLOW ---
      GoRoute(
        path: AppRoutePaths.onboarding,
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: const OnboardingPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.login,
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.register,
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.profile,
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: const ProfileView(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.forgotPassword,
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: const ForgotPasswordPage(),
        ),
      ),

      // --- ADD TRANSACTION ROUTES ---
      GoRoute(
        path: AppRoutePaths.addIncome,
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: const AddTransactionView(type: TransactionType.income),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.addExpense,
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: const AddTransactionView(type: TransactionType.expense),
        ),
      ),

      // --- EDIT TRANSACTION ROUTES ---
      GoRoute(
        path: AppRoutePaths.editIncome,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return buildPageWithTransition(
            context: context,
            state: state,
            child: AddTransactionView(
              type: TransactionType.income,
              transactionId: id,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.editExpense,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return buildPageWithTransition(
            context: context,
            state: state,
            child: AddTransactionView(
              type: TransactionType.expense,
              transactionId: id,
            ),
          );
        },
      ),

      // --- GOAL ROUTES ---
      GoRoute(
        path: AppRoutePaths.addGoal,
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: const AddGoalView(),
        ),
      ),
      GoRoute(
        path: AppRoutePaths.editGoal,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return buildPageWithTransition(
            context: context,
            state: state,
            child: AddGoalView(goalId: id),
          );
        },
      ),
      // --- DEBT ROUTES ---
      GoRoute(
        path: AppRoutePaths.addDebt,
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: DebtTransaction(),
        ),
      ),

      // --- MAIN APP FLOW ---
      GoRoute(
        path: AppRoutePaths.dashboard,
        pageBuilder: (context, state) => buildPageWithTransition(
          context: context,
          state: state,
          child: const DashboardPage(),
        ),
      ),
    ],
  );
});

String? _handleRootRedirect(BuildContext context, GoRouterState state) {
  final location = state.matchedLocation;

  final container = ProviderScope.containerOf(context);
  final authState = container.read(authProvider);

  // 1. Initial State Guard
  // Check if we are still securely fetching session
  final bool isInitializing = authState.maybeWhen(
    initial: () => true,
    orElse: () => false,
  );

  if (isInitializing) {
    return location == AppRoutePaths.root ? null : AppRoutePaths.root;
  }

  // 2. Auth States
  final bool isAuthenticated = authState.maybeWhen(
    authenticated: (_) => true,
    orElse: () => false,
  );

  final bool isAuthRoute =
      location == AppRoutePaths.login ||
      location == AppRoutePaths.register ||
      location == AppRoutePaths.forgotPassword ||
      location == AppRoutePaths.onboarding;

  final hive = HiveService();

  // Authenticated → block auth pages
  if (isAuthenticated) {
    if (isAuthRoute || location == AppRoutePaths.root) {
      return AppRoutePaths.dashboard;
    }
    return null;
  }

  // Onboarding check (UX layer only)
  if (!hive.hasSeenOnboarding) {
    return location != AppRoutePaths.onboarding
        ? AppRoutePaths.onboarding
        : null;
  }

  // Default → login
  if (location == AppRoutePaths.root || !isAuthRoute) {
    return AppRoutePaths.login;
  }

  return null;
}

class RouterRefreshListenable extends ChangeNotifier {
  RouterRefreshListenable(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}
