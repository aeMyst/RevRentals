import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'package:revrentals/user/garage/add_listing.dart';
import 'package:revrentals/user/notifications/notifications.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:revrentals/services/listing_service.dart';

class GaragePage extends StatefulWidget {
  final int profileId; // Accept profileId as a parameter
  final Map<String, dynamic>? userData;

  const GaragePage({super.key, required this.profileId, this.userData});

  @override
  State<GaragePage> createState() => _GaragePageState();
}

class _GaragePageState extends State<GaragePage> {
  final ListingService _listingService = ListingService();
  late Future<int> _garageIdFuture; // Future to fetch garage ID
  late Future<Map<String, dynamic>>
      _garageItemsFuture; // Future for fetching garage items

  @override
  void initState() {
    super.initState();
    _garageIdFuture = _fetchGarageId();
  }

  Future<int> _fetchGarageId() async {
    try {
      final garageId = await _listingService.fetchGarageId(widget.profileId);
      _garageItemsFuture = _fetchGarageItems(garageId);
      return garageId;
    } catch (e) {
      throw Exception("Error fetching garage ID: $e");
    }
  }

  Future<Map<String, dynamic>> _fetchGarageItems(int garageId) {
    return _listingService.viewGarageItems(garageId);
  }

  void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _garageIdFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData) {
          final garageId = snapshot.data!;
          return DefaultTabController(
            length: 2, // Number of tabs (Listed & Rented)
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationsPage()),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () => signUserOut(context),
                    icon: const Icon(Icons.logout, color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person, color: Colors.white),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DisplayProfileDetailsPage(
                            userData: widget.userData,
                          )),
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: const TabBar(
                      indicatorPadding: EdgeInsets.only(bottom: 8),
                      indicatorColor: Colors.blueGrey,
                      indicatorWeight: 4,
                      tabs: [
                        Tab(text: 'Listed'),
                        Tab(text: 'Rented'),
                      ],
                      labelColor: Colors.blueGrey,
                      unselectedLabelColor: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ListedTab(
                          garageItemsFuture: _garageItemsFuture,
                          profileId: widget.profileId, // Pass profileId here
                        ),
                        const RentedTab(), // No changes needed
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text("Garage not found."));
        }
      },
    );
  }
}

class ListedTab extends StatefulWidget {
  final Future<Map<String, dynamic>> garageItemsFuture;
  final int profileId; // Accept profileId

  const ListedTab(
      {super.key, required this.garageItemsFuture, required this.profileId});

  @override
  _ListedTabState createState() => _ListedTabState();
}

class _ListedTabState extends State<ListedTab> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<Map<String, dynamic>>(
          future: widget.garageItemsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              final motorizedVehicles = data['motorized_vehicles'] as List;
              final gearItems = data['gear'] as List;

              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Text(
                    "Motorized Vehicles",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...motorizedVehicles.map((vehicle) => ListTile(
                        title: Text(vehicle['Model']),
                        subtitle:
                            Text("Rental Price: \$${vehicle['Rental_Price']}"),
                        trailing: const Icon(Icons.motorcycle),
                      )),
                  const SizedBox(height: 20),
                  const Text(
                    "Gear Items",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...gearItems.map((gear) => ListTile(
                        title: Text(gear['Gear_Name']),
                        subtitle:
                            Text("Rental Price: \$${gear['Rental_Price']}"),
                        trailing: const Icon(Icons.checkroom),
                      )),
                ],
              );
            } else {
              return const Center(child: Text("No items in your garage."));
            }
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddListingPage(profileId: widget.profileId),
                ),
              );
            },
            backgroundColor: Colors.blueGrey,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class RentedTab extends StatelessWidget {
  const RentedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: const [
          ListTile(
            title: Text('Kawasaki Ninja ZX-4R'),
            subtitle: Text('Rental Price: \$150'),
            trailing: Icon(Icons.motorcycle),
          ),
        ],
      ),
    );
  }
}
