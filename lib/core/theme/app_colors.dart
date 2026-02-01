import 'package:flutter/material.dart';

class AppColors {
// ==========================================
  // 1. PRIMARY & SECONDARY
  // ==========================================

  static const Color primary = Color(0xFF305CDE);
  static const Color primaryLight = Color(0xFF8B82FF);
  static const Color primaryDark = Color(0xFF3D3AB3);
  static const Color black = Color(0xFF121212);
  static const Color grey = Color(0xFF7F7F7F);
  static const Color secondary = Color(0xFF2CE0F2);
  static const Color secondaryCyan = Color(0xFF2CE0F2);

  // --- Background Colors ---
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F9FA);
  //--incomes & expense Colors
  static const Color income = Color(0xFF2CE0F2);
  static const Color expense = Color(0xFFEF4444);



  // ==========================================
  // 2. BRAND ACCENTS
  // ==========================================

  static const Color primaryPurple = Color(0xFF7B5BEC);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, secondaryCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==========================================
  // 3. FUNCTIONAL ACCENTS
  // ==========================================

  static const Color accentOrange = Color(0xFFFF5E36);

  // --- Status Colors ---
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);

  // FIX 4: Added successLight getter
  static const Color successLight = Color(0xFFD1FAE5); // Light green for backgrounds/icons on dark

  static const Color warning = Color(0xFFF59E0B);

  static const Color accentYellow = Color(0xFFFEDC33);
  static const Color softIndigo = Color(0xFF8279FF);
  static const Color neutralPeach = Color(0xFFF2D4CC);

  // ==========================================
  // 4. TEXT COLORS
  // ==========================================

  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textWhite = Color(0xFFFFFFFF);

  // --- UI Element Colors ---
  static const Color border = Color(0xFFE5E7EB);
  static const Color inputBackground = Color(0xFFF3F4F6);
}