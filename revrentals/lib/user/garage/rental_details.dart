import 'package:flutter/material.dart';

class RentalDetailPage extends StatelessWidget {
  final Map<String, dynamic> rentalDetails;

  const RentalDetailPage({super.key, required this.rentalDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rental Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Item Name: ${rentalDetails['item_name']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
                "Rental Period: ${rentalDetails['start_date']} to ${rentalDetails['end_date']}"),
            Text("Status: ${rentalDetails['status']}"),
            const SizedBox(height: 20),
            Text(
                "Transaction Date: ${rentalDetails['transaction_date'] ?? 'N/A'}"),
            Text("Payment Method: ${rentalDetails['payment_method'] ?? 'N/A'}"),
            const SizedBox(height: 20),
            const Text(
              "Agreement Details:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
                "Rental Overview: ${rentalDetails['rental_overview'] ?? 'N/A'}"),
            Text(
                "Damage Compensation: \$${rentalDetails['damage_compensation']?.toStringAsFixed(2) ?? 'N/A'}"),
            Text(
                "Agreement Fee: \$${rentalDetails['agreement_fee']?.toStringAsFixed(2) ?? 'N/A'}"),
          ],
        ),
      ),
    );
  }
}
