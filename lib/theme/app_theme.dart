import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Olive Green Brand Palette
  static const Color primaryOlive = Color(0xFF4A5D23); // #4A5D23 Deep Olive Green
  static const Color secondaryOlive = Color(0xFF6C8337); // #6C8337 Vibrant Leaf Green
  static const Color lightOliveContainer = Color(0xFFEAF0E1); // #EAF0E1 Light Olive Tint
  static const Color surfaceWhite = Color(0xFFFFFFFF); // Pristine White
  static const Color backgroundLight = Color(0xFFF7F9F4); // Soft Green-tint White
  static const Color textDark = Color(0xFF1F2614); // Deep Olive Dark Text
  static const Color textMuted = Color(0xFF5C664C); // Muted Olive Grey Text

  // Dark mode colors
  static const Color backgroundDark = Color(0xFF13170D); // Rich Dark Olive Background
  static const Color surfaceDark = Color(0xFF1E2416); // Dark Olive Card Surface
  static const Color borderDark = Color(0xFF2E3821);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: primaryOlive,
      onPrimary: Colors.white,
      primaryContainer: lightOliveContainer,
      onPrimaryContainer: textDark,
      secondary: secondaryOlive,
      onSecondary: Colors.white,
      surface: surfaceWhite,
      onSurface: textDark,
      error: Color(0xFFD9383A),
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
      displayLarge: GoogleFonts.plusJakartaSans(color: textDark, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.plusJakartaSans(color: textDark, fontWeight: FontWeight.bold),
      bodyLarge: GoogleFonts.plusJakartaSans(color: textDark),
      bodyMedium: GoogleFonts.plusJakartaSans(color: textMuted),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceWhite,
      foregroundColor: textDark,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceWhite,
      selectedItemColor: primaryOlive,
      unselectedItemColor: Color(0xFF8C987A),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    cardTheme: CardThemeData(
      color: surfaceWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE2E8D8), width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOlive,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryOlive,
        side: const BorderSide(color: primaryOlive, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceWhite,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD6DEC9)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD6DEC9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryOlive, width: 2),
      ),
      hintStyle: GoogleFonts.plusJakartaSans(color: const Color(0xFFA0AC8E)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: secondaryOlive,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF2D381B),
      onPrimaryContainer: Colors.white,
      secondary: primaryOlive,
      onSecondary: Colors.white,
      surface: surfaceDark,
      onSurface: Colors.white,
      error: Color(0xFFF56C6C),
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: secondaryOlive,
      unselectedItemColor: Color(0xFF7A8966),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: borderDark, width: 1),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryOlive,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  );
}
