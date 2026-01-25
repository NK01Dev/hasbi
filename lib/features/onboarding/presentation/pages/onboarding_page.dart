import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Core
import '../../../../core/router/app_route_paths.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/onboarding_data.dart';

class OnboardingPage extends HookWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hive = HiveService();
    final size = MediaQuery.of(context).size;

    // Define breakpoint for "Web" vs "Mobile"
    final bool isLargeScreen = size.width > 600;

    return Scaffold(
      body: ConcentricPageView(
        // FIX 1: Radius logic. On web, a fixed large radius is better than a percentage
        // which can make the circle look like a straight line.
        radius: isLargeScreen
            ? 800.0 // Fixed large radius for Web
            : math.max(size.width, size.height) * 0.85, // Standard for Mobile
        colors: onboardingList.map((item) => item.backgroundColor).toList(),

        onFinish: () async {
          await hive.setHasSeenOnboarding(true);
          if (context.mounted) context.go(AppRoutePaths.login);
        },

        itemCount: onboardingList.length,
        itemBuilder: (index) {
          final item = onboardingList[index];
          final isLightBg = item.backgroundColor == const Color(0xFFF5F7FA);

          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                // FIX 2: Constrain width to mimic a mobile phone on Web
                constraints: BoxConstraints(
                  maxWidth: isLargeScreen ? 500 : double.infinity,
                  maxHeight: isLargeScreen ? 900 : double.infinity,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isLargeScreen ? 24 : 24.w),
                  child: Column(
                    // FIX 3: Use MainAxisAlignment center for better vertical centering on Web
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Skip Button
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          // Fixed padding for web to avoid massive spacing
                          padding: EdgeInsets.only(top: isLargeScreen ? 20 : 16.h, right: isLargeScreen ? 0 : 8.w),
                          child: TextButton(
                            onPressed: () async {
                              await hive.setHasSeenOnboarding(true);
                              if (context.mounted) context.go(AppRoutePaths.login);
                            },
                            child: Text(
                              "Skip",
                              style: TextStyleHelper.textStyle16(
                                color: isLightBg ? AppColors.textPrimary : AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Reduced vertical spacing for Web
                      SizedBox(height: isLargeScreen ? 20 : 40.h),

                      // Illustration
                      Flexible(
                        // Using Flexible instead of Expanded flex ratio allows image to fit nicely on web
                        flex: isLargeScreen ? 0 : 5,
                        child: Center(
                          child: SvgPicture.asset(
                            item.imageAsset,
                            // FIX 4: Adjusted image height. 250 might be too small for 500px width container.
                            // Increased to 300 for Web.
                            height: isLargeScreen ? 300 : 320.h,
                            width: isLargeScreen ? 300 : null, // Added width constraint for web
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // Content Section
                      Expanded(
                        flex: isLargeScreen ? 0 : 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min, // Important for Web
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: isLargeScreen ? 40 : 0),
                              child: Column(
                                children: [
                                  // Title
                                  Text(
                                    item.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyleHelper.textStyle28(
                                      color: isLightBg ? AppColors.textPrimary : AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Fixed spacing for Web
                                  SizedBox(height: isLargeScreen ? 16 : 16.h),

                                  // Subtitle
                                  Text(
                                    item.subtitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyleHelper.textStyle16(
                                      color: isLightBg
                                          ? AppColors.textSecondary
                                          : AppColors.textSecondary.withOpacity(0.8),
                                    ),
                                  ),

                                  SizedBox(height: isLargeScreen ? 40 : 55.h),

                                  // --- SMOOTH PAGE INDICATOR ---
                                  AnimatedSmoothIndicator(
                                    activeIndex: index,
                                    count: onboardingList.length,
                                    effect: WormEffect(
                                      dotHeight: isLargeScreen ? 10 : 10.h,
                                      dotWidth: isLargeScreen ? 10 : 10.w,
                                      activeDotColor: AppColors.primary,
                                      dotColor: AppColors.black.withOpacity(0.1),
                                    ),
                                  ),
                                  // --------------------------------
                                ],
                              ),
                            ),

                            // Button at bottom
                            Padding(
                              padding: EdgeInsets.only(top: isLargeScreen ? 40 : 0, bottom: isLargeScreen ? 40 : 40.h),
                              child: SizedBox(
                                width: double.infinity,
                                height: isLargeScreen ? 56 : 56.h,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (index == onboardingList.length - 1) {
                                      hive.setHasSeenOnboarding(true);
                                      context.go('/login');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(isLargeScreen ? 16 : 16.r),
                                    ),
                                    elevation: 2,
                                    shadowColor: Colors.black.withOpacity(0.1),
                                  ),
                                  child: Text(
                                    index == onboardingList.length - 1
                                        ? "Get Started"
                                        : "Next",
                                    style: TextStyleHelper.textStyle18(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}