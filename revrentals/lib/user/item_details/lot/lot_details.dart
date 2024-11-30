import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'package:revrentals/services/listing_service.dart';

class LotDetailsPage extends StatefulWidget {
  final int profileId;
  final Map<String, dynamic> lotData; // Accept the full lot data as a Map

  const LotDetailsPage({
    super.key,
    required this.profileId,
    required this.lotData,
  });

  @override
  State<LotDetailsPage> createState() => _LotDetailsPageState();
}

class _LotDetailsPageState extends State<LotDetailsPage> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  final ListingService _listingService = ListingService();

  // Sign out function
  void signUserOut(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AuthPage()));
  }

  // Function to select start rental date
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

  // Function to select end rental date
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

  // Function to handle renting the lot
  Future<void> _rentLot() async {
    if (selectedStartDate != null && selectedEndDate != null) {
      try {
        // Convert DateTime objects to strings in the format yyyy-MM-dd
        String formattedStartDate =
            DateFormat('yyyy-MM-dd').format(selectedStartDate!);
        String formattedEndDate =
            DateFormat('yyyy-MM-dd').format(selectedEndDate!);

        Map<String, dynamic> listingData = {
          "profile_id": widget.profileId,
          "lot_no": widget.lotData['Lot_No'],
          "start_date": formattedStartDate,
          "end_date": formattedEndDate,
        };

        await _listingService.addReservation(listingData);

        final String rentalPeriod = '$formattedStartDate to $formattedEndDate';
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Storage lot rented for $rentalPeriod'),
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        print('Error occurred trying to rent storage lot: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select both start and end dates.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lot = widget.lotData;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Lot Details"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lot image (placeholder as there's no image in the data)
            Center(
              child: Image.asset(
                'lib/images/placeholder_lot.png', // Replace with actual image path if available
                fit: BoxFit.cover,
                height: 300,
                width: 300,
              ),
            ),
            const SizedBox(height: 20),
            // Lot address
            Center(
              child: Text(
                "Address: ${lot['LAddress']}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Lot description
            Center(
              child: Text(
                "Admin ID: ${lot['Admin_ID']}",
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            // Select rental start and end date
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                onPressed: _rentLot,
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
                child: const Text('Rent Lot'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
