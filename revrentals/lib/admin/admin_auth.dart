import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:revrentals/admin/admin_home.dart';
import 'package:revrentals/admin/admin_login.dart';

class AdminAuthPage extends StatelessWidget {
  const AdminAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // user is logged in
        if (snapshot.hasData) {
          return const AdminHomePage();
        }
        // USER IS NOT LOGGED IN
        else {
          return const AdminLoginPage();
        }
      },
    ));
  }
}
