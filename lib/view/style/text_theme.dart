import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/view/style/const_color.dart';

class TextThemes {
  static TextTheme lightTextTheme = TextTheme(
    headlineSmall: GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      color: useWhiteForeground(bluishClr)
          ? Colors.white.withOpacity(0.87)
          : Colors.black.withOpacity(0.87),
    ),
    titleMedium: GoogleFonts.lato(
      color: useWhiteForeground(bluishClr)
          ? Colors.white.withOpacity(0.87)
          : Colors.black.withOpacity(0.87),
    ),
    bodyLarge: GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(0, 0, 0, 0.87),
    ),
    bodyMedium: GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(255, 255, 255, 1),
    ),
    headlineMedium: GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      fontSize: 25,
      color: Color.fromRGBO(0, 0, 0, 1),
    ),
  );
  static TextTheme darkTextTheme = TextTheme(
    headlineSmall: GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      color: useWhiteForeground(bluishClr)
          ? Colors.white.withOpacity(0.87)
          : Colors.black.withOpacity(0.87),
    ),
    titleMedium: GoogleFonts.lato(
      color: useWhiteForeground(bluishClr)
          ? Colors.white.withOpacity(0.87)
          : Colors.black.withOpacity(0.87),
    ),
    bodyLarge: GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(255, 255, 255, 0.87),
    ),
    bodyMedium: GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(255, 255, 255, 1),
    ),
    headlineMedium: GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      fontSize: 25,
      color: Color.fromRGBO(255, 255, 255, 1),
    ),
  );
}
