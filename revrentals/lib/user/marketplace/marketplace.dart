import 'package:flutter/material.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'package:revrentals/user/item_details/gear/gear_details.dart';
import 'package:revrentals/user/item_details/lot/lot_details.dart';
import 'package:revrentals/user/item_details/motorcycle/motorcycle_details.dart';
import 'package:revrentals/user/notifications/notifications.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:revrentals/services/listing_service.dart'; // Import ListingService

class MarketplacePage extends StatefulWidget {
  final int garageId;

  const MarketplacePage({super.key, required this.garageId});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final ListingService _listingService =
      ListingService(); // Initialize ListingService
  late Future<List<dynamic>>
      _motorcyclesFuture; // Future for fetching motorcycles

  @override
  void initState() {
    super.initState();
    _motorcyclesFuture =
        _fetchMotorcycles(); // Fetch motorcycles on initialization
  }

  Future<List<dynamic>> _fetchMotorcycles() async {
    try {
      return await _listingService.fetchMotorizedVehicles();
    } catch (e) {
      print("Error fetching motorcycles: $e");
      return [];
    }
  }

  void signUserOut(BuildContext context) {
    // FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationsPage()),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => signUserOut(context),
              icon: const Icon(Icons.logout),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DisplayProfileDetailsPage()),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TabBar(
                labelColor: Colors.blueGrey,
                indicatorColor: Colors.blueGrey,
                indicatorPadding: EdgeInsets.only(bottom: 8),
                tabs: [
                  Tab(text: 'Motorcycles'),
                  Tab(text: 'Gear'),
                  Tab(text: 'Storage Lots'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    MotorcycleTab(motorcyclesFuture: _motorcyclesFuture),
                    const GearTab(),
                    const LotTab(),
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

// MotorcycleTab updated to display fetched motorcycles
class MotorcycleTab extends StatelessWidget {
  final Future<List<dynamic>> motorcyclesFuture;

  const MotorcycleTab({super.key, required this.motorcyclesFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: motorcyclesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final motorcycles = snapshot.data!;
          return ListView.builder(
            itemCount: motorcycles.length,
            itemBuilder: (context, index) {
              final motorcycle = motorcycles[index];
              return ListTile(
                title: Text(motorcycle['Model']),
                subtitle: Text("Rental Price: \$${motorcycle['Rental_Price']}"),
                trailing: const Icon(Icons.motorcycle),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MotorcycleDetailPage(
                        motorcycleData: motorcycle,
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return const Center(child: Text("No motorcycles found."));
        }
      },
    );
  }
}

// GearTab (unchanged)
class GearTab extends StatelessWidget {
  const GearTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Gear items will be displayed here."));
  }
}

// LotTab (unchanged)
class LotTab extends StatelessWidget {
  const LotTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Storage lots will be displayed here."));
  }
}
