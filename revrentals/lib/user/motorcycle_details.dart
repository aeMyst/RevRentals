import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/pages/auth_page.dart';
import 'package:revrentals/user/marketplace.dart';
import 'package:revrentals/user/profile_detail.dart';

// class MotorcycleDetails extends StatelessWidget {
//   final String model;
//   final double rentalPrice;
//   final String imagePath;

//   const MotorcycleDetails({
//     Key? key,
//     required this.model,
//     required this.rentalPrice,
//     required this.imagePath,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: Card(
//         color: Colors.white,
//         elevation: 3,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Image.asset(
//                   imagePath,
//                   fit: BoxFit.cover,
//                   height: 100,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 model,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 'Per Hour: \$${rentalPrice.toStringAsFixed(2)}',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class MotorcycleDetailPage extends StatelessWidget {
  final String model;         // Declare these variables to hold the passed data
  final double rentalPrice;
  final String imagePath;

  const MotorcycleDetailPage({
    Key? key,
    required this.model,
    required this.rentalPrice,
    required this.imagePath,
  }) : super(key: key);

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
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MarketplacePage()),
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
                builder: (context) => DisplayProfileDetailsPage()),
          ),
        ),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Motorcycle image
          Center(
              child: Image.asset(
                imagePath,  // Dynamically load image
                fit: BoxFit.contain,
                height: 300,
                width: 300,
              ),
            ),
          const SizedBox(height: 20),
          
          // Motorcycle title (model)
          Center(
            child: Text(
              model,  // Display model dynamically
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 10),
          
          // Motorcycle price
          Center(
            child: Text(
              'Rental Price: \$${rentalPrice.toStringAsFixed(2)} per day',  // Display model dynamically
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );
  }
}