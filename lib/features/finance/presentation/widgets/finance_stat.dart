import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hasbi/core/theme/spacing_helper.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import 'dashboard_animations.dart';

class FinanceStat extends StatelessWidget {
  final String label;
  final String amount;
  final IconData iconData;
  final Color color;
  final Color bgColor;

  const FinanceStat({
    super.key,
    required this.label,
    required this.amount,
    required this.iconData,
    required this.color,
    required this.bgColor,
  });
// 👇 ADD THIS HELPER FUNCTION
  String _formatCompact(String amountStr) {
// 1. Remove any non-numeric characters (like $ or ,) if they exist
    String cleanStr = amountStr.replaceAll(RegExp(r'[^0-9.]'), '');
    double? value = double.tryParse(cleanStr);

    if (value == null) return amountStr; // Return original if parsing fails

    if (value >= 1000000000) {
// Billions (e.g. 1.2B)
      return '\$${(value / 1000000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}B';
    } else if (value >= 1000000) {
// Millions (e.g. 10M)
      return '\$${(value / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}M';
    } else if (value >= 1000) {
// Thousands (e.g. 10k)
      return '\$${(value / 1000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}k';
    }

// Return as normal number if small
    return '\$${value.toStringAsFixed(0)}';
  }


  @override
  Widget build(BuildContext context) {
    double? numericAmount = double.tryParse(amount.replaceAll(RegExp(r'[^0-9.]'), ''));

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background, // Match background for neumorphism
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            offset: const Offset(-8, -8),
            blurRadius: 16,
          ),
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(8, 8),
            blurRadius: 16,
          ),
        ],
      ),
      child: Padding(
        padding: SpacingHelper.pAllMedium,
        child: Row(
          children: [
            Container(
              padding: SpacingHelper.pAllSmall,
              decoration: BoxDecoration(
                color: bgColor.withOpacity(0.4),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Icon(
                iconData,
                color: color,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyleHelper.textStyle12(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  AnimatedNumberText(
                    value: numericAmount ?? 0.0,
                    style: TextStyleHelper.textStyle16(
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}