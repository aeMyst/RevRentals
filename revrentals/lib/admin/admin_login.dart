import 'package:flutter/material.dart';
import 'package:revrentals/admin/admin_home.dart';
import 'package:revrentals/components/my_textfield.dart';
import 'package:revrentals/components/my_button.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final adminNameController = TextEditingController();
  final passwordController = TextEditingController();

  // SIGN USER IN METHOD (Placeholder for Django API)
  void signUserIn(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Placeholder for login logic
    String adminName = adminNameController.text.trim();
    String password = passwordController.text.trim();

    try {
      // Simulate an API call to Django backend
      // Replace this with actual API logic
      // await Future.delayed(const Duration(seconds: 2));

      if (adminName == 'revrentals_admin' && password == 'admin123') {
        Navigator.pop(context); // Close the loading dialog

        // Navigate to Admin Home Page after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  AdminHomePage()),
        );
      } 
    } catch (e) {
      Navigator.pop(context); // Close the loading dialog
      // errorMessage("Invalid username or password. Please try again.");
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
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/images/rr_logo.png',
                  height: 300,
                ),
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
                  controller: adminNameController,
                  hintText: 'Admin Username',
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
