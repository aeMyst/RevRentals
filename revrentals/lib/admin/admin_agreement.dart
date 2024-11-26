import 'package:flutter/material.dart';

class AdminAgreementPage extends StatelessWidget {
  const AdminAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reservations'),
      ),
      body: const Center(child: Text('Reservations here'),),
    );
  }
}
