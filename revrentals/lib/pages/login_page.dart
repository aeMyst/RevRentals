import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/admin/admin_auth.dart';
import 'package:revrentals/components/my_button.dart';
import 'package:revrentals/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:revrentals/user/profile_detail.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isSignUpMode = false;

  void toggleAuthMode(bool isSignUp) {
    setState(() {
      isSignUpMode = isSignUp;
    });
  }

  Future<void> authenticateUser(BuildContext context) async {
    if (isSignUpMode) {
      await signUpUser(context);
    } else {
      await signInUser(context);
    }
  }

  Future<void> signInUser(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context); // Close loading dialog
      // Navigate to Home or Profile based on your app logic
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileDetailsPage()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close loading dialog
      showError(e.message ?? 'Failed to log in');
    }
  }

  Future<void> signUpUser(BuildContext context) async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showError("All fields are required.");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showError("Passwords do not match.");
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context); // Close loading dialog
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileDetailsPage()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close loading dialog
      showError(e.message ?? 'Failed to sign up');
    }
  }

  Future<void> resetPassword(BuildContext context) async {
    if (emailController.text.isEmpty) {
      showError("Please enter your email.");
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
      Navigator.pop(context); // Close loading dialog
      showError("Password reset email sent. Check your inbox.");
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close loading dialog
      showError(e.message ?? 'Failed to send password reset email');
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
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

  void getAdminPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminAuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/images/rr_logo.png',
                      height: 300,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome to RevRentals',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Create an account or log in to access the app.',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(height: 25),
                CupertinoSlidingSegmentedControl<int>(
                  children: const {
                    0: Text('Log In', style: TextStyle(fontSize: 16)),
                    1: Text('Sign Up', style: TextStyle(fontSize: 16)),
                  },
                  groupValue: isSignUpMode ? 1 : 0,
                  onValueChanged: (int? newValue) {
                    toggleAuthMode(newValue == 1);
                  },
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
                if (isSignUpMode) ...[
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                ],
                const SizedBox(height: 20),
                MyButton(
                  onTap: () => authenticateUser(context),
                  label: isSignUpMode ? 'Sign Up' : 'Log In',
                ),
                if (!isSignUpMode)
                  TextButton(
                    onPressed: () => resetPassword(context),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => getAdminPage(context),
                  child: const Text(
                    'Sign in as Admin',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
