import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cholo_bd/config/app_colors.dart';

class AppTextStyle {
  AppTextStyle._();

  // Syne Bold — headings, district names, CTAs
  static TextStyle heading1 = GoogleFonts.syne(
    fontWeight: FontWeight.w700,
    fontSize: 28,
    color: AppColor.textPrimary,
  );

  static TextStyle heading2 = GoogleFonts.syne(
    fontWeight: FontWeight.w700,
    fontSize: 22,
    color: AppColor.textPrimary,
  );

  static TextStyle heading3 = GoogleFonts.syne(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    color: AppColor.textPrimary,
  );

  static TextStyle sectionTitle = GoogleFonts.syne(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    color: AppColor.textPrimary,
  );

  // DM Sans — body, descriptions, labels
  static TextStyle bodyLarge = GoogleFonts.dmSans(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColor.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.dmSans(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColor.textSecondary,
  );

  static TextStyle bodySmall = GoogleFonts.dmSans(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColor.textSecondary,
  );

  static TextStyle labelMedium = GoogleFonts.dmSans(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColor.textPrimary,
  );

  static TextStyle labelSmall = GoogleFonts.dmSans(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: AppColor.textSecondary,
  );

  static TextStyle button = GoogleFonts.dmSans(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: AppColor.textOnPrimary,
  );

  static TextStyle caption = GoogleFonts.dmSans(
    fontWeight: FontWeight.w400,
    fontSize: 11,
    color: AppColor.textSecondary,
  );

  // Noto Sans Bengali — all Bangla strings
  static TextStyle banglaHeading = const TextStyle(
    fontFamily: 'NotoSansBengali',
    fontWeight: FontWeight.w700,
    fontSize: 20,
    color: AppColor.textPrimary,
  );

  static TextStyle banglaBody = const TextStyle(
    fontFamily: 'NotoSansBengali',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColor.textSecondary,
  );

  static TextStyle banglaLabel = const TextStyle(
    fontFamily: 'NotoSansBengali',
    fontWeight: FontWeight.w500,
    fontSize: 13,
    color: AppColor.textPrimary,
  );
}
