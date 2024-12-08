import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revrentals/services/listing_service.dart';
import 'package:revrentals/user/garage/maint_records.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:revrentals/main_pages/login_page.dart';

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

  Future<void> _rentMotorcycle() async {
    if (selectedStartDate != null && selectedEndDate != null) {
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
                'Motorcycle Request sent to Seller for Approval During This Period: $rentalPeriod'),
            duration: const Duration(seconds: 5),
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
        const SnackBar(
            content: Text('Please select both start and end dates.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String model = widget.motorcycleData['Model'] ?? 'Unknown Model';
    final double rentalPrice =
        (widget.motorcycleData['Rental_Price'] as num?)?.toDouble() ?? 0.0;
    final String imagePath = widget.motorcycleData['Image_Path'] ??
        'lib/images/motorcycle/default_motorcycle.png';
    final String vin = (widget.motorcycleData['VIN']);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      LoginPage(), // Redirect to the login page
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              try {
                final response = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayProfileDetailsPage(
                      profileId: widget.profileId,
                    ),
                  ),
                );

                if (response != null) {
                  // Handle any updates if needed
                  setState(() {
                    // Refresh any profile-dependent data here if necessary
                  });
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error loading profile: $e')),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Space out content
          children: [
            // Top section: Image and details
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Motorcycle Image
                Center(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    // height: 200,
                    // width: 300,
                  ),
                ),
                const SizedBox(height: 20),
                // Motorcycle Model
                Text(
                  model,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // Rental Price
                Text(
                  'Per Day: \$${rentalPrice.toStringAsFixed(2)} CAD',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ViewMaintenanceRecordsPage(vin: vin)));
                  },
                  child: const Text('View Maintenance Records'),
                ),
              ],
            ),

            // Middle Section: Date Pickers and Rent Button
            Column(
              children: [
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
                              : DateFormat('yyyy-MM-dd')
                                  .format(selectedStartDate!),
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
                              : DateFormat('yyyy-MM-dd')
                                  .format(selectedEndDate!),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _rentMotorcycle,
                  child: const Text('Rent Motorcycle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
