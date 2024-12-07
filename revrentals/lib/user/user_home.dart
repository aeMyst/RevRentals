import 'package:flutter/material.dart';
import 'package:revrentals/services/listing_service.dart';
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
  int? profileId;
  bool isLoading = true; // State to track if data is loading

  @override
  void initState() {
    super.initState();
    fetchProfileId(); // Fetch profile ID on init
  }

  Future<void> fetchProfileId() async {
    try {
      final id = widget.userData?['profile_id'];
      if (id != null) {
        setState(() {
          profileId = id;
          isLoading = false; // Stop loading once profileId is fetched
        });
      } else {
        setState(() {
          isLoading = false; // Stop loading if profileId is null
        });
      }
    } catch (e) {
      print("Error fetching profile ID: $e");
      setState(() {
        isLoading = false; // Stop loading in case of an error
      });
    }
  }

  List<Widget> get _pages {
    return [
      if (profileId != null)
        MarketplacePage(
          profileId: profileId!,
          userData: widget.userData, // Add this
        ),
      if (profileId != null)
        GaragePage(
          profileId: profileId!,
          userData: widget.userData, // Add this
        ),
        
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.userData != null
              ? 'Welcome, ${widget.userData!['username']}'
              : 'Welcome to RevRentals',
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _pages[_currentIndex], // Dynamically load the correct page
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
