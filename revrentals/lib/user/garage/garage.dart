import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'package:revrentals/user/garage/add_listing.dart';
import 'package:revrentals/user/item_details/motorcycle/motorcycle.dart';
import 'package:revrentals/user/notifications/notifications.dart';
import 'package:revrentals/user/profile_detail.dart';

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
        ),
        body: Column(
          children: [
            // TabBar with its own styling
            Container(
              color: Colors.white, // Background color for TabBar
              child: const TabBar(
                indicatorPadding: EdgeInsets.only(bottom: 8),
                indicatorColor: Colors.blueGrey,
                indicatorWeight: 4,
                tabs: [
                  Tab(text: 'Listed'),
                  Tab(text: 'Rented'),
                ],
                labelColor: Colors.blueGrey,
                unselectedLabelColor: Colors.grey,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListedTab(), // Listed tab
                  RentedTab(),  // Rented tab
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget to display listed items
class ListedTab extends StatelessWidget {
  const ListedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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

// Widget to display rented items
class RentedTab extends StatelessWidget {
  const RentedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: const [
          RentedMotorcycleCard(
            imagePath: 'lib/images/motorcycle/ninja_zx4r.png',
            model: 'Kawasaki Ninja ZX-4R',
            totalRentalPrice: 150,
          ),
        ],
      ),
    );
  }
}

