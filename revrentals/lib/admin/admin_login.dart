import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:revrentals/admin/admin_home.dart';
import 'package:revrentals/components/my_textfield.dart';
import 'package:revrentals/components/my_button.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // SIGN USER IN METHOD
  void signUserIn(BuildContext context) async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try to sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(), // Trim whitespace
        password: passwordController.text.trim(),
      );
      Navigator.pop(context); // Close the loading dialog

      // Navigate to Admin Home Page after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  AdminHomePage()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
        errorMessage(message);
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password.';
        errorMessage(message);
      } else {
        message = 'An error occurred. Please try again.';
        errorMessage(message);
      }
    }
  }

  void errorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Failed"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const SizedBox(height: 50),
                Image.asset(
                  'lib/images/rr_logo.png',
                  height: 300,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sign in as Admin',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                MyButton(
                  onTap: () => signUserIn(context),
                  label: 'Sign In',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
