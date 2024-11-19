import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:revrentals/pages/home_page.dart';
import 'package:revrentals/pages/login_page.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:revrentals/user/user_home.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
  
  Future<bool> _isProfileComplete(User user) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return userDoc.exists && userDoc['profile_complete'] == true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;

            // Check if profile is complete and navigate accordingly
            return FutureBuilder<bool>(
              future: _isProfileComplete(user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data == false) {
                  // Profile is not complete; navigate to profile detail page
                  return ProfileDetailsPage();
                } else {
                  // Profile is complete or some error occurred; go to home page
                  return UserHomePage();
                }
              },
            );
          } else {
            // User is not logged in
            return LoginPage();
          }
        },
      ),
    );
  }
}
