import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:revrentals/main_pages/login_page.dart';
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

            return FutureBuilder<bool>(
              future: _isProfileComplete(user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data == false) {
                  // Get profileId from user data
                  final profileId = user.uid; // Adjust this based on where you store profileId
                  return ProfileDetailsPage(profileId: int.parse(profileId));
                } else {
                  return const UserHomePage();
                }
              },
            );
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}