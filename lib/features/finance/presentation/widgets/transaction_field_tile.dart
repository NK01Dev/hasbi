import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/text_styles.dart';

/// A list tile with icon, value, and tap action
/// 
/// Used for selectable fields like category, date, payment method, etc.
class TransactionFieldTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final VoidCallback onTap;
  final Color iconColor;

  const TransactionFieldTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = Colors.black,
    required this.onTap,
    this.iconColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                FaIcon(icon, color: iconColor, size: 20.sp),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyleHelper.textStyle16(
                      color: valueColor,
                      fontWeight: valueColor == Colors.grey ? FontWeight.w400 : FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
      ],
    );
  }
}
