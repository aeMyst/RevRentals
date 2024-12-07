import 'package:flutter/material.dart';
import 'package:revrentals/services/listing_service.dart';

class AgreementTransactionPage extends StatefulWidget {
  final String itemName;
  final String renterName;
  final String rentalPeriod;
  final double rentalPrice;
  final double totalPrice;
  final VoidCallback onActionCompleted;
  final int agreementId;

  const AgreementTransactionPage({
    super.key,
    required this.itemName,
    required this.renterName,
    required this.rentalPeriod,
    required this.rentalPrice,
    required this.totalPrice,
    required this.onActionCompleted,
    required this.agreementId
  });

  @override
  _AgreementTransactionPageState createState() => _AgreementTransactionPageState();
}

class _AgreementTransactionPageState extends State<AgreementTransactionPage> {
  final ListingService _listingService = ListingService();
  final List<String> paymentMethods = ['Credit Card', 'Debit Card', 'PayPal', 'E-Transfer'];
  String? selectedPaymentMethod;
  bool isProcessing = false;

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
        "agreement_id": widget.agreementId,     // agreementID is the same as reservationID
        "payment_method": selectedPaymentMethod,
      });
      print(widget.agreementId);    // testing purposes
      widget.onActionCompleted();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment successful via $selectedPaymentMethod")),
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

  @override
  Widget build(BuildContext context) {
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
              "Rented By: ${widget.renterName}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Rental Period: ${widget.rentalPeriod}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Rental Price: \$${widget.rentalPrice.toStringAsFixed(2)} per day",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Total Price: \$${widget.totalPrice.toStringAsFixed(2)}",
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
              items: paymentMethods.map<DropdownMenuItem<String>>((String value) {
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