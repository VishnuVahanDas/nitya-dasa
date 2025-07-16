import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color saffron = Color(0xFFFF9933);
  static const Color tulasiGreen = Color(0xFF009F30);
  static const Color gopiBlue = Color(0xFF0F52BA);

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: saffron,
      secondary: tulasiGreen,
      tertiary: gopiBlue,
    ),
    textTheme: GoogleFonts.hindTextTheme(ThemeData.light().textTheme),
  );
}
