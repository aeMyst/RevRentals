import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revrentals/services/listing_service.dart';
import 'package:revrentals/user/garage/maint_records.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:revrentals/main_pages/login_page.dart';

class MotorcycleDetailPage extends StatefulWidget {
  final int profileId;
  final Map<String, dynamic> motorcycleData;

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
        selectedEndDate = null; // Reset end date when start date changes
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    if (selectedStartDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a start date first.')),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate!.add(const Duration(days: 1)),
      firstDate: selectedStartDate!.add(const Duration(days: 1)),
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
      if (selectedEndDate!.isBefore(selectedStartDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End date cannot be earlier than the start date.'),
          ),
        );
        return;
      }

      try {
        String formattedStartDate =
            DateFormat('yyyy-MM-dd').format(selectedStartDate!);
        String formattedEndDate =
            DateFormat('yyyy-MM-dd').format(selectedEndDate!);

        Map<String, dynamic> listingData = {
          "profile_id": widget.profileId,
          "vin": widget.motorcycleData['VIN'],
          "start_date": formattedStartDate,
          "end_date": formattedEndDate,
        };

        await _listingService.addReservation(listingData);

        final String rentalPeriod = '$formattedStartDate to $formattedEndDate';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Motorcycle request sent to seller for approval during this period: $rentalPeriod'),
            duration: const Duration(seconds: 5),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
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
    final String model = widget.motorcycleData['Model'] ?? 'Unknown Model';
    final double rentalPrice = (widget.motorcycleData['Rental_Price'] as num?)?.toDouble() ?? 0.0;
    final String vehicleType = widget.motorcycleData['Vehicle_Type'] ?? 'Unknown Type';
    final String color = widget.motorcycleData['Color'] ?? 'Unknown Color';
    final int mileage = widget.motorcycleData['Mileage'] ?? 0;
    final String insurance = widget.motorcycleData['Insurance'] ?? 'Unknown';
    final String vin = widget.motorcycleData['VIN'] ?? 'Unknown VIN';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Vehicle Details"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Motorcycle Image
            Center(
              child: Image.asset(
                'lib/images/motorcycle/default_motorcycle.png',
                fit: BoxFit.contain,
                height: 300,
                width: 300,
              ),
            ),
            const SizedBox(height: 20),
            
            // Model Name
            Center(
              child: Text(
                model,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            // Vehicle details in centered format
            Center(
              child: Text(
                "Vehicle Type: $vehicleType\n"
                "Color: $color\n"
                "Mileage: $mileage km\n"
                "Insurance: $insurance\n",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            
            // Rental Price
            Center(
              child: Text(
                'Rental Price Per Day: \$${rentalPrice.toStringAsFixed(2)} CAD',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Date Selection Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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

            // View Maintenance Records Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewMaintenanceRecordsPage(vin: vin),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  textStyle: const TextStyle(fontSize: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('View Maintenance Records'),
              ),
            ),
            const SizedBox(height: 10),

            // Rent Button
            Center(
              child: ElevatedButton(
                onPressed: _rentMotorcycle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  textStyle: const TextStyle(fontSize: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Rent Vehicle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}