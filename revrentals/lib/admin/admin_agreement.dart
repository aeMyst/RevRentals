import 'package:flutter/material.dart';

class AdminAgreementPage extends StatelessWidget {
  const AdminAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: const Text('Reservations'),
        centerTitle: true,
      ),
      body: const Center(child: Text('Reservations here'),),
    );
  }
}
