import 'package:flutter/material.dart';
import 'package:synq/config/theme/app_text_colors.dart';

//app colors
final lightBackgroundColor = Colors.white;
// final lightBackgroundColor = Color(0xffe8d8c9);
// final lightBackgroundColor = Color(0xfffdfec2);
final darkBackgroundColor = Color(0xff121312);
final darkColorOnSurface = Color.fromARGB(255, 22, 25, 44);
final primaryColor = Color.fromARGB(255, 79, 90, 243);

//light theme data
final lightThemeData = ThemeData(
  fontFamily: "Inter",
  brightness: Brightness.light,
  scaffoldBackgroundColor: lightBackgroundColor,
  cardColor: Colors.grey.shade200,
  dividerColor: Colors.grey.shade400,

  extensions: [
    AppTextColors(
      primaryTextColor: Colors.black,
      secondaryTextColor: Colors.grey.shade700,
      hintTextColor: Colors.grey.shade400,
    ),
  ],

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
  ),

  bottomSheetTheme: BottomSheetThemeData(backgroundColor: lightBackgroundColor),
);

//dark theme data
final darkThemeData = ThemeData(
  fontFamily: "Poppins",
  brightness: Brightness.dark,
  scaffoldBackgroundColor: darkBackgroundColor,
  cardColor: Colors.grey.shade900,
  dividerColor: Colors.grey.shade900,

  extensions: [
    AppTextColors(
      primaryTextColor: Colors.white,
      secondaryTextColor: Colors.white38,
      hintTextColor: Colors.white70,
    ),
  ],

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
  ),

  dialogTheme: DialogThemeData(backgroundColor: Colors.grey.shade900),
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: darkColorOnSurface),
);
