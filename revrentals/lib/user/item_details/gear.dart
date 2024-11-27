// import 'package:flutter/material.dart';

// class GearPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         // title: Text('Gear'),
//         backgroundColor: Colors.blueGrey,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             GearItem(
//               imagePath: 'lib/images/agv_pista.webp',
//               name: 'AGV Pista GP RR',
//               description: '',
//               price: 0,
//             ),
//             GearItem(
//               imagePath: 'lib/images/gloves.png',
//               name: 'Alpinestars Stella SMX-2 Air Carbon V2',
//               description: 'High-quality leather gloves for comfort and protection.',
//               price: 35.50,
//             ),
//             GearItem(
//               imagePath: 'lib/images/jacket.jpg',
//               name: 'Alpinestars GPR Plus Jacket',
//               description: 'Leather jacket with armor protection.',
//               price: 120.99,
//             ),
//             // Add more gear items as needed
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GearItem extends StatelessWidget {
//   final String imagePath;
//   final String name;
//   final String description;
//   final double price;

//   GearItem({
//     required this.imagePath,
//     required this.name,
//     required this.description,
//     required this.price,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 3,
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Gear image
//             Image.asset(
//               imagePath,
//               height: 80,
//               width: 80,
//               fit: BoxFit.cover,
//             ),
//             SizedBox(width: 16),
//             // Gear details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     description,
//                     style: TextStyle(color: Colors.grey[700]),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     '\$${price.toStringAsFixed(2)}',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Buy button
//             // ElevatedButton(
//             //   onPressed: () {
//             //     // Add your buy action here
//             //   },
//             //   style: ElevatedButton.styleFrom(
//             //     backgroundColor: Colors.black,
//             //   ),
//             //   child: Text('Buy Now'),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'package:revrentals/user/notifications/notifications.dart';
import 'package:revrentals/user/profile_detail.dart';

class GearPage extends StatelessWidget {
  const GearPage({super.key});

  void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationsPage()),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => signUserOut(context),
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DisplayProfileDetailsPage()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            GearItem(
              imagePath: 'lib/images/agv_pista.webp',
              name: 'AGV Pista GP RR',
              description: '',
              price: 0,
            ),
            GearItem(
              imagePath: 'lib/images/gloves.png',
              name: 'Alpinestars Stella SMX-2 Air Carbon V2',
              description:
                  'High-quality leather gloves for comfort and protection.',
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

  const GearItem({
    super.key,
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
      margin: const EdgeInsets.symmetric(vertical: 8),
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
            const SizedBox(width: 16),
            // Gear details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
