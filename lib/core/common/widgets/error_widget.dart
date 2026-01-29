import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:hasbi/core/theme/app_colors.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'package:hasbi/core/theme/spacing_helper.dart';
import 'package:hasbi/generated/assets.dart';

class ErrorWidget extends StatelessWidget {
  final String errorMessage;
  final String lottieAsset;
  final VoidCallback? onRetry;

  const ErrorWidget({
    super.key,
    this.errorMessage = 'Oops! Something went wrong.',
    this.lottieAsset = Assets.animationsError, // Ensure this exists in assets.dart
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(

      child: Padding(
        padding: SpacingHelper.pAllMedium,
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Lottie.asset(
              lottieAsset,
              width: 250.w,
              repeat: false, // Error animations usually look better played once
            ),
            SizedBox(height: SpacingHelper.md),
            Text(
              'Oh No!',
              style: TextStyleHelper.textStyle20(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: SpacingHelper.xs),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyleHelper.textStyle14(
                color: AppColors.textSecondary,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: SpacingHelper.lg),
              SizedBox(
                width: double.infinity,
                height: SpacingHelper.buttonHeight,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Try Again',
                    style: TextStyleHelper.textStyle16(color: Colors.white),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}