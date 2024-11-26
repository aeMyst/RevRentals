import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/admin/admin_auth.dart';
import 'package:revrentals/components/my_button.dart';
import 'package:revrentals/components/my_textfield.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:revrentals/user/user_home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailOrUsernameController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isSignUpMode = false;
  int? _selectedRole = 0; // 0 for "Renter", 1 for "Seller"

  void toggleAuthMode(bool isSignUp) {
    setState(() {
      isSignUpMode = isSignUp;
    });
  }

  void onRoleSelected(int? newRole) {
    setState(() {
      _selectedRole = newRole;
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
    String input = emailOrUsernameController.text;
    String password = passwordController.text;

    // Placeholder for login logic: Use Django API here;

    if ((input == 'test' || input == 'test@gmail.com') &&
        password == 'test123') {
      Navigator.pop(context); // Close the loading dialog

      // Navigate to Admin Home Page after successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserHomePage()),
      );
    } else {
      showError(context, "Invalid login credentials");
    }
  }

  Future<void> signUpUser(BuildContext context) async {
    String username = usernameController.text;
    String emailOrUsername = emailOrUsernameController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (username.isEmpty ||
        emailOrUsername.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showError(context, "All fields are required.");
      return;
    }

    if (password != confirmPassword) {
      showError(context, "Passwords do not match.");
      return;
    }

    // Placeholder for sign-up logic: Use Django API here

    bool mockSuccess = true; // Change to false to simulate failure

    Navigator.pop(context);

    if (mockSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileDetailsPage()),
      );
    } else {
      showError(context, "Sign-up failed. Please try again.");
    }
  }

  void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Error",
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
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
                if (isSignUpMode) ...[
                  MyTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                ],
                MyTextField(
                  controller: emailOrUsernameController,
                  hintText: isSignUpMode ? 'Email' : 'Email or Username',
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
                const SizedBox(height: 15),
                MyButton(
                  onTap: () => authenticateUser(context),
                  label: isSignUpMode ? 'Sign Up' : 'Log In',
                ),
                const SizedBox(height: 20),
                // if (!isSignUpMode) TextButton(
                //   onPressed: () {
                //     // Implement password reset functionality
                //     print('Password reset requested');
                //   },
                //   child: const Text(
                //     'Forgot Password?',
                //     style: TextStyle(
                //       color: Colors.blue,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
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
