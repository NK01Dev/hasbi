import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';

class AppwriteApp extends ConsumerWidget {
  const AppwriteApp({super.key});
    //    final goRouter = ref.watch(goRouteProvide);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouteProvider);
    return ScreenUtilInit(
      designSize: const Size(411, 869), // Pixel 4 logical pixels
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Hasbi',
          routerConfig: appRouter, // Using the separated router
          theme: ThemeData(
            useMaterial3: true,

            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              surface: AppColors.surface,
              error: AppColors.error,
            ),

            scaffoldBackgroundColor: AppColors.surface,

            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.black,
              elevation: 0,
              surfaceTintColor: Colors.transparent, // 🔥 IMPORTANT
              centerTitle: false,
            ),

            cardTheme: CardThemeData(
              color: AppColors.surface,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),

        );
      },
    );
  }
}
