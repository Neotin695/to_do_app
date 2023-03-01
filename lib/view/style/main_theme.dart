import 'package:flutter/material.dart';

import 'text_theme.dart';

class Themes {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.indigo,
    brightness: Brightness.light,
    textTheme: TextThemes.lightTextTheme,
  );
  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.indigo,
    brightness: Brightness.dark,
    textTheme: TextThemes.darkTextTheme,
  );
}
