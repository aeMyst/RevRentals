import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'package:revrentals/user/add_listing.dart';
import 'package:revrentals/user/notifications/notifications.dart';
import 'package:revrentals/user/profile_detail.dart';

class MotorcycleCard extends StatelessWidget {
  final String model;
  final double rentalPrice;
  final String imagePath;

  const MotorcycleCard({
    super.key,
    required this.model,
    required this.rentalPrice,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  height: 100,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                model,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Per Hour: \$${rentalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GaragePage extends StatelessWidget {
  const GaragePage({super.key});

  void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs (Listed & Rented)
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationsPage()),
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
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorPadding: EdgeInsets.only(bottom: 8),
            tabs: [
              Tab(text: 'Listed'),
              Tab(text: 'Rented'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  children: [
                    ListedTab(), // Listed tab
                    RentedTab(), // Rented tab
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget to display listed motorcycles
class ListedTab extends StatelessWidget {
  const ListedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ListView(
        //   scrollDirection: Axis.vertical,
        //   children: [
        //     MotorcycleCard(
        //       imagePath: 'lib/images/ninja_zx4r.png',
        //       model: 'Kawasaki Ninja ZX-4R',
        //       rentalPrice: 0,
        //     ),
        //     MotorcycleCard(
        //       imagePath: 'lib/images/moped.jpg',
        //       model: 'Velocifero TENNIS 4000W',
        //       rentalPrice: 0,
        //     ),
        //     MotorcycleCard(
        //       imagePath: 'lib/images/dirtbike.png',
        //       model: 'Honda CRF250R',
        //       rentalPrice: 0,
        //     ),
        //   ],
        // ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              // Navigate to add listing page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddListingPage(),
                ),
              );
            },
            backgroundColor: Colors.blueGrey,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// Widget to display rented motorcycles
class RentedTab extends StatelessWidget {
  const RentedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: const [
        // MotorcycleCard(
        //   imagePath: 'lib/images/ninja_zx4r.png',
        //   model: 'Kawasaki Ninja ZX-4R',
        //   rentalPrice: 0,
        // ),
        // MotorcycleCard(
        //   imagePath: 'lib/images/moped.jpg',
        //   model: 'Velocifero TENNIS 4000W',
        //   rentalPrice: 0,
        // ),
        // MotorcycleCard(
        //   imagePath: 'lib/images/dirtbike.png',
        //   model: 'Honda CRF250R',
        //   rentalPrice: 0,
        // ),
      ],
    );
  }
}
