import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'package:revrentals/services/listing_service.dart';
import 'package:revrentals/user/garage/garage.dart';
import 'package:revrentals/user/notifications/agreement_transaction.dart';

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
  bool _isLoading = false;

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
  // Function to handle renting the lot
  Future<void> _rentLot() async {
    if (selectedStartDate == null || selectedEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end dates.')),
      );
      return;
    }

      setState(() {
        _isLoading = true; // Start loading
      });


    try {
      // Step 1: Check for active lot rental
      final activeRental = await _listingService.checkActiveLotRental(widget.profileId);

      if (activeRental['has_active_rental'] == true) {
        final endDate = activeRental['rental_details']['end_date'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You already have a lot rented until $endDate. You cannot rent another lot.',
            ),
          ),
        );
        return;
      }

      // Step 2: Format dates for reservation
      String formattedStartDate = DateFormat('yyyy-MM-dd').format(selectedStartDate!);
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(selectedEndDate!);
      print('Full lot data: ${widget.lotData}');
      // Debug prices
      print('Rental price from lot data: ${widget.lotData['LRentalPrice']}');
      final duration = selectedEndDate!.difference(selectedStartDate!).inDays + 1;
      final totalPrice = (widget.lotData['LRentalPrice'] ?? 0.0) * duration;
      print('Calculated total price: $totalPrice');

      // Step 3: Add reservation
      Map<String, dynamic> listingData = {
        "profile_id": widget.profileId,
        "lot_no": widget.lotData['Lot_No'],
        "start_date": formattedStartDate,
        "end_date": formattedEndDate,
      };

      print('Sending listing data: $listingData'); // Debug print

      final response = await _listingService.addReservation(listingData);
      print('Received response: $response'); // Debug print

      if (response['success'] != true || response['reservation_no'] == null) {
        throw Exception('Failed to create reservation. Invalid response: $response');
      }

      final reservationNo = response['reservation_no'] as int;
      print('Reservation number: $reservationNo'); // Debug print

      // Step 4: Fetch reservation details
      final reservationDetails = await _listingService.fetchReservationDetails(reservationNo);
      print('Reservation details: $reservationDetails'); // Debug print

      // Step 5: Navigate to transaction page
      if (!mounted) return; // Check if widget is still mounted

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AgreementTransactionPage(
            itemName: widget.lotData['LAddress'],
            renterName: "${reservationDetails['renter_first_name']} ${reservationDetails['renter_last_name']}",
            rentalPeriod: '$formattedStartDate to $formattedEndDate',
            rentalPrice: widget.lotData['LRentalPrice'] ?? 0.0,
            totalPrice: totalPrice,
            onActionCompleted: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transaction completed successfully.')),
              );
            },
            agreementId: reservationNo,
          ),
        ),
      );

    } catch (e) {
      print('Error occurred trying to rent storage lot: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
            Center(
              child: Text(
                "Rental Price: \$${lot['LRentalPrice'].toStringAsFixed(2)}/day",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
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
                  onPressed: _isLoading ? null : _rentLot, // Disable button while loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    textStyle: const TextStyle(fontSize: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Rent Lot'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
