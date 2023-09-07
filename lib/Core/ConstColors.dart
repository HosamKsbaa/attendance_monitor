import 'package:flutter/material.dart';
// ThemeData getTheme()=> ThemeData(
//   inputDecorationTheme: InputDecorationTheme(
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8),
//     ),
//   ),
//   outlinedButtonTheme: OutlinedButtonThemeData(
//     style: ButtonStyle(
//       padding: MaterialStateProperty.all<EdgeInsets>(
//         const EdgeInsets.all(24),
//       ),
//       backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
//       foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
//     ),
//   ),
// );


class ConstColors {
  static Color kPrimaryColor =   Colors.teal;
}
ThemeData getTheme()=>  ThemeData(
inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.all(24),
      ),
      backgroundColor: MaterialStateProperty.all<Color>( ConstColors.kPrimaryColor),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
  ),
  scaffoldBackgroundColor: Colors.white,
  primaryColor: ConstColors.kPrimaryColor,
  colorScheme: ColorScheme.light(primary: ConstColors.kPrimaryColor),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
        color: Colors.white,  fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        color: Colors.black,  fontWeight: FontWeight.bold),
    displayMedium: TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(
        color: Colors.grey,  fontWeight: FontWeight.bold),
  ),
);