import 'package:flutter/material.dart';
import 'package:revrentals/main_pages/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Colors.white,
          headerBackgroundColor: Color.fromARGB(255, 163, 196, 212),
          // dayForegroundColor: WidgetStatePropertyAll()
        ),
        cardTheme:
            const CardTheme(color: Colors.white, surfaceTintColor: Colors.blue),
        scaffoldBackgroundColor: Colors.white,
        dialogBackgroundColor: Colors.white,
        // TODO: Text theme
        textTheme: const TextTheme(),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueGrey,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(fillColor: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 163, 196, 212),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              foregroundColor: Colors.white,
              iconColor: Colors.white),
        ),
        // TODO: Button theme
        buttonTheme: const ButtonThemeData(),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.blueGrey,
          selectedItemColor: Colors.white,
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
        ),

        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 2, color: Color.fromARGB(255, 188, 205, 214)),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2, color: Color.fromARGB(255, 135, 158, 170))),
        ),
      ),

      home: const AuthPage(),
    );
  }
}
