import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/admin/admin_login.dart';
import 'package:revrentals/admin/admin_agreement.dart';
import 'package:revrentals/admin/admin_lot.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'package:revrentals/services/listing_service.dart'; // Import ListingService

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final ListingService _listingService =
      ListingService(); // Initialize ListingService
  late Future<List<dynamic>> _storageLotsFuture;

  @override
  void initState() {
    super.initState();
    _storageLotsFuture =
        _listingService.fetchStorageLots(); // Fetch storage lots
  }

  // Sign user out method
  void signUserOut(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Prevent back button
        title: const Text(
          "Admin Home",
        ),
        actions: [
          IconButton(
            onPressed: () => signUserOut(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMenuButton(Icons.apartment, "Lots", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminLotPage(storageLotsFuture: _storageLotsFuture)));
                    // Navigate to Lots screen
                  }),
                  const SizedBox(width: 24),
                  _buildMenuButton(Icons.file_copy, "Reservations", () {
                    // Navigate to Agreements screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminAgreementPage()),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   color: Colors.grey[300],
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 8.0),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Icon(Icons.home, color: Colors.black),
      //         SizedBox(width: 8),
      //         Text("Home", style: TextStyle(color: Colors.black)),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  // Helper method to create menu buttons
  Widget _buildMenuButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 4,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
