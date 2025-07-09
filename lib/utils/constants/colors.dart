import 'package:flutter/material.dart';

class TColors {
  TColors._();

  // Existing colours...
  static const Color primary = Colors.red;
  static const Color primaryGreen = Color(0xFF00B99C);
  static const Color primaryPink = Color(0xFFCD5D67);
  static const Color primaryBlue = Color(0xFF449DD1);
  static const Color secondary = Color(0xFFFFE23B);
  static const Color accent = Color(0xFFB0C7FF);

  static const Color redColor = Color(0xFFFF7A7A);
  static const Color greenColor = Color(0xFF33B500);
  static const Color yellowColor = Colors.orange;

  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C757C);
  static const Color textWhite = Colors.white;

  static const Color light = Color(0xFFF5F5F5);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F5FF);

  static const Color lightContainer = Color(0xFFF6F6F6);
  static const Color darkBackground = Color(0xFF252528);
  static const Color darkBorder = Color(0xFF4D4D4D);
  static const Color lightBorder = Color(0xFFEDEDED);
  static const Color darkContainer2 = Color(0xFF454548);
  static const Color darkContainer = Color(0xFF313134);

  static const Color buttonPrimary = Color(0xFF00B99C);
  static const Color buttonSecondary = Color(0xFF1BB1C7);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  static const Color black = Color(0xFF232323);
  static const Color black2 = Color(0xFF121212);
  static const Color deepBlack = Colors.black;
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE7E7E7);
  static const Color softGrey = Color(0xFFFCFAFA);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);

  // ──────────────────────────────────────────────
  // Red Crescent palette (prefix “crese”)
  static const MaterialColor cresePrimarySwatch = MaterialColor(
    0xFFE30613, // 500
    <int, Color>{
      50: Color(0xFFFFE5E7),   // crese50
      100: Color(0xFFFFCBCF),  // crese100
      200: Color(0xFFFF979F),  // crese200
      300: Color(0xFFFF636F),  // crese300
      400: Color(0xFFE33A48),  // crese400
      500: Color(0xFFE30613),  // crese500
      600: Color(0xFFD00512),  // crese600
      700: Color(0xFFB30411),  // crese700
      800: Color(0xFF91030F),  // crese800
      900: Color(0xFF6F020D),  // crese900
    },
  );

  // Individual crese shades
  static final Color crese50  = cresePrimarySwatch[50]!;
  static final Color crese100 = cresePrimarySwatch[100]!;
  static final Color crese200 = cresePrimarySwatch[200]!;
  static final Color crese300 = cresePrimarySwatch[300]!;
  static final Color crese400 = cresePrimarySwatch[400]!;
  static final Color crese500 = cresePrimarySwatch[500]!; // brand red
  static final Color crese600 = cresePrimarySwatch[600]!;
  static final Color crese700 = cresePrimarySwatch[700]!;
  static final Color crese800 = cresePrimarySwatch[800]!;
  static final Color crese900 = cresePrimarySwatch[900]!;

  // Helpers for light/dark variants
  static final Color creseLight = crese100;
  static final Color creseDark  = crese700;
  
  // Accent on crese backgrounds
  static const Color onCreseLight = Color(0xFF000000); // black on light red
  static const Color onCreseDark  = Color(0xFFFFFFFF); // white on dark red
}
