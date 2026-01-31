import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpacingHelper {
  // ==========================================
  // 1. BASE SPACING VALUES (Used for Width, Height, Radius)
  // ==========================================
  // Adjust these values to change the spacing scale for the whole app

  static double get xxxs => 2.w;
  static double get xxs  => 4.w;
  static double get xs   => 8.w;
  static double get sm   => 12.w;
  static double get md   => 16.w;
  //18.w
  static double get mmd   => 18.w;
  static double get lg   => 24.w;
  static double get xl   => 32.w;
  static double get xxl  => 48.w;
  static double get xxxl => 64.w;

  // ==========================================
  // 2. PADDING (EdgeInsets)
  // ==========================================
  static EdgeInsets get xAllSmall => EdgeInsets.all(xxs);
  static EdgeInsets get pAllSmall => EdgeInsets.all(xs);
  static EdgeInsets get pAllMedium => EdgeInsets.all(md);
  static EdgeInsets get pAllLarge => EdgeInsets.all(lg);

  static EdgeInsets get pHMedium => EdgeInsets.symmetric(horizontal: md);
  static EdgeInsets get pVSmall => EdgeInsets.symmetric(vertical: xs);
  static EdgeInsets get pVMedium => EdgeInsets.symmetric(vertical: md);

  // Specific Paddings (e.g., only top or left)
  static EdgeInsets get pTopMedium => EdgeInsets.only(top: md);
  static EdgeInsets get pLeftSmall => EdgeInsets.only(left: xs);

  // ==========================================
  // 3. MARGIN (EdgeInsets)
  // ==========================================
  // Same naming convention, separated for clarity
  static EdgeInsets get mAllSmall => EdgeInsets.all(xs);
  static EdgeInsets get mAllMedium => EdgeInsets.all(md);

  static EdgeInsets get mHMedium => EdgeInsets.symmetric(horizontal: md);
  static EdgeInsets get mVSmall => EdgeInsets.symmetric(vertical: xs);

  // ==========================================
  // 4. SPECIFIC DIMENSIONS (Height / Width)
  // ==========================================
  // Common component sizes

  // Buttons
  static double get buttonHeight => 48.h;
  static double get buttonHeightSmall => 36.h;

  // Icons & Images
  static double get iconSizeSmall => 20.w;
  static double get iconSizeMedium => 24.w;
  static double get avatarSizeSmall => 40.w;
  static double get avatarSizeMedium => 56.w;
  static double get avatarSizeLarge => 80.w;

  // Inputs
  static double get inputFieldHeight => 50.h;
}