import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hasbi/features/finance/presentation/pages/dashboard_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';



// Config
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/finance/presentation/views/profile_view.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../storage/hive_service.dart';
import 'app_route_paths.dart';
import 'app_transitions.dart'; // Import the helper function

/// Main Application Router
//
final appRouteProvider= Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: AppRoutePaths.root,
      refreshListenable: RouterRefreshListenable(ref),
      redirect: _handleRootRedirect,
      routes: [
        GoRoute(
          path: AppRoutePaths.root,
          builder: (context, state) => const SizedBox.shrink(),
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
// Add this route
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
  },
);

String? _handleRootRedirect(BuildContext context, GoRouterState state) {
  final hive = HiveService();
  final location = state.matchedLocation;

  // Define routes that don't require authentication
  final bool isAuthRoute = location == AppRoutePaths.login ||
      location == AppRoutePaths.register ||
      location == AppRoutePaths.forgotPassword ||
      location == AppRoutePaths.onboarding;

  if (hive.isLoggedIn) {
    // If logged in, don't allow access to auth pages - redirect to dashboard
    return (isAuthRoute || location == AppRoutePaths.root) ? AppRoutePaths.dashboard : null;
  }

  // Not logged in
  if (!hive.hasSeenOnboarding) {
    // Force onboarding if not seen
    return location != AppRoutePaths.onboarding ? AppRoutePaths.onboarding : null;
  }

  // If at root or trying to access protected pages (like dashboard) while not logged in
  if (location == AppRoutePaths.root || !isAuthRoute) {
     return AppRoutePaths.login;
  }

  // Allow access to login, register, forgot-password
  return null;
}

/// A Listenable that notifies when the auth state changes.
class RouterRefreshListenable extends ChangeNotifier {
  RouterRefreshListenable(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}