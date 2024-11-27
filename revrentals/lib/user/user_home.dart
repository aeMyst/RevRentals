
import 'package:flutter/material.dart';
import 'package:revrentals/user/garage/garage.dart';
import 'package:revrentals/user/marketplace/marketplace.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.sports_motorsports),
          //   label: 'Gear',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warehouse),
            label: 'Garage',
          ),
        ],
      ),
    );
  }
}

