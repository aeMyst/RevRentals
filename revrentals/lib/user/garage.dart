import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/pages/auth_page.dart';
import 'package:revrentals/user/notifications.dart';
import 'package:revrentals/user/profile_detail.dart';

class MotorcycleCard extends StatelessWidget {
  final String model;
  final double rentalPrice;
  final String imagePath;

  const MotorcycleCard({
    Key? key,
    required this.model,
    required this.rentalPrice,
    required this.imagePath,
  }) : super(key: key);

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
  const GaragePage({Key? key}) : super(key: key);

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
          backgroundColor: Colors.blueGrey,
          leading: IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsPage()),
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
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Listed'),
              Tab(text: 'Rented'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  children: [
                    ListedMotorcyclesTab(), // Listed tab
                    RentedMotorcyclesTab(),  // Rented tab
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
class ListedMotorcyclesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
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

// Widget to display rented motorcycles
class RentedMotorcyclesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
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
