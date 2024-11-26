import 'package:flutter/material.dart';

class AdminAgreementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: Text('Reservations'),
        centerTitle: true,
      ),
      body: Center(child: const Text('Reservations here'),),
    );
  }
}
