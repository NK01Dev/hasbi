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
  final String? title;

  const AmountInputField({
    super.key,
    required this.controller,
    required this.formatter,
    this.title,
    this.primaryColor,
    this.hintText = '\$0.00',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        if (title != null)
        Text(
          title!,
          style: TextStyleHelper.textStyle16(color: AppColors.black,fontWeight: FontWeight.w400),),
        SizedBox(height: 12.h,),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [formatter],
          style: TextStyle(
            fontSize: 40.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 40.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.withOpacity(0.3),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
        ),
      ],
    );
  }
}
