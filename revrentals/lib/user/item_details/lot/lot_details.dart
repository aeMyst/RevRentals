import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revrentals/services/listing_service.dart';
import 'package:revrentals/user/notifications/agreement_transaction.dart';

class LotDetailsPage extends StatefulWidget {
  final int profileId;
  final Map<String, dynamic> lotData;

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
        selectedEndDate = null; // Reset end date when start date changes
      });
    }
  }

  // Function to select end rental date
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

  // Function to handle renting the lot
  Future<void> _rentLot() async {
    if (selectedStartDate == null || selectedEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select both start and end dates.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final activeRental =
          await _listingService.checkActiveLotRental(widget.profileId);

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

      String formattedStartDate =
          DateFormat('yyyy-MM-dd').format(selectedStartDate!);
      String formattedEndDate =
          DateFormat('yyyy-MM-dd').format(selectedEndDate!);

      final duration =
          selectedEndDate!.difference(selectedStartDate!).inDays + 1;
      final totalPrice = (widget.lotData['LRentalPrice'] ?? 0.0) * duration;

      Map<String, dynamic> listingData = {
        "profile_id": widget.profileId,
        "lot_no": widget.lotData['Lot_No'],
        "start_date": formattedStartDate,
        "end_date": formattedEndDate,
      };

      final response = await _listingService.addReservation(listingData);

      if (response['success'] != true || response['reservation_no'] == null) {
        throw Exception(
            'Failed to create reservation. Invalid response: $response');
      }

      final reservationNo = response['reservation_no'] as int;

      final reservationDetails =
          await _listingService.fetchReservationDetails(reservationNo);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AgreementTransactionPage(
            itemName: widget.lotData['LAddress'],
            sellerName: "RevRental Admin",
            rentalPeriod: '$formattedStartDate to $formattedEndDate',
            onActionCompleted: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Transaction completed successfully.')),
              );
            },
            agreementId: reservationNo,
          ),
        ),
      );
    } catch (e) {
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
            Center(
              child: Image.asset(
                'lib/images/lots/storage_units.png',
                fit: BoxFit.cover,
                height: 300,
                width: 300,
              ),
            ),
            const SizedBox(height: 20),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _rentLot,
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
