import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/dashboard_fab_provider.dart';

// Assuming these exist in your project
// import 'package:hasbi/core/theme/app_colors.dart';
// import '../../providers/dashboard_fab_provider.dart';

class ExpandableFab extends ConsumerWidget {
  const ExpandableFab({
    super.key,
    required this.onIncome,
    required this.onExpense,
    required this.onGoals,
  });

  final VoidCallback onIncome;
  final VoidCallback onExpense;
  final VoidCallback onGoals;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Replace with your actual provider
    final isOpen = ref.watch(fabExpandedProvider);

    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none, // Prevents clipping of the FAB menu
      children: [
        if (isOpen) _Backdrop(onClose: () => _toggle(ref, false)),

        // The Pill Background
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 64.w,
          height: isOpen ? 260.h : 64.w,
          decoration: BoxDecoration(
            color: isOpen
                ? Colors.black.withOpacity(0.1) // Subtle pill background
                : Colors.transparent,
            borderRadius: BorderRadius.circular(32.r),
          ),
        ),

        // Action Items
        _ActionItem(
          index: 2,
          isOpen: isOpen,
          icon: Icons.trending_up,
          color: Colors.green, // AppColors.success
          onTap: () => _closeThen(ref, onIncome),
        ),
        _ActionItem(
          index: 1,
          isOpen: isOpen,
          icon: Icons.trending_down,
          color: Colors.red, // AppColors.error
          onTap: () => _closeThen(ref, onExpense),
        ),
        _ActionItem(
          index: 0,
          isOpen: isOpen,
          icon: Icons.savings,
          color: Colors.deepPurple, // AppColors.primaryPurple
          onTap: () => _closeThen(ref, onGoals),
        ),

        // Main Toggle Button
        _MainFab(
          isOpen: isOpen,
          onTap: () {
            HapticFeedback.lightImpact();
            _toggle(ref, !isOpen);
          },
        ),
      ],
    );
  }

  void _toggle(WidgetRef ref, bool value) {
    ref.read(fabExpandedProvider.notifier).state = value;
  }

  void _closeThen(WidgetRef ref, VoidCallback action) {
    HapticFeedback.selectionClick();
    _toggle(ref, false);
    action();
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.index,
    required this.isOpen,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final int index;
  final bool isOpen;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Adjusted spacing to look more natural
    final double bottomOffset = 64.w + 12.h + (index * 60.h);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      bottom: isOpen ? bottomOffset : 20.h,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isOpen ? 1 : 0,
        child: IgnorePointer(
          ignoring: !isOpen,
          child: _MiniFab(icon: icon, color: color, onTap: onTap),
        ),
      ),
    );
  }
}

class _MiniFab extends StatelessWidget {
  const _MiniFab({required this.icon, required this.color, required this.onTap});
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      height: 48.w,
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Icon(icon, color: color, size: 22.w),
      ),
    );
  }
}

class _MainFab extends StatelessWidget {
  const _MainFab({required this.isOpen, required this.onTap});
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 64.w,
        height: 64.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF3F51B5), // Your Primary Blue
          boxShadow: [
            if (!isOpen)
              BoxShadow(
                color: const Color(0xFF3F51B5).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
          ],
        ),
        child: AnimatedRotation(
          turns: isOpen ? 0.125 : 0, // Rotates "+" to "x"
          duration: const Duration(milliseconds: 250),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30.w,
          ),
        ),
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      // Ensure the backdrop covers the whole screen, not just the FAB stack
      left: -1000, right: -1000, top: -1000, bottom: -1000,
      child: GestureDetector(
        onTap: onClose,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(color: Colors.black.withOpacity(0.1)),
        ),
      ),
    );
  }
}