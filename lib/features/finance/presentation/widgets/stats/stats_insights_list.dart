import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hasbi/core/theme/text_styles.dart';

class StatsInsightsList extends StatelessWidget {
  const StatsInsightsList({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for insights as per image logic
    final insights = [
      _InsightItem(
        icon: Icons.trending_up,
        iconColor: const Color(0xFF4CAF50),
        bgIconColor: const Color(0xFFE8F5E9),
        text: 'You saved 12% more than last month. Keep it up!',
      ),
      _InsightItem(
        icon: Icons.restaurant,
        iconColor: const Color(0xFFF44336),
        bgIconColor: const Color(0xFFFFEBEE),
        text: 'Dining out is 15% higher than your average.',
      ),
      _InsightItem(
        icon: Icons.directions_car,
        iconColor: const Color(0xFF2196F3),
        bgIconColor: const Color(0xFFE3F2FD),
        text: 'Fuel prices increased your transport costs by 8%.',
      ),
      _InsightItem(
        icon: Icons.account_balance,
        iconColor: const Color(0xFFFF9800),
        bgIconColor: const Color(0xFFFFF3E0),
        text: 'Investment dividends are up by \$142 this month.',
      ),
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
            child: Text(
              'Insights',
              style: TextStyleHelper.textStyle18(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          ...insights.map((item) => Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: item.bgIconColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    color: item.iconColor,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    item.text,
                    style: TextStyleHelper.textStyle13(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade300,
                  size: 20.sp,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _InsightItem {
  final IconData icon;
  final Color iconColor;
  final Color bgIconColor;
  final String text;

  _InsightItem({
    required this.icon,
    required this.iconColor,
    required this.bgIconColor,
    required this.text,
  });
}
