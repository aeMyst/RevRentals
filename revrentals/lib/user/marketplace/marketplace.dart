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
  late Future<List<dynamic>> _motorcyclesFuture;
  late Future<List<dynamic>> _gearFuture;
  late Future<List<dynamic>> _storageLotsFuture;

  @override
  void initState() {
    super.initState();
    _motorcyclesFuture = _listingService.fetchMotorizedVehicles();
    _gearFuture = _listingService.fetchGearItems(); // Fetch gear items
    _storageLotsFuture = _listingService.fetchStorageLots(); // Fetch storage lots
  }

  void signUserOut(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.push(
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
                    GearTab(gearFuture: _gearFuture), // Pass gearFuture
                    LotTab(
                        storageLotsFuture:
                            _storageLotsFuture), // Pass storageLotsFuture
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

// MotorcycleTab remains the same
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

// GearTab updated to fetch and display gear items
class GearTab extends StatelessWidget {
  final Future<List<dynamic>> gearFuture;

  const GearTab({super.key, required this.gearFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: gearFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final gearItems = snapshot.data!;
          return ListView.builder(
            itemCount: gearItems.length,
            itemBuilder: (context, index) {
              final gear = gearItems[index];
              return ListTile(
                title: Text(gear['Gear_Name'] ?? "Unknown Gear"),
                subtitle: Text("Rental Price: \$${gear['GRentalPrice']}"),
                trailing: const Icon(Icons.settings),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GearDetailPage(
                        gearData: gear,
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return const Center(child: Text("No gear items found."));
        }
      },
    );
  }
}

// LotTab updated to fetch and display storage lots
class LotTab extends StatelessWidget {
  final Future<List<dynamic>> storageLotsFuture;

  const LotTab({super.key, required this.storageLotsFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: storageLotsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final storageLots = snapshot.data!;
          return ListView.builder(
            itemCount: storageLots.length,
            itemBuilder: (context, index) {
              final lot = storageLots[index];
              return ListTile(
                title: Text("Lot No: ${lot['Lot_No']}"),
                subtitle: Text("Address: ${lot['LAddress']}"),
                trailing: const Icon(Icons.warehouse),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LotDetailsPage(
                        lotData: lot,
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return const Center(child: Text("No storage lots found."));
        }
      },
    );
  }
}
