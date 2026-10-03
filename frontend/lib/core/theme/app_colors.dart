import 'package:flutter/material.dart';

/// One calm brand colour, soft status tones, and red kept for safety alerts
/// and failed payments only.
class AppColors {
  static const brand = Color(0xFF0F6E7A);
  static const background = Color(0xFFF6F8F9);
  static const surface = Colors.white;
  static const border = Color(0xFFDDE3E6);
  static const textPrimary = Color(0xFF1F2D33);
  static const textMuted = Color(0xFF5F7078);

  static const success = Color(0xFF2E7D4F);
  static const successBg = Color(0xFFE6F4EA);

  static const warning = Color(0xFFA86A00);
  static const warningBg = Color(0xFFFFF4DC);

  static const info = Color(0xFF2563A8);
  static const infoBg = Color(0xFFE8F0FA);

  // Reserved: drug allergy alerts and failed payments.
  static const danger = Color(0xFFB3261E);
  static const dangerBg = Color(0xFFFCE8E6);
}
