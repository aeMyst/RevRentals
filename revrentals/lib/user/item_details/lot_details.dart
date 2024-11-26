
import 'package:flutter/material.dart';

class LotDetailsPage extends StatelessWidget {
  final String lotAddress;
  final String description;
  final double rentalPrice;
  final String imagePath;

  const LotDetailsPage({
    required this.lotAddress,
    required this.description,
    required this.rentalPrice,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(lotAddress),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lot image
            Center(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            // Lot address
            Text(
              lotAddress,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            // Description
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Rental Price
            Text(
              'Per Day: \$${rentalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to MarketplacePage under Lots tab
                Navigator.pop(context);
              },
              child: const Text('Back to Lots'),
              style: ElevatedButton.styleFrom(iconColor: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}
