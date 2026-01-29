import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyleHelper {
  //google fonts

  static const String _fontFamily = 'Inter'; // Updated from Poppins
  static const FontWeight _defaultWeight = FontWeight.w500;
  static TextStyle textStyle36({
    Color color = Colors.black,
    FontWeight? fontWeight,
  }) => _baseStyle(36.sp, color, fontWeight);

  static TextStyle textStyle32({
    Color color = Colors.black,
    FontWeight? fontWeight,
  }) => _baseStyle(32.sp, color, fontWeight);
  static TextStyle textStyle28({
    Color color = Colors.black,
    FontWeight? fontWeight,
  }) => _baseStyle(28.sp, color, fontWeight);
  static TextStyle textStyle24({
    Color color = Colors.black,
    FontWeight? fontWeight,
  }) => _baseStyle(24.sp, color, fontWeight);
  static TextStyle textStyle20({
    Color color = Colors.black,
    FontWeight? fontWeight,
    double? fontSize,
  }) => _baseStyle(fontSize ?? 20.sp, color, fontWeight);

  static TextStyle textStyle18({
    Color color = Colors.black,
    FontWeight? fontWeight,
    double? fontSize,
  }) => _baseStyle(fontSize ?? 18.sp, color, fontWeight);

  static TextStyle textStyle16({
    Color color = Colors.black,
    FontWeight? fontWeight,
    double? fontSize,
  }) => _baseStyle(fontSize ?? 16.sp, color, fontWeight);

  static TextStyle textStyle14({
    Color color = Colors.black,
    FontWeight? fontWeight,
    double? fontSize,
  }) => _baseStyle(fontSize ?? 14.sp, color, fontWeight);

  static TextStyle textStyle13({
    Color color = Colors.black,
    FontWeight? fontWeight,
  }) => _baseStyle(13.sp, color, fontWeight);

  static TextStyle textStyle12({
    Color color = Colors.black,
    FontWeight? fontWeight,
  }) => _baseStyle(12.sp, color, fontWeight);

  static TextStyle textStyle11({
    Color color = Colors.black,
    FontWeight? fontWeight,
  }) => _baseStyle(11.sp, color, fontWeight);

  static TextStyle textStyle10({
    Color color = Colors.black,
    FontWeight? fontWeight,
  }) => _baseStyle(10.sp, color, fontWeight);

  static TextStyle textStyle9({
    Color color = Colors.black,
    FontWeight? fontWeight,
  }) => _baseStyle(9.sp, color, fontWeight);

  static TextStyle textStyle8({
    Color color = Colors.black,
    FontWeight? fontWeight,
  }) => _baseStyle(8.sp, color, fontWeight);

  static TextStyle _baseStyle(
    double fontSize,
    Color color,
    FontWeight? fontWeight,
  ) {
    return TextStyle(
      fontSize: fontSize,
      fontFamily: _fontFamily,
      fontWeight: fontWeight ?? _defaultWeight,
      color: color,
    );
  }
}
