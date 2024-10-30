import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:revrentals/utils/utils.dart';

class UserHomePage extends StatefulWidget {
  UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  int _currentIndex = 0; 
 // Keeps track of the currently selected item
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          actions: [
            IconButton(
              onPressed: ButtonUtils.signUserOut,
              icon: Icon(Icons.logout, color: Colors.white),
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DisplayProfileDetailsPage()),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
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
              TabBar(
                tabs: [
                  Tab(text: 'Favorite'),
                  Tab(text: 'Recommended'),
                  Tab(text: 'Nearby'),
                  Tab(text: 'Best Models'),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  children: [
                    MotorcycleTab(),
                    MotorcycleTab(),
                    MotorcycleTab(),
                    MotorcycleTab(),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text('Gear',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              GearCard(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex, // Set the current index
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[400],
          backgroundColor: Colors.blueGrey,
          onTap: (int index) {
            setState(() {
              _currentIndex = index; // Update the selected index
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4, // Number of tabs
//       child: Scaffold(
//         // Set main background color for the entire page
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.blueGrey,
//           actions: [
//             IconButton(
//                 onPressed: ButtonUtils.signUserOut,
//                 icon: Icon(Icons.logout, color: Colors.white)),
//             IconButton(
//                 icon: Icon(Icons.person, color: Colors.white),
//                 onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => DisplayProfileDetailsPage()))),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 8),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 8),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Find motorcycle, etc',
//                     border: InputBorder.none,
//                     icon: Icon(Icons.search),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               TabBar(
//                 tabs: [
//                   Tab(text: 'Favorite'),
//                   Tab(text: 'Recommended'),
//                   Tab(text: 'Nearby'),
//                   Tab(text: 'Best Models'),
//                 ],
//               ),
//               SizedBox(height: 16),
//               Expanded(
//                 child: TabBarView(
//                   children: [
//                     MotorcycleTab(),
//                     MotorcycleTab(),
//                     MotorcycleTab(),
//                     MotorcycleTab(),
//                   ],
//                 ),
//               ),
//               // SizedBox(height: 16),
//               // Text('Gear',
//               //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               // SizedBox(height: 8),
//               // GearCard(),
//             ],
//           ),
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed, // Ensures consistent background
//           selectedItemColor: Colors.white, // Adjusted for contrast
//           unselectedItemColor: Colors.grey[400],
//           backgroundColor: Colors.blueGrey,
//           items: const <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.favorite),
//               label: 'Favorites',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.notifications),
//               label: 'Notifications',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.settings),
//               label: 'Settings',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget to display motorcycles in each tab
class MotorcycleTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        // MotorcycleCard(imagePath: 'assets/green_scooter.png', isFavorite: true),
        // MotorcycleCard(imagePath: 'assets/blue_scooter.png', isFavorite: false),
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
              // child: Image.asset(imagePath, fit: BoxFit.cover),
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
        // leading: Image.asset('assets/helmet.png'), // Use an asset for helmet image
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
