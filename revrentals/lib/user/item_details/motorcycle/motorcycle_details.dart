import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'package:revrentals/user/marketplace.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:intl/intl.dart';

class MotorcycleDetailPage extends StatefulWidget {
  final String model;         
  final double rentalPrice;
  final String imagePath;

  const MotorcycleDetailPage({
    super.key,
    required this.model,
    required this.rentalPrice,
    required this.imagePath,
  });

   @override
  _MotorcycleDetailPageState createState() => _MotorcycleDetailPageState();
}

class _MotorcycleDetailPageState extends State<MotorcycleDetailPage> {
  
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  // sign out function
  void signUserOut(BuildContext context) {
    // FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AuthPage()));
  }

  // function to select start rental date
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

  // function to select end date
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

  // function to HANDLE RENTAL (TO-DO) -----------------
   void _rentMotorcycle() {
  if (selectedStartDate != null && selectedEndDate != null) {
    // if dates are selected, show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Motorcycle rented from ${DateFormat('yyyy-MM-dd').format(selectedStartDate!)} to ${DateFormat('yyyy-MM-dd').format(selectedEndDate!)}'),
        duration: const Duration(seconds: 3),  
      ),
    );
    print('Motorcycle rented from ${DateFormat('yyyy-MM-dd').format(selectedStartDate!)} to ${DateFormat('yyyy-MM-dd').format(selectedEndDate!)}');
  } else {
    // show error message if dates aren't selected
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select both start and end dates.')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MarketplacePage()),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => signUserOut(context),
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DisplayProfileDetailsPage()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            Center(
              child: Image.asset(
                widget.imagePath,  
                fit: BoxFit.contain,
                height: 300,
                width: 300,
              ),
            ),
            const SizedBox(height: 20),

            // motorcycle title
            Center(
              child: Text(
                widget.model,  
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // motorcycle price
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

            // select rental start and end date
           Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center the row
            children: [
              // select start date
              GestureDetector(
                onTap: () => _selectStartDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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

              // select end date
              GestureDetector(
                onTap: () => _selectEndDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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

            //rent button
            Center(
              child: ElevatedButton(
                onPressed: _rentMotorcycle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  textStyle: const TextStyle(
                    fontSize: 14,),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), 
                  ),
                ),
                child: const Text('Rent Motorcycle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
