import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/models/category_model.dart';
import 'category_grid_item.dart';

/// Shows a bottom sheet for selecting a category
/// 
/// Displays categories in a grid layout with icons and names
class CategoryPickerSheet {
  static void show({
    required BuildContext context,
    required WidgetRef ref,
    required List<CategoryModel> categories,
    required Function(CategoryModel) onCategorySelected,
    CategoryModel? selectedCategory,
    Color? accentColor,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24.w),
          height: 400.h,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 20.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      "Select a Category",
                      style: TextStyleHelper.textStyle18(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 48.w),
                ],
              ),
              SizedBox(height: 32.h),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 24.h,
                  crossAxisSpacing: 20.w,
                  children: categories.map((cat) {
                    return CategoryGridItem(
                      category: cat,
                      isSelected: selectedCategory?.id == cat.id,
                      onTap: () {
                        onCategorySelected(cat);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
