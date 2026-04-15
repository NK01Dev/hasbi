import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hasbi/core/theme/text_styles.dart';

import '../../../../core/theme/app_colors.dart';

/// A large, prominent amount input field with currency formatting
///
/// Used for entering transaction amounts with a bold, eye-catching design
class AmountInputField extends StatelessWidget {
  final TextEditingController controller;
  final Color? primaryColor;
  final TextInputFormatter formatter;
  final String hintText;

  const AmountInputField({
    super.key,
    required this.controller,
    required this.formatter,
    this.primaryColor,
    this.hintText = '0.00',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Text(
            '\$',
            style: TextStyleHelper.textStyle32(
              color: AppColors.grey.withOpacity(0.5),
              fontWeight: FontWeight.bold,
            ).copyWith(fontSize: 40.sp),
          ),
        ),
        IntrinsicWidth(
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [formatter],
            textAlign: TextAlign.center,
            style: TextStyleHelper.textStyle32(
              color: primaryColor ?? AppColors.black.withOpacity(0.8),
              fontWeight: FontWeight.bold,
            ).copyWith(fontSize: 56.sp),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 56.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.withOpacity(0.3),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
