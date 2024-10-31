import 'package:flutter/material.dart';

class GearPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Gear'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GearItem(
              imagePath: 'lib/images/agv_pista.webp',
              name: 'AGV Pista GP RR',
              description: '',
              price: 0,
            ),
            GearItem(
              imagePath: 'lib/images/gloves.png',
              name: 'Alpinestars Stella SMX-2 Air Carbon V2',
              description: 'High-quality leather gloves for comfort and protection.',
              price: 35.50,
            ),
            GearItem(
              imagePath: 'lib/images/jacket.jpg',
              name: 'Alpinestars GPR Plus Jacket',
              description: 'Leather jacket with armor protection.',
              price: 120.99,
            ),
            // Add more gear items as needed
          ],
        ),
      ),
    );
  }
}

class GearItem extends StatelessWidget {
  final String imagePath;
  final String name;
  final String description;
  final double price;

  GearItem({
    required this.imagePath,
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gear image
            Image.asset(
              imagePath,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 16),
            // Gear details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            // Buy button
            // ElevatedButton(
            //   onPressed: () {
            //     // Add your buy action here
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.black,
            //   ),
            //   child: Text('Buy Now'),
            // ),
          ],
        ),
      ),
    );
  }
}
