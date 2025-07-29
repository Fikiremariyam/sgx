import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
  primaryColor: Colors.blue,
  colorScheme: ColorScheme.light(
    primary: const Color.fromARGB(255, 255, 255, 255),
    secondary: Color.fromARGB(255, 0, 9, 0),
    background: Color.fromARGB(255, 245, 245, 245),
    surface: const Color.fromARGB(255, 248, 246, 246),
    error: Colors.red,
    onPrimary: const Color.fromARGB(255, 255, 255, 255),
    onSecondary: Colors.white,
    onBackground: Colors.black87,
    onSurface: Colors.black,
    onError: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF4CAF50),
    iconTheme: IconThemeData(color: Color(0xFF4CAF50)),
    titleTextStyle: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  iconTheme: IconThemeData(color: Colors.teal),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color.fromARGB(157, 119, 120, 120),
    textTheme: ButtonTextTheme.primary,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: const Color.fromARGB(255, 25, 197, 216)),
    bodyMedium: TextStyle(color: const Color.fromARGB(255, 8, 9, 8)),
  ),
);

final darkTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xFF1E1E1E),
  primaryColor: const Color(0xFF0A0E21),
  colorScheme: ColorScheme.dark(
    primary: Color.fromARGB(255, 0, 9, 0),
    secondary: const Color.fromARGB(255, 255, 255, 255),
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    error: Colors.redAccent,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onBackground: Colors.white70,
    onSurface: Colors.white,
    onError: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromARGB(255, 18, 32, 47),
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  iconTheme: IconThemeData(color: Colors.tealAccent),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
    titleLarge:
        TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.tealAccent,
    textTheme: ButtonTextTheme.primary,
  ),
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
);

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
