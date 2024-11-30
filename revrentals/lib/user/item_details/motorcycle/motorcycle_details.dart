import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'package:revrentals/services/admin_service.dart';
import 'package:revrentals/services/auth_service.dart';
import 'package:revrentals/services/listing_service.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:intl/intl.dart';

class MotorcycleDetailPage extends StatefulWidget {
  final int profileId;
  final Map<String, dynamic> motorcycleData; // Accept motorcycleData as a Map

  const MotorcycleDetailPage({
    super.key,
    required this.profileId,
    required this.motorcycleData,
  });

  @override
  _MotorcycleDetailPageState createState() => _MotorcycleDetailPageState();
}

class _MotorcycleDetailPageState extends State<MotorcycleDetailPage> {
  final ListingService _listingService = ListingService();
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  void signUserOut(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AuthPage()));
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedEndDate = picked;
      });
    }
  }


Future<void> _rentMotorcycle() async {
  if (selectedStartDate != null && selectedEndDate != null) {
    try {
      // Convert DateTime objects to strings in the format yyyy-MM-dd
      String formattedStartDate = DateFormat('yyyy-MM-dd').format(selectedStartDate!);
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(selectedEndDate!);

      Map<String, dynamic> listingData = {
        "profile_id": widget.profileId,
        "vin": widget.motorcycleData['VIN'],
        "start_date": formattedStartDate,
        "end_date": formattedEndDate,
      };

      await _listingService.addReservation(listingData);
      
      final String rentalPeriod =
          '$formattedStartDate to $formattedEndDate';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Motorcycle successfully rented for $rentalPeriod'),
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error occurred trying to rent motorcycle: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select both start and end dates.')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final String model = widget.motorcycleData['Model'] ?? 'Unknown Model';
    final double rentalPrice =
        (widget.motorcycleData['Rental_Price'] as num?)?.toDouble() ?? 0.0;
    final String imagePath =
        widget.motorcycleData['Image_Path'] ?? 'assets/default_motorcycle.png';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => signUserOut(context),
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DisplayProfileDetailsPage()),
            ),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Display motorcycle image
            Center(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: 200,
                width: 300,
              ),
            ),
            const SizedBox(height: 20),
            // Display motorcycle model
            Center(
              child: Text(
                model,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            // Display rental price
            Center(
              child: Text(
                'Per Day: \$${rentalPrice.toStringAsFixed(2)} CAD',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _selectStartDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      selectedStartDate == null
                          ? 'Start Date'
                          : DateFormat('yyyy-MM-dd').format(selectedStartDate!),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () => _selectEndDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      selectedEndDate == null
                          ? 'End Date'
                          : DateFormat('yyyy-MM-dd').format(selectedEndDate!),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _rentMotorcycle,
                child: const Text('Rent Motorcycle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
