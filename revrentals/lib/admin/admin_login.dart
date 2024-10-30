import 'package:flutter/material.dart';

class AdminLoginPage extends StatelessWidget {
  const AdminLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Login'),
      ),
      body: Center(
        child: const Text(
          'Admin Login',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}