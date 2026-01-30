import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/models/category_model.dart';

/// A grid item for displaying and selecting a category
class CategoryGridItem extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;
  final bool isSelected;

  const CategoryGridItem({
    super.key,
    required this.category,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.12),
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: category.color, width: 2)
                  : null,
            ),
            child: Center(
              child: FaIcon(category.icon, color: category.color, size: 28.sp),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            category.name,
            style: TextStyleHelper.textStyle14(
              color: AppColors.black,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
