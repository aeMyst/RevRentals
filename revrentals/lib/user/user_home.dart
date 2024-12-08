import 'package:flutter/material.dart';
import 'package:revrentals/services/listing_service.dart';
import 'package:revrentals/user/garage/garage.dart';
import 'package:revrentals/user/marketplace/marketplace.dart';
import 'package:revrentals/services/auth_service.dart';

class UserHomePage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const UserHomePage({Key? key, this.userData}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();
  int? profileId;
  bool isLoading = true;
  Map<String, dynamic>? currentUserData;

  @override
  void initState() {
    super.initState();
    currentUserData = widget.userData;
    _fetchProfileIdAndData();
  }

  Future<void> _fetchProfileIdAndData() async {
    try {
      final id = widget.userData?['profile_id'];
      if (id != null) {
        setState(() {
          profileId = id;
        });
        await _refreshUserData(); // Fetch the latest user data
      }
    } catch (e) {
      print("Error fetching profile ID and data: $e");
    } finally {
      setState(() {
        isLoading = false; // Stop loading spinner
      });
    }
  }

  Future<void> _refreshUserData([Map<String, dynamic>? updatedData]) async {
    if (updatedData != null) {
      // If updated data is provided, update the state directly
      setState(() {
        currentUserData = updatedData;
      });
    } else if (profileId != null) {
      // Otherwise, fetch the latest data from the server
      try {
        final response = await _authService.fetchProfileDetails(profileId!);
        if (response['success']) {
          setState(() {
            currentUserData = response['user'];
          });
        }
      } catch (e) {
        print("Error refreshing user data: $e");
      }
    }
  }

  List<Widget> get _pages {
    return [
      if (profileId != null)
        MarketplacePage(
          profileId: profileId!,
          userData: currentUserData,
        ),
      if (profileId != null)
        GaragePage(
          profileId: profileId!,
          userData: currentUserData,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(
          currentUserData != null
              ? 'Welcome, ${currentUserData!['first_name']} ${currentUserData!['last_name']}'
              : 'Welcome to RevRentals',
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : WillPopScope(
              // Ensure data refresh when returning from a page
              onWillPop: () async {
                await _refreshUserData();
                return true;
              },
              child: _pages[_currentIndex],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) async {
          if (index != _currentIndex) {
            // Ensure user data is refreshed before switching tabs
            await _refreshUserData();
          }
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
