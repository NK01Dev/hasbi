import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:hasbi/core/theme/app_colors.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'package:hasbi/core/theme/spacing_helper.dart';
import 'package:hasbi/generated/assets.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final String lottieAsset;

  const LoadingWidget({
    super.key,
    this.message,
    this.lottieAsset = Assets.animationsLoading, // Ensure this exists in assets.dart
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            lottieAsset,
            width: 200.w, // Standardized size for loading animations
            height: 200.h,
          ),
          if (message != null) ...[
            SizedBox(height: SpacingHelper.md),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: TextStyleHelper.textStyle16(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}