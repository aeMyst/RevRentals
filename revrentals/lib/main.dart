import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'RevRentals',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      //   useMaterial3: true,
      // ),
      theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(
          //   seedColor: Colors.pink,

          // ),
          // primaryColor: Colors.pink,
          // accentColor: Colors.red,
          dialogBackgroundColor: Colors.white,
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
                  iconColor: Colors.white)),
          buttonTheme: const ButtonThemeData(),

          // textButtonTheme: TextButtonThemeData(
          //     style: ButtonStyle(
          //       foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          //     ),
          //     onPressed: () {},
          //     child: const Text(
          //       'Text Button',
          //       style: TextStyle(
          //         color: Colors.blue,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     ),

          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2, color: Color.fromARGB(255, 188, 205, 214)),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: Color.fromARGB(255, 135, 158, 170))),
          )),
      home: const AuthPage(),
    );
  }
}
