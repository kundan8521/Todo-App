import 'package:flutter/material.dart';

import '../constant/colors.dart';

class AppTheme {
  static final ThemeData _dayTheme = ThemeData(
      scaffoldBackgroundColor: appBg,
      appBarTheme: _appBarTheme,
      floatingActionButtonTheme: _floatingActionButtonTheme);

  static ThemeData get dayTheme => _dayTheme;

  static get _appBarTheme => const AppBarTheme(backgroundColor: appBrBg);

  static get _floatingActionButtonTheme =>
      const FloatingActionButtonThemeData(backgroundColor: appBrBg,);
}
