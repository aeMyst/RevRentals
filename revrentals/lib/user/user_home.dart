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

  final ListingService _listingService = ListingService();
  int? garageId;
  bool isLoading = true; // State to track if data is loading

  @override
  void initState() {
    super.initState();
    fetchGarageId(); // Fetch garage ID on init
  }

  Future<void> fetchGarageId() async {
    if (widget.userData == null || widget.userData?['profile_id'] == null) {
      // Handle the case where userData or profile_id is missing
      print("Error: userData or profile_id is null");
      setState(() {
        isLoading = false; // Stop loading in this case
      });
      return;
    }

    try {
      final profileId = widget.userData!['profile_id'];
      print("Fetching garage ID for profile ID: $profileId");
      final id = await _listingService.fetchGarageId(profileId);
      setState(() {
        garageId = id;
        isLoading = false; // Stop loading once garageId is fetched
      });
    } catch (e) {
      print("Error fetching garage ID: $e");
      setState(() {
        isLoading = false; // Stop loading in case of an error
      });
    }
  }

  List<Widget> get _pages {
    if (garageId == null) {
      // Show placeholder widgets while garageId is being fetched
      return const [
        Center(
            child: CircularProgressIndicator()), // Placeholder for Marketplace
        Center(child: CircularProgressIndicator()), // Placeholder for Garage
      ];
    } else {
      return [
        MarketplacePage(garageId: garageId!), // Pass the fetched garageId
        GaragePage(garageId: garageId!), // Pass the fetched garageId
      ];
    }
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
