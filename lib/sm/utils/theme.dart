import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTheme {
  static const appBarColor = Color.fromRGBO(10, 10, 10, 1);
  static Color primaryColor = Colors.grey.shade900;

  MaterialColor mainThemecolor = MaterialColor(
    0xFF424242,
    <int, Color>{
      50: Colors.grey.shade50,
      100: Colors.grey.shade100,
      200: Colors.grey.shade200,
      300: Colors.grey.shade300,
      400: Colors.grey.shade400,
      500: Colors.grey.shade500,
      600: Colors.grey.shade600,
      700: Colors.grey.shade700,
      800: Colors.grey.shade800,
      900: Colors.grey.shade900,
    },
  );

  static final darkMode = ThemeData.dark().copyWith(
    useMaterial3: false,
      scaffoldBackgroundColor: appBarColor,
      cardColor: Colors.grey.shade800,
      appBarTheme: const AppBarTheme(
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: appBarColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade300),
      primaryColor: primaryColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Colors.grey.shade900))));

  static final lightMode = ThemeData(
    useMaterial3: false,
      cardColor: Colors.grey.shade100,
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: MaterialColor(
        0xFF424242,
        <int, Color>{
          50: Colors.grey.shade50,
          100: Colors.grey.shade100,
          200: Colors.grey.shade200,
          300: Colors.grey.shade300,
          400: Colors.grey.shade400,
          500: Colors.grey.shade500,
          600: Colors.grey.shade600,
          700: Colors.grey.shade700,
          800: Colors.grey.shade900,
          900: Colors.grey.shade900,
        },
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.grey.shade900,
        indicatorColor: Colors.grey.shade900,
        unselectedLabelColor: Colors.grey,
      ),
      iconTheme: IconThemeData(color: Colors.grey.shade900),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey),
      fontFamily: "inter");
}

final themeControllerProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode thememode;
  ThemeNotifier({this.thememode = ThemeMode.light}) : super(MyTheme.lightMode);

  void getCurrentTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString("theme");
    if (theme == "light") {
      thememode = ThemeMode.light;
      state = MyTheme.lightMode;
    } else {
      thememode = ThemeMode.dark;
      state = MyTheme.darkMode;
    }
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (thememode == ThemeMode.dark) {
      thememode = ThemeMode.light;
      state = MyTheme.lightMode;
      prefs.setString('theme', 'light');
    } else {
      thememode = ThemeMode.dark;
      state = MyTheme.darkMode;
      prefs.setString('theme', 'dark');
    }
  }


  void toDarkTheme()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(thememode == ThemeMode.light){
      thememode = ThemeMode.dark;
      state = MyTheme.darkMode;
      prefs.setString('theme', 'dark');
    }
  }


  void toLightTheme()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(thememode == ThemeMode.dark){
      thememode = ThemeMode.light;
      state = MyTheme.lightMode;
      prefs.setString('theme', 'light');
    }
  }


  // void changeTheme({required isDark}) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (thememode == ThemeMode.dark) {
  //     thememode = ThemeMode.light;
  //     state = MyTheme.lightMode;
  //     prefs.setString('theme', 'light');
  //   } else {
  //     thememode = ThemeMode.dark;
  //     state = MyTheme.darkMode;
  //     prefs.setString('theme', 'dark');
  //   }
  // }
}
