import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/user/favourites_garage.dart';
import 'package:revrentals/user/gear.dart';
import 'package:revrentals/user/marketplace.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:revrentals/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/user/gear.dart';
import 'package:revrentals/user/favourites_garage.dart';
import 'package:revrentals/user/marketplace.dart'; // Import the new MarketplacePage

class UserHomePage extends StatefulWidget {
  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MarketplacePage(), // Use the new MarketplacePage
    GearPage(),
    FavouritesPage(),
    GaragePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        backgroundColor: Colors.blueGrey,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.two_wheeler),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_motorsports),
            label: 'Gear',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warehouse),
            label: 'Garage',
          ),
        ],
      ),
    );
  }
}


// class UserHomePage extends StatefulWidget {
//   UserHomePage({super.key});

//   @override
//   State<UserHomePage> createState() => _UserHomePageState();
// }

// class _UserHomePageState extends State<UserHomePage> {
//   final user = FirebaseAuth.instance.currentUser!;
//   int _currentIndex = 0; // Keeps track of the currently selected item

//   final List<Widget> _pages = [
//     MarketplacePage(), // Replace UserHomePage with MarketplacePage
//     GearPage(),
//     FavouritesPage(),
//     GaragePage(),
//   ];

//   void signUserOut() {
//     FirebaseAuth.instance.signOut();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.blueGrey,
//         actions: [
//           IconButton(
//             onPressed: ButtonUtils.signUserOut,
//             icon: Icon(Icons.logout, color: Colors.white),
//           ),
//           IconButton(
//             icon: Icon(Icons.person, color: Colors.white),
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DisplayProfileDetailsPage(),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: _pages[_currentIndex], // Display the selected page based on _currentIndex
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _currentIndex, // Set the current index
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.grey[400],
//         backgroundColor: Colors.blueGrey,
//         onTap: (int index) {
//           setState(() {
//             _currentIndex = index; // Update the selected index
//           });
//         },
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.two_wheeler),
//             label: 'Marketplace',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.sports_motorsports),
//             label: 'Gear',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: 'Favorites',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.warehouse),
//             label: 'Garage',
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Widget to display motorcycles in each tab
// class MotorcycleTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       scrollDirection: Axis.vertical,
//       children: [
//         MotorcycleCard(
//           imagePath: 'lib/images/ninja_zx4r.png',
//           isFavorite: true,
//           model: 'Kawasaki Ninja ZX-4R',
//           rentalPrice: 0,
//         ),
//         MotorcycleCard(
//           imagePath: 'lib/images/scooter.png',
//           isFavorite: false,
//           model: 'Scooter',
//           rentalPrice: 0,
//         ),
//         MotorcycleCard(
//           imagePath: 'lib/images/dirtbike.png',
//           isFavorite: false,
//           model: 'Honda CRF250R',
//           rentalPrice: 0,
//         ),
//       ],
//     );
//   }
// }

// class MotorcycleCard extends StatelessWidget {
//   final String model;
//   final double rentalPrice;
//   final String imagePath;
//   final bool isFavorite;

//   MotorcycleCard({
//     required this.model,
//     required this.rentalPrice,
//     required this.imagePath,
//     required this.isFavorite,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 200,
//       margin: EdgeInsets.only(right: 16),
//       child: Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Motorcycle image
//               Center(
//                 child: Image.asset(
//                   imagePath,
//                   fit: BoxFit.cover,
//                   height: 100,
//                 ),
//               ),
//               // if (isFavorite)
//               //   Positioned(
//               //     top: 8,
//               //     right: 8,
//               //     child: Icon(Icons.favorite, color: Colors.red),
//               //   ),
//               SizedBox(height: 10),
//               // Model name
//               Text(
//                 model,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               SizedBox(height: 5),
//               // Rental price per hour
//               Text(
//                 'Per Hour: \$${rentalPrice.toStringAsFixed(2)}',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: 10),

//               // Rent button
//               // Center(
//               //   child: ElevatedButton(
//               //     onPressed: () {
//               //       // Add action for rent button
//               //     },
//               //     child: Text('Rent Bike'),
//               //     style: ElevatedButton.styleFrom(
//               //       backgroundColor: Colors.black,
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// class MotorcycleCard extends StatelessWidget {
//   final String imagePath;
//   final bool isFavorite;

//   MotorcycleCard({required this.imagePath, this.isFavorite = false});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 150,
//       margin: EdgeInsets.only(right: 16),
//       child: Stack(
//         children: [
//           Card(
//               child: Image.asset(imagePath, fit: BoxFit.cover),
//               ),
//           if (isFavorite)
//             Positioned(
//               top: 8,
//               right: 8,
//               child: Icon(Icons.favorite, color: Colors.red),
//             ),
//         ],
//       ),
//     );
//   }
// }
