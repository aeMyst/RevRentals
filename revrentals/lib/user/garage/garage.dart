import 'package:flutter/material.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'package:revrentals/user/garage/add_listing.dart';
import 'package:revrentals/user/garage/maint_records.dart';
import 'package:revrentals/user/notifications/notifications.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:revrentals/services/listing_service.dart';
import 'package:revrentals/user/garage/rental_details.dart';

final ListingService _listingService = ListingService();

class GaragePage extends StatefulWidget {
  final int profileId; // Accept profileId as a parameter
  final Map<String, dynamic>? userData;
// Add a callback to refresh the data
  // final VoidCallback onPriceUpdated;
  const GaragePage({super.key, required this.profileId, this.userData});

  @override
  State<GaragePage> createState() => _GaragePageState();
}

class _GaragePageState extends State<GaragePage> {
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
                        builder: (context) => NotificationsPage(
                              profileId: widget.profileId,
                            )),
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
                          profileId: widget.profileId,
                          garageId: garageId,
                        ),
                        RentedTab(
                          profileId:
                              widget.profileId, // Pass profileId to RentedTab
                        ),
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
  final int garageId;

  const ListedTab(
      {super.key,
      required this.garageItemsFuture,
      required this.profileId,
      required this.garageId});

  @override
  _ListedTabState createState() => _ListedTabState();
}

class _ListedTabState extends State<ListedTab> {
  late Future<Map<String, dynamic>> _garageItemsFuture;

  @override
  void initState() {
    super.initState();
    _garageItemsFuture = widget.garageItemsFuture;
  }

  // This method refreshes the garage items after a price update
  void _refreshGarageItems() {
    setState(() {
      // Update the future that fetches the garage items
      _garageItemsFuture = _listingService.viewGarageItems(widget.garageId);
      print("Refresh garage...");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<Map<String, dynamic>>(
          future: _garageItemsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              final motorizedVehicles = data["motorized_vehicles"] as List;
              final gearItems = data["gear"] as List;

              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Text(
                    "Motorized Vehicles",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...motorizedVehicles.map(
                    (vehicle) => ListTile(
                      title: Text(vehicle['Model']),
                      subtitle:
                          Text("Rental Price: \$${vehicle['Rental_Price']}"),
                      trailing: const Icon(Icons.motorcycle),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GarageVehiclePage(
                              vehicleData: vehicle,
                              profileId: widget.profileId,
                              onPriceUpdated: _refreshGarageItems,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GarageGearPage(
                                gearData: gear,
                                profileId: widget.profileId,
                                onPriceUpdated: _refreshGarageItems,
                              ),
                            ),
                          );
                        },
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

class GarageVehiclePage extends StatefulWidget {
  final Map<String, dynamic>? vehicleData;
  final int profileId;
  final VoidCallback onPriceUpdated; // Callback function to refresh the list

  const GarageVehiclePage(
      {super.key,
      required this.vehicleData,
      required this.profileId,
      required this.onPriceUpdated});

  @override
  State<GarageVehiclePage> createState() => _GarageVehiclePageState();
}

class _GarageVehiclePageState extends State<GarageVehiclePage> {
  final TextEditingController _rentalPriceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Set the initial text for the rental price controller
    _rentalPriceController.text =
        widget.vehicleData?['Rental_Price']?.toString() ?? '';
  }

  void updateRentalPrice() async {
    bool request = await _listingService.updateRentalPrice(
      itemType: 'vehicle',
      itemId: widget.vehicleData?['VIN'],
      newPrice: double.parse(_rentalPriceController.text),
    );
    if (!request) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rental price update was unsuccessful.")),
      );
    } else {
      widget.onPriceUpdated();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rental price updated successfully!")),
      );
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _rentalPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Vehicle Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Model: " + widget.vehicleData?['Model']),
            Text(
              "Mileage: ${widget.vehicleData?['Mileage']?.toString() ?? 'N/A'}",
            ),
            Text(
              "Color: " + widget.vehicleData?['Color'],
            ),
            Text(
              "VIN: " + widget.vehicleData?['VIN'],
            ),
            Text(
              "Registration: " + widget.vehicleData?['Registration'],
            ),
            Text(
              "Insurance: " + widget.vehicleData?['Insurance'],
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Update Rental Price",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _rentalPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Rental Price",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: updateRentalPrice,
                label: const Text("Save Rental Price"),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayMaintenanceRecordsPage(
                          vin: widget.vehicleData?['VIN'],
                          profileId: widget.profileId),
                    ),
                  );
                },
                icon: const Icon(Icons.list),
                label: const Text("View Maintenance Records"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TODO: Make gear page
class GarageGearPage extends StatefulWidget {
  final Map<String, dynamic>? gearData;
  final int profileId;
  final VoidCallback onPriceUpdated; // Callback function to refresh the list

  const GarageGearPage(
      {super.key,
      required this.gearData,
      required this.profileId,
      required this.onPriceUpdated});

  @override
  State<GarageGearPage> createState() => _GarageGearPageState();
}

class _GarageGearPageState extends State<GarageGearPage> {
  final TextEditingController _rentalPriceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Set the initial text for the rental price controller
    _rentalPriceController.text =
        widget.gearData?['Rental_Price']?.toString() ?? '';
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _rentalPriceController.dispose();
    super.dispose();
  }

  void updateRentalPrice() async {
    bool request = await _listingService.updateRentalPrice(
      itemType: 'gear',
      itemId: widget.gearData?['Product_No'],
      newPrice: double.parse(_rentalPriceController.text),
    );
    print(request);
    if (!request) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rental price update was unsuccessful.")),
      );
    } else {
      Navigator.pop(context);
      widget.onPriceUpdated();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rental price updated successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gear Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Gear Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Brand: " + widget.gearData?['Brand']),
            Text("Material: " + widget.gearData?['Material']),
            Text("Type: " + widget.gearData?['Type']),
            Text("Size: " + widget.gearData?['Size']),
            // Text("Rental Price: " + widget.gearData?['Rental_Price']),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                "Update Rental Price",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _rentalPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Rental Price",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: updateRentalPrice,
                label: const Text("Save Rental Price"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// showing rented tab for vehicles/gear/lots that are rented
class RentedTab extends StatelessWidget {
  final int profileId; // Profile ID for fetching rental history

  const RentedTab({super.key, required this.profileId});

  Future<List<dynamic>> fetchRentalHistory() async {
    final ListingService listingService = ListingService();
    return await listingService.fetchBuyerRentalHistory(profileId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchRentalHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final rentals = snapshot.data!;
          return ListView.builder(
            itemCount: rentals.length,
            itemBuilder: (context, index) {
              final rental = rentals[index];
              return ListTile(
                leading: const Icon(Icons.motorcycle, color: Colors.blueGrey),
                title: Text(rental['item_name']),
                subtitle: Text(
                  "Rental Period: ${rental['start_date']} to ${rental['end_date']}\n"
                  "Transaction Date: ${rental['transaction_date'] ?? 'N/A'}",
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RentalDetailPage(
                        rentalDetails: rental,
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return const Center(child: Text("No rentals found."));
        }
      },
    );
  }
}
