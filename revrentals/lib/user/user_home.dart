import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // Sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Find your favorite motorcycle!'),
          actions: [
            IconButton(onPressed: signUserOut, icon: Icon(Icons.logout)),
            IconButton(icon: Icon(Icons.person), onPressed: () {}),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LOGGED INTO HOME PAGE AS: ${user.email!}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 8),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Find motorcycle, etc',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Tab Bar
              TabBar(
                tabs: [
                  Tab(text: 'Favorite'),
                  Tab(text: 'Recommended'),
                  Tab(text: 'Nearby'),
                  Tab(text: 'Best Models'),
                ],
              ),
              SizedBox(height: 16),

              // Tab Bar View
              Expanded(
                child: TabBarView(
                  children: [
                    MotorcycleTab(), // Reuse this widget for each tab
                    MotorcycleTab(),
                    MotorcycleTab(),
                    MotorcycleTab(),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Gear Section
              Text('Gear', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              GearCard(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

// Widget to display motorcycles in each tab
class MotorcycleTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        MotorcycleCard(imagePath: 'assets/green_scooter.png', isFavorite: true),
        MotorcycleCard(imagePath: 'assets/blue_scooter.png', isFavorite: false),
      ],
    );
  }
}

class MotorcycleCard extends StatelessWidget {
  final String imagePath;
  final bool isFavorite;

  MotorcycleCard({required this.imagePath, this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 16),
      child: Stack(
        children: [
          Card(
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
          if (isFavorite)
            Positioned(
              top: 8,
              right: 8,
              child: Icon(Icons.favorite, color: Colors.red),
            ),
        ],
      ),
    );
  }
}

// Gear Card Widget
class GearCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset('assets/helmet.png'), // Use an asset for helmet image
        title: Text('Black and white helmet MT'),
        subtitle: Text('Price\n\$67.87'),
        trailing: ElevatedButton(
          onPressed: () {},
          child: Text('Buy now'),
        ),
      ),
    );
  }
}
