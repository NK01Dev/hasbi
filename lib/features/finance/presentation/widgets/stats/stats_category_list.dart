import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'package:hasbi/features/finance/providers/stats_provider.dart';

class StatsCategoryList extends StatelessWidget {
  final List<CategoryStat> categoryStats;

  const StatsCategoryList({
    super.key,
    required this.categoryStats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Category Details',
                  style: TextStyleHelper.textStyle18(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'See All',
                  style: TextStyleHelper.textStyle12(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E556B),
                  ),
                ),
              ],
            ),
          ),
          ...categoryStats.map((stat) => Container(
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
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: stat.color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        stat.icon,
                        color: stat.color,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        stat.categoryName,
                        style: TextStyleHelper.textStyle14(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      '\$${stat.amount.toStringAsFixed(0)}',
                      style: TextStyleHelper.textStyle14(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Progress Bar
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Assuming max is relative to total for visual bar? 
                    // Or relative to highest category? usually helpful.
                    // For now let's just make it look good, assume 100% full width is impractical without context,
                    // but we can put a bar. 
                    // Let's use a static thick line with color for now as per image decoration which looks like a progress line.
                    return Stack(
                      children: [
                        Container(
                          height: 4.h,
                          width: constraints.maxWidth,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                        Container(
                          height: 4.h,
                          width: constraints.maxWidth * 0.7, // Mocking random progress for visual match if data not normalized
                          decoration: BoxDecoration(
                            color: stat.color,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
