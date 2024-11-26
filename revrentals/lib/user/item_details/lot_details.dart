import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revrentals/main_pages/auth_page.dart';

class LotDetailsPage extends StatefulWidget {
  final String lotAddress;
  final String description;
  final double rentalPrice;
  final String imagePath;

  const LotDetailsPage({super.key, 
    required this.lotAddress,
    required this.description,
    required this.rentalPrice,
    required this.imagePath,
  });

  @override
  State<LotDetailsPage> createState() => _LotDetailsPageState();
}

class _LotDetailsPageState extends State<LotDetailsPage> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  // Sign out function
  void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AuthPage()));
  }

  // Function to select start rental date with white background
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blueGrey, // Button color
            dialogBackgroundColor: Colors.white, // White background
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: const ColorScheme.light(
                primary: Colors.blueGrey), // Adjust color scheme
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
      });
    }
  }

  // Function to select end rental date with white background
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blueGrey, // Button color

            dialogBackgroundColor: Colors.white, // White background
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: const ColorScheme.light(
                primary: Colors.blueGrey), // Adjust color scheme
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
      });
    }
  }

  // Function to handle gear rental
  void _rentGear() {
    if (selectedStartDate != null && selectedEndDate != null) {
      // If dates are selected, show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gear rented from ${DateFormat('yyyy-MM-dd').format(selectedStartDate!)} to ${DateFormat('yyyy-MM-dd').format(selectedEndDate!)}',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      print(
          'Gear rented from ${DateFormat('yyyy-MM-dd').format(selectedStartDate!)} to ${DateFormat('yyyy-MM-dd').format(selectedEndDate!)}');
    } else {
      // Show error message if dates aren't selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select both start and end dates.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.lotAddress),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lot image
            Center(
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            // Lot address
            Text(
              widget.lotAddress,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            // Description
            Text(
              widget.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Rental Price
            Text(
              'Per Day: \$${widget.rentalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to MarketplacePage under Lots tab
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(iconColor: Colors.blueGrey),
              child: const Text('Back to Lots'),
            ),
          ],
        ),
      ),
    );
  }
}
