import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revrentals/main_pages/auth_page.dart';

class LotDetailsPage extends StatefulWidget {
  final String lotAddress;
  final String description;
  final double rentalPrice;
  final String imagePath;

  const LotDetailsPage({
    super.key,
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
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
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
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
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
                height: 300,
                width: 300,
              ),
            ),
            const SizedBox(height: 20),
            // Lot address
            // Gear name
            Center(
              child: Text(
                widget.lotAddress,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            Center(
              child: Text(
                widget.description,
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            // Rental Price
            Center(
              child: Text(
                'Per day: \$${widget.rentalPrice.toStringAsFixed(2)} CAD',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Select rental start and end date
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the row
              children: [
                // Select start date
                GestureDetector(
                  onTap: () => _selectStartDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      selectedStartDate == null
                          ? 'Select Start Date'
                          : 'Start: ${DateFormat('yyyy-MM-dd').format(selectedStartDate!)}',
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // Select end date
                GestureDetector(
                  onTap: () => _selectEndDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      selectedEndDate == null
                          ? 'Select End Date'
                          : 'End: ${DateFormat('yyyy-MM-dd').format(selectedEndDate!)}',
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Rent button
            Center(
              child: ElevatedButton(
                onPressed: _rentGear,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  textStyle: const TextStyle(fontSize: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Rent Gear'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
