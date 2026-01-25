import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Helper function to build a consistent Slide Transition
Page<dynamic> buildPageWithTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Slide from Right to Left
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubicEmphasized,
          ),
        ),
        child: child,
      );
    },
  );
}