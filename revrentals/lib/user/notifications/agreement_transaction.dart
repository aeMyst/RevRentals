import 'package:flutter/material.dart';
import 'package:revrentals/services/listing_service.dart';

class AgreementTransactionPage extends StatefulWidget {
  final String itemName;
  final String sellerName;
  final String rentalPeriod;
  final VoidCallback onActionCompleted;
  final int agreementId;

  const AgreementTransactionPage({
    super.key,
    required this.itemName,
    required this.sellerName,
    required this.rentalPeriod,
    required this.onActionCompleted,
    required this.agreementId,
  });

  @override
  _AgreementTransactionPageState createState() =>
      _AgreementTransactionPageState();
}

class _AgreementTransactionPageState extends State<AgreementTransactionPage> {
  final ListingService _listingService = ListingService();
  final List<String> paymentMethods = [
    'Credit Card',
    'Debit Card',
    'PayPal',
    'E-Transfer'
  ];
  String? selectedPaymentMethod;
  bool isProcessing = false;
  bool isLoading = true; // For loading state
  String? errorMessage; // To display error if any
  Map<String, dynamic>? reservationDetails; // Store fetched reservation details

  @override
  void initState() {
    super.initState();
    _loadReservationDetails();
  }

  Future<void> _loadReservationDetails() async {
    try {
      final details =
          await _listingService.fetchReservationDetails(widget.agreementId);
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

  Future<void> _processPayment() async {
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a payment method")),
      );
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {
      await _listingService.addTransaction({
        "agreement_id": widget.agreementId,
        "payment_method": selectedPaymentMethod,
      });
      widget.onActionCompleted();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Payment successful via $selectedPaymentMethod")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: $e")),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  Future<void> _cleanupReservation() async {
    try {
      await _listingService.deleteReservation(widget.agreementId);
      print(
          "Unpaid reservation cleaned up for agreement ID ${widget.agreementId}");
    } catch (e) {
      print("Error during cleanup: $e");
    }
  }

  @override
  void dispose() {
    if (!isProcessing && selectedPaymentMethod == null) {
      _cleanupReservation();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(errorMessage!),
        ),
      );
    }

    final rentalPrice = reservationDetails?['rental_price'] ?? 0.0;
    final totalPrice = reservationDetails?['total_price'] ?? 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Rental Agreement & Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Rental Agreement",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Item: ${widget.itemName}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Sold By: ${widget.sellerName}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Rental Period: ${widget.rentalPeriod}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Rental Price: \$${rentalPrice.toStringAsFixed(2)} per day",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Total Price: \$${totalPrice.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text(
              "Payment Details",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              dropdownColor: Colors.white,
              decoration: const InputDecoration(
                labelText: "Select a Payment Method",
              ),
              value: selectedPaymentMethod,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPaymentMethod = newValue;
                });
              },
              items:
                  paymentMethods.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  disabledBackgroundColor: Colors.grey,
                ),
                child: Text(isProcessing ? 'Processing...' : 'Confirm Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
