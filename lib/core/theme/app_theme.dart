import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'app_colors.dart';
import 'spacing_helper.dart';

class ThemeHelper {
  // 1. Input Decoration (Consistent across the app)
  static InputDecoration inputDecoration({
    String? label,
    String? hint,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, size: SpacingHelper.iconSizeSmall, color: AppColors.textSecondary)
          : null,
      suffixIcon: suffixIcon,
      labelStyle: TextStyleHelper.textStyle14(color: AppColors.textSecondary),
      hintStyle: TextStyleHelper.textStyle14(color: AppColors.textSecondary.withOpacity(0.5)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: SpacingHelper.md,
        vertical: SpacingHelper.md,
      ),
    );
  }

  // 1.1 Card Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24.r),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  );

  // 2. Gradient Button Style
  static BoxDecoration gradientButtonDecoration = BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.circular(12.r),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // 3. Transparent Button Style for Social Login
  static OutlinedButton socialButtonStyle({required String label, required IconData icon}) {
    return OutlinedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        foregroundColor: AppColors.textPrimary,
      ),
      onPressed: () {}, // Placeholder
    );
  }
}