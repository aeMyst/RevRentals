import 'package:flutter/material.dart';
import 'package:revrentals/admin/admin_home.dart';
import 'package:revrentals/components/my_textfield.dart';
import 'package:revrentals/components/my_button.dart';
import 'package:revrentals/services/admin_service.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final adminNameController = TextEditingController();
  final passwordController = TextEditingController();
  final AdminService _adminService = AdminService();

  void signUserIn(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    String adminName = adminNameController.text.trim();
    String password = passwordController.text.trim();

    try {
      final response = await _adminService.adminLogin(adminName, password);
      if (response['success']) {
        // Navigate to Admin Home Page after successful login
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminHomePage(
              adminId: response['admin_id'],
            ),
          ),
        );
      } else {
        errorMessage(response['error']);
      }
    } catch (e) {
      Navigator.pop(context); // Close the loading dialog
      errorMessage("Invalid username or password. Please try again.");
    } finally {}
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
      appBar: AppBar(),
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
