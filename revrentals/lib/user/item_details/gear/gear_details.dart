import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'package:revrentals/services/listing_service.dart';

class GearDetailPage extends StatefulWidget {
  final int profileId;
  final Map<String, dynamic> gearData; // Accept the full gear data as a Map

  const GearDetailPage({
    super.key,
    required this.profileId,
    required this.gearData,
  });

  @override
  _GearDetailPageState createState() => _GearDetailPageState();
}

class _GearDetailPageState extends State<GearDetailPage> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  ListingService _listingService = ListingService();

  // Sign out function
  void signUserOut(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AuthPage()));
  }

  // Function to select start rental date
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
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
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedEndDate = picked;
      });
    }
  }

  // Function to handle gear rental
  Future<void> _rentGear() async {
    if (selectedStartDate != null && selectedEndDate != null) {
      try {
        // Convert DateTime objects to strings in the format yyyy-MM-dd
        String formattedStartDate =
            DateFormat('yyyy-MM-dd').format(selectedStartDate!);
        String formattedEndDate =
            DateFormat('yyyy-MM-dd').format(selectedEndDate!);

        Map<String, dynamic> listingData = {
          "profile_id": widget.profileId,
          "product_no": widget.gearData['Product_no'],
          "start_date": formattedStartDate,
          "end_date": formattedEndDate,
        };
        await _listingService.addReservation(listingData);

        final String rentalPeriod = '$formattedStartDate to $formattedEndDate';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gear rented for $rentalPeriod'),
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        print('Error occurred trying to rent gear: $e');
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
    final gear = widget.gearData;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Gear Details"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gear image (placeholder as there's no image in the data)
            Center(
              child: Image.asset(
                'lib/images/gear/agv_pista.webp',
                fit: BoxFit.contain,
                height: 300,
                width: 300,
              ),
            ),
            const SizedBox(height: 20),

            // Gear name
            Center(
              child: Text(
                gear['Gear_Name'] ?? 'No Name Available',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Gear details
            Center(
              child: Text(
                "Brand: ${gear['Brand'] ?? 'N/A'}\n"
                "Material: ${gear['Material'] ?? 'N/A'}\n"
                "Type: ${gear['Type'] ?? 'N/A'}\n"
                "Size: ${gear['Size'] ?? 'N/A'}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            // Gear price
            Center(
              child: Text(
                'Per day: \$${gear['GRentalPrice']?.toStringAsFixed(2) ?? '0.00'} CAD',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
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
