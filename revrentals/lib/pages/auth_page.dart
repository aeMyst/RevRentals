import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:revrentals/pages/home_page.dart';
import 'package:revrentals/pages/login_page.dart';
import 'package:revrentals/pages/signup_page.dart';

class AuthPage extends StatelessWidget{
  const AuthPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return HomePage();
          }
          // USER IS NOT LOGGED IN
          else {
            return LoginPage();
          }
        },
        )

    );
  }

}