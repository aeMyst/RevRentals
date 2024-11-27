import 'package:flutter/material.dart';
import 'package:revrentals/user/garage/garage.dart';
import 'package:revrentals/user/marketplace/marketplace.dart';

class UserHomePage extends StatefulWidget {
  final Map<String, dynamic>? userData; // Optional user data

  const UserHomePage({Key? key, this.userData}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MarketplacePage(),
    const GaragePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.userData != null
              ? 'Welcome, ${widget.userData!['first_name']}'
              : 'Welcome to RevRentals',
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.garage),
            label: 'Garage',
          ),
        ],
      ),
    );
  }
}
