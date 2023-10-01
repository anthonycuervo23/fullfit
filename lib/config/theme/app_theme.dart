import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// const colorSeed = Color(0xFFF0112C);
// const colorSeed = Color(0xFFE74646);
const colorSeed = Color(0xFF8A58EF);
// const scaffoldBackgroundColorLight = Color.fromARGB(255, 252, 246, 246);
const scaffoldBackgroundColorLight = Color(0xffF4F6FA);
const scaffoldBackgroundColorDark = Color.fromARGB(255, 19, 13, 31);

class AppTheme {
  final bool isDarkMode;

  AppTheme({this.isDarkMode = false});

  ThemeData getTheme() => ThemeData(

      ///* General
      useMaterial3: true,
      colorSchemeSeed: colorSeed,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,

      ///* Texts
      textTheme: TextTheme(
        titleLarge: GoogleFonts.roboto()
            .copyWith(fontSize: 36.sp, fontWeight: FontWeight.bold),
        titleMedium: GoogleFonts.roboto()
            .copyWith(fontSize: 26.sp, fontWeight: FontWeight.bold),
        titleSmall: GoogleFonts.roboto().copyWith(fontSize: 18.sp),
        bodyLarge: GoogleFonts.roboto(),
        bodyMedium: GoogleFonts.roboto(),
        bodySmall: GoogleFonts.roboto(),
      ),

      ///* Scaffold Background Color
      scaffoldBackgroundColor: isDarkMode
          ? scaffoldBackgroundColorDark
          : scaffoldBackgroundColorLight,

      ///* Buttons
      filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStatePropertyAll(
                  GoogleFonts.roboto().copyWith(fontWeight: FontWeight.w700)))),

      ///* AppBar
      appBarTheme: AppBarTheme(
        color: isDarkMode
            ? scaffoldBackgroundColorDark
            : scaffoldBackgroundColorLight,
        titleTextStyle: GoogleFonts.roboto().copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black54),
      ));

  AppTheme copyWith({bool? isDarkMode}) =>
      AppTheme(isDarkMode: isDarkMode ?? this.isDarkMode);
}
