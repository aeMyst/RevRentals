import 'package:flutter/material.dart';
import 'package:revrentals/services/listing_service.dart';
import 'package:revrentals/user/notifications/agreement_transaction.dart';
import 'package:intl/intl.dart';

class RentalApprovalPage extends StatefulWidget {
  final VoidCallback onActionCompleted;
  final int reservationNo;

  const RentalApprovalPage({
    super.key,
    required this.onActionCompleted,
    required this.reservationNo,
  });

  @override
  State<RentalApprovalPage> createState() => _RentalApprovalPageState();
}

class _RentalApprovalPageState extends State<RentalApprovalPage> {
  final ListingService _listingService = ListingService();
  bool isLoading = true;
  Map<String, dynamic>? reservationDetails;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadReservationDetails();
  }

  Future<void> _loadReservationDetails() async {
    try {
      final details =
          await _listingService.fetchReservationDetails(widget.reservationNo);
      setState(() {
        reservationDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load reservation details: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _approveRental() async {
    setState(() => isLoading = true);

    try {
      final response = await _listingService.addAgreement({
        "reservation_no": widget.reservationNo,
      });

      if (response['success']) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rental request approved')),
        );

        // Navigate to the agreement transaction page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AgreementTransactionPage(
              itemName: response['item_name'],
              renterName:
                  "${reservationDetails?['renter_first_name'] ?? ''} ${reservationDetails?['renter_last_name'] ?? ''}",
              rentalPeriod: response['rental_overview'],
              rentalPrice: response['agreement_fee'].toDouble(),
              totalPrice:
                  (response['agreement_fee'] + response['damage_compensation'])
                      .toDouble(),
              onActionCompleted: widget.onActionCompleted,
              agreementId: widget.reservationNo,
            ),
          ),
        );

        widget.onActionCompleted();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error approving rental: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _rejectRental() async {
    setState(() => isLoading = true);

    try {
      await _listingService.updateReservationStatus(
          widget.reservationNo, "reject");

      // Show rejection confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rental request rejected')),
      );

      widget
          .onActionCompleted(); // Notify parent widget to refresh notifications
      Navigator.pop(context); // Close the rental approval page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error rejecting rental: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Rental Request Approval'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Rental Request Approval'),
        ),
        body: Center(
          child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    // Format dates for display
    final startDate = DateFormat('MMM dd, yyyy')
        .format(DateTime.parse(reservationDetails?['start_date'] ?? ''));
    final endDate = DateFormat('MMM dd, yyyy')
        .format(DateTime.parse(reservationDetails?['end_date'] ?? ''));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Rental Request Approval'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "You have received a rental request for your item.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Details of the rental request:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
                "Requested by: ${reservationDetails?['renter_first_name']} ${reservationDetails?['renter_last_name']}"),
            Text("Item: ${reservationDetails?['item_name']}"),
            const SizedBox(height: 20),
            Text("Rental Period: $startDate to $endDate"),
            const SizedBox(height: 20),
            Text("Rental Price: \$${reservationDetails?['rental_price']}/day"),
            const SizedBox(height: 20),
            Text("Total Payment: \$${reservationDetails?['total_price']}"),
            const SizedBox(height: 40),

            // Centered buttons
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _rejectRental,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Reject"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _approveRental,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Approve"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
