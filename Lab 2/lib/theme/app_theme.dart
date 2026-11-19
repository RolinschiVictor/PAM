import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens extracted from the Figma design (GemStore).
/// Keep every color / spacing / radius value here so pages & widgets
/// never hardcode magic numbers themselves.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFFFFFFFF);
  static const Color sectionBackground = Color(0xFFF6F6F8);
  static const Color textPrimary = Color(0xFF1D1B20);
  static const Color textSecondary = Color(0xFF9A9A9A);
  static const Color textMuted = Color(0xFFB7B7B7);
  static const Color divider = Color(0xFFEFF0F1);

  static const Color selectedCategory = Color(0xFF3A2C27);
  static const Color unselectedCategoryBg = Color(0xFFF3F3F3);

  static const Color accentTeal = Color(0xFF508A7B);
  static const Color notificationDot = Color(0xFFFF5A6E);

  static const Color buttonDark = Color(0xFF1D1B20);
  static const Color buttonTextLight = Color(0xFFFFFFFF);

  static const Color cardShadow = Color(0x14000000);
}

class AppRadii {
  AppRadii._();

  static const double banner = 24;
  static const double card = 18;
  static const double sheet = 28;
  static const double pill = 100;
}

class AppSpacing {
  AppSpacing._();

  static const double screenPadding = 20;
  static const double sectionGap = 28;
}

class AppText {
  AppText._();

  static TextTheme get textTheme => GoogleFonts.poppinsTextTheme();

  static TextStyle get appTitle => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get sectionHeading => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get showAll => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get categoryLabelSelected => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get categoryLabelUnselected => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );

  static TextStyle get productName => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get productPrice => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get bannerKicker => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: AppColors.textSecondary,
      );

  static TextStyle get bannerTitle => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get productPageTitle => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get productPagePrice => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get label => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get body => GoogleFonts.poppins(
        fontSize: 13.5,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: AppColors.textSecondary,
      );
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: GoogleFonts.poppins().fontFamily,
    textTheme: AppText.textTheme,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accentTeal,
      primary: AppColors.accentTeal,
      background: AppColors.background,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
