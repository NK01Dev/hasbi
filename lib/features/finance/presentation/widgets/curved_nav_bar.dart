import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../providers/dashboard_nav_provider.dart';
class SalomonNavBar extends HookConsumerWidget {
  const SalomonNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navIndexProvider);

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SalomonBottomBar(

              currentIndex: index,
              onTap: (i) =>
                  ref.read(navIndexProvider.notifier).setIndex(i),
              backgroundColor: AppColors.primary,
              curve: Curves.easeInOutQuart,

              selectedItemColor: AppColors.white,
              unselectedItemColor: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              itemPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),

              items: [
                SalomonBottomBarItem(
                  icon: const Icon(Icons.dashboard),
                  title: const Text("Home"),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.query_stats),
                  title: const Text("Stats"),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.flag),
                  title: const Text("Goals"),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(Icons.person),
                  title: const Text("Debts"),
                ),
              ],
            ),
          ],
        ),

    );
  }
}
