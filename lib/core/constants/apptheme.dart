import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/core/constants/appcolors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.white,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
    useMaterial3: true,
    fontFamily: GoogleFonts.varelaRound().fontFamily,
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(
        size: 25,
        color: Colors.black,
      ),
      titleTextStyle: GoogleFonts.varelaRound(
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: 24,
      ),
      backgroundColor: AppColors.white,
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      titleSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    ),
  );

}