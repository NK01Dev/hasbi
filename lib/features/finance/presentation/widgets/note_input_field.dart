import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/text_styles.dart';

/// A note input field with icon
/// 
/// Used for entering optional notes/descriptions for transactions
class NoteInputField extends StatelessWidget {
  final TextEditingController controller;
  final Color? primaryColor;
  final String hintText;
  final IconData icon;

  const NoteInputField({
    super.key,
    required this.controller,
    this.primaryColor,
    this.hintText = 'Write a note (Optional)',
    this.icon = FontAwesomeIcons.pen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              FaIcon(icon, color: Colors.grey, size: 20.sp),
              SizedBox(width: 16.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyleHelper.textStyle16(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyleHelper.textStyle16(color: Colors.grey),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
      ],
    );
  }
}
