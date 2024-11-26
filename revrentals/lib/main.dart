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
          // textTheme: TextTheme(),


          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2, color: Color.fromARGB(255, 188, 205, 214)),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: Color.fromARGB(255, 135, 158, 170))),
          )),
      home: AuthPage(),
    );
  }
}
