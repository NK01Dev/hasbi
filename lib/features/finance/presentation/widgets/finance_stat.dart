import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hasbi/core/theme/spacing_helper.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 5.h),
        decoration: BoxDecoration(
          color: AppColors.white, // Pure white background
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: Colors.grey.shade200), // Subtle border
          // No box shadow / No elevation
        ),

      child: SizedBox(

        child: Padding(
          padding: SpacingHelper.mAllSmall,
          child: Row(
            children: [
              Container(
                padding: SpacingHelper.mAllMedium,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: color,
                  size: SpacingHelper.lg,
                ),
              ),
              SizedBox(width: 12.w),

              // 👇 THIS FIXES OVERFLOW
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleHelper.textStyle16(
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      amount,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyleHelper.textStyle18(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )

        ),
      ),
    );
  }
}