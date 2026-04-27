import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  // Primary palette (Smart Travel BD)
  static const Color primary = Color(0xFF00C896);
  static const Color accent = Color(0xFFF5A623);
  static const Color inkDark = Color(0xFF0D1117);
  static const Color surface = Color(0xFFF7F9FC);
  static const Color alertRed = Color(0xFFFF4D6D);

  // Backgrounds
  static const Color bgDark = Color(0xFFFFFFFF);
  static const Color bgCard = Color(0xFFF7F9FC);
  static const Color bgCardLight = Color(0xFFEEF1F5);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textHint = Color(0xFF6B7280);

  // Borders / Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Status
  static const Color success = Color(0xFF00C896);
  static const Color warning = Color(0xFFF5A623);
  static const Color error = Color(0xFFFF4D6D);

  // Shimmer
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF8FAFC);

  // Overlay
  static Color overlay = Colors.black.withValues(alpha: 0.5);
  static Color cardGradientStart = Colors.transparent;
  static Color cardGradientEnd = Colors.black.withValues(alpha: 0.8);
}
