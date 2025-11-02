import 'package:flutter/material.dart';

class EColors {
  EColors._();

  // App theme colors
  static const Color primary = Color(0xFF4b68ff);
  static const Color secondary = Color(0xFFFFE24B);
  static const Color accent = Color(0xFFb0c7ff);

  static const Color dermPink = Color(0xFFFFC0CB); // Light Rose
  static const Color dermDark = Color(0xFFC084FC); // Violet/Lavender Accent
  static const Color dermBg = Color(0xFFFAF5FF);
  static const dermBlue = Color(0xFF90CAF9);
  static const dermGreen = Color(0xFF81C784);
  static const dermYellow = Color(0xFFFFF176);
  static const dermRed = Color(0xFFE57373);
  static const dermPurple = Color(0xFFBA68C8);
  static const dermTeal = Color(0xFF4DB6AC);
  static const dermSky = Color(0xFF81D4FA);
  static const dermOrange = Color(0xFFFFB74D);
  static const dermLavender = Color(0xFFE1BEE7);
  static const dermMint = Color(0xFFA5D6A7);
  static const dermLightBlue = Color(0xFF64B5F6);
  static const dermGold = Color(0xFFFFD54F);
  static const dermRose = Color(0xFFF48FB1);
  static const dermGray = Color(0xFFBDBDBD);
  static const dermIndigo = Color(0xFF7986CB);
  static const dermPeach = Color(0xFFFFCC80);
  static const dermBrown = Color(0xFFA1887F);
  static const dermCyan = Color(0xFF4DD0E1);
  static const dermAmber = Color(0xFFFFCA28);

  // Gradient colors
  static const Gradient linerGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [Color(0xffff9a9e), Color(0xfffad0c4), Color(0xfffad0c4)],
  );

  // Text colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textWhite = Colors.white;

  // Background colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F5FF);

  // Background Container colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = EColors.white.withValues(alpha: 0.1);

  // Button colors
  static const Color buttonPrimary = Color(0xFF4b68ff);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // Border colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // Error and validation colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}
