import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ============================================================
  // AKSHARAASETU COLOR PALETTE
  // ============================================================

  static const Color navy = Color(0xFF10263A);
  static const Color navyLight = Color(0xFF18364E);
  static const Color navyDark = Color(0xFF0A1928);

  static const Color cream = Color(0xFFF4EBDD);
  static const Color creamDark = Color(0xFFE9DDC9);
  static const Color creamLight = Color(0xFFFFF9EF);

  static const Color terracotta = Color(0xFFC9683E);
  static const Color terracottaDark = Color(0xFFA94F2E);

  static const Color gold = Color(0xFFD9A84E);
  static const Color goldLight = Color(0xFFE8C875);

  static const Color darkText = Color(0xFF172235);
  static const Color mutedText = Color(0xFF62645F);

  static const Color success = Color(0xFF3F7D58);
  static const Color error = Color(0xFFB94A48);

  // ============================================================
  // BACKWARD-COMPATIBILITY COLORS
  //
  // Existing screens use these names.
  // Keeping them here means we don't have to rewrite every screen.
  // ============================================================

  static const Color primaryColor = terracotta;
  static const Color secondaryColor = gold;
  static const Color mutedTextColor = mutedText;
  static const Color textColor = darkText;
  static const Color successColor = success;
  static const Color errorColor = error;

  // ============================================================
  // THEME
  // ============================================================

  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: navy,
      colorScheme: ColorScheme.fromSeed(
        seedColor: terracotta,
        brightness: Brightness.light,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: navy,

      // ----------------------------------------------------------
      // TEXT
      // ----------------------------------------------------------

      textTheme: GoogleFonts.poppinsTextTheme(
        base.textTheme,
      ).apply(
        bodyColor: darkText,
        displayColor: darkText,
      ),

      // ----------------------------------------------------------
      // APP BAR
      // ----------------------------------------------------------

      appBarTheme: const AppBarTheme(
        backgroundColor: navy,
        foregroundColor: cream,
        elevation: 0,
        centerTitle: false,
      ),

      // ----------------------------------------------------------
      // INPUT FIELDS
      // ----------------------------------------------------------

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cream,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: creamDark,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: gold,
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: error,
            width: 1.5,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: error,
            width: 2,
          ),
        ),

        hintStyle: const TextStyle(
          color: mutedText,
        ),
      ),

      // ----------------------------------------------------------
      // ELEVATED BUTTON
      // ----------------------------------------------------------

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: terracotta,
          foregroundColor: Colors.white,
          elevation: 4,

          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      // ----------------------------------------------------------
      // OUTLINED BUTTON
      // ----------------------------------------------------------

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: gold,

          side: const BorderSide(
            color: gold,
            width: 1.5,
          ),

          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 15,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      // ----------------------------------------------------------
      // TEXT BUTTON
      // ----------------------------------------------------------

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: terracotta,
        ),
      ),

      // ----------------------------------------------------------
      // CARDS
      // ----------------------------------------------------------

      cardTheme: CardThemeData(
        color: cream,
        elevation: 4,
        margin: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      // ----------------------------------------------------------
      // DIVIDERS
      // ----------------------------------------------------------

      dividerTheme: const DividerThemeData(
        color: creamDark,
        thickness: 1,
      ),

      // ----------------------------------------------------------
      // PROGRESS INDICATOR
      // ----------------------------------------------------------

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: terracotta,
      ),

      // ----------------------------------------------------------
      // FLOATING ACTION BUTTON
      // ----------------------------------------------------------

      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(
        backgroundColor: terracotta,
        foregroundColor: Colors.white,
      ),

      // ----------------------------------------------------------
      // CHIP
      // ----------------------------------------------------------

      chipTheme: ChipThemeData(
        backgroundColor: creamDark,
        selectedColor: gold,
        labelStyle: const TextStyle(
          color: darkText,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // ----------------------------------------------------------
      // SNACKBAR
      // ----------------------------------------------------------

      snackBarTheme: SnackBarThemeData(
        backgroundColor: navyDark,
        contentTextStyle: GoogleFonts.poppins(
          color: cream,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}