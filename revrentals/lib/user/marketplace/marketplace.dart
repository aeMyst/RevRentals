import 'package:flutter/material.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'package:revrentals/user/item_details/gear/gear_details.dart';
import 'package:revrentals/user/item_details/lot/lot_details.dart';
import 'package:revrentals/user/item_details/motorcycle/motorcycle_details.dart';
import 'package:revrentals/user/notifications/notifications.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:revrentals/services/listing_service.dart'; // Import ListingService

import 'package:http/http.dart' as http;
import 'dart:convert';

class MarketplacePage extends StatefulWidget {
  final int profileId;
  final Map<String, dynamic>? userData;

  const MarketplacePage({super.key, required this.profileId, this.userData});

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
    _storageLotsFuture =
        _listingService.fetchStorageLots(); // Fetch storage lots
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
                  builder: (context) => DisplayProfileDetailsPage(
                    userData: widget.userData, // Pass from UserHomePage
                  ),
                ),
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
                    MotorcycleTab(
                        profileId: widget.profileId,
                        motorcyclesFuture: _motorcyclesFuture),
                    GearTab(
                        profileId: widget.profileId,
                        gearFuture: _gearFuture), // Pass gearFuture
                    LotTab(
                      profileId: widget.profileId,
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
class MotorcycleTab extends StatefulWidget {
  final int profileId;
  final Future<List<dynamic>> motorcyclesFuture;

  const MotorcycleTab(
      {super.key, required this.profileId, required this.motorcyclesFuture});

  @override
  _MotorcycleTabState createState() => _MotorcycleTabState();
  
}

class _MotorcycleTabState extends State<MotorcycleTab> {
  late Future<List<dynamic>> motorcyclesFuture;
  late List<dynamic> _filteredMotorcycles = [];  // local storage of filtered vehicles
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    motorcyclesFuture = widget.motorcyclesFuture;
    /*motorcyclesFuture.then((motorcycles) {
      setState(() {
        _motorcyclesList = motorcycles;
      });
    }); */
    _filteredMotorcycles = [];
  }


  void _applySort(String selectedSortOption) {
  motorcyclesFuture.then((motorcycles) {
    switch (selectedSortOption) {
      case 'Price: Low to High':
        motorcycles.sort((a, b) => a['Rental_Price'].compareTo(b['Rental_Price']));
        break;
      case 'Price: High to Low':
        motorcycles.sort((a, b) => b['Rental_Price'].compareTo(a['Rental_Price']));
        break;
      case 'Newest First':
        motorcycles.sort((a, b) => b['dateAdded'].compareTo(a['dateAdded'])); // TO FIX
        break;
      default:
        break;
    }

    // Update the motorcycles list
    setState(() {
      motorcyclesFuture = Future.value(motorcycles);
    });
  });
}

  void _showSortDialog(BuildContext context) {
    String selectedSortOption = 'None';
    final List<String> sortOptions = [
      'None',
      'Price: Low to High',
      'Price: High to Low',
      'Newest First'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Sort Options'),
              content: DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: selectedSortOption,
                decoration: const InputDecoration(
                  labelText: 'Sort By',
                  border: OutlineInputBorder(),
                ),
                items: sortOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSortOption = newValue!;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle the sort logic here
                    print('Sort Option: $selectedSortOption');

                    _applySort(selectedSortOption);

                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
  String selectedVehicle = 'All';
  String selectedPriceRange = 'Any';
  String selectedInsurance = 'Any';
  String selectedMileage = 'Any';
  String selectedColor = 'Any';

  final List<String> vehicleType = [
    'All',
    'Motorcycles',
    'Dirtbike',
    'Moped'
  ];
  final List<String> priceRanges = [
    'Any',
    'Under \$100',
    'Above \$100',
    'Under \$200',
    'Above \$200'
  ];
  final List<String> insuranceOptions = [
    'Any',
    'Basic',
    'Premium',
    'Comprehensive'
  ];
  final List<String> colorOptions = [
    'Any',
    'Red',
    'Orange',
    'Yellow',
    'Green',
    'Blue',
    'Purple',
    'Pink',
    'Black',
    'White',
    'Other',
  ];
  final List<String> mileageOptions = [
    'Any',
    'Under 10,000 km',
    '10,000 - 50,000 km',
    'Above 50,000 km'
  ];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Filter Options'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dropdown for Vehicle Type
                DropdownButtonFormField<String>(
                  value: selectedVehicle,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Type',
                    border: OutlineInputBorder(),
                  ),
                  items: vehicleType.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedVehicle = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Dropdown for Price Range
                DropdownButtonFormField<String>(
                  value: selectedPriceRange,
                  decoration: const InputDecoration(
                    labelText: 'Price Range',
                    border: OutlineInputBorder(),
                  ),
                  items: priceRanges.map((String range) {
                    return DropdownMenuItem<String>(
                      value: range,
                      child: Text(range),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPriceRange = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Dropdown for Color
                DropdownButtonFormField<String>(
                  value: selectedColor,
                  decoration: const InputDecoration(
                    labelText: 'Color',
                    border: OutlineInputBorder(),
                  ),
                  items: colorOptions.map((String color) {
                    return DropdownMenuItem<String>(
                      value: color,
                      child: Text(color),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedColor = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Dropdown for Mileage
                DropdownButtonFormField<String>(
                  value: selectedMileage,
                  decoration: const InputDecoration(
                    labelText: 'Mileage',
                    border: OutlineInputBorder(),
                  ),
                  items: mileageOptions.map((String mileage) {
                    return DropdownMenuItem<String>(
                      value: mileage,
                      child: Text(mileage),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMileage = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Dropdown for Insurance
                DropdownButtonFormField<String>(
                  value: selectedInsurance,
                  decoration: const InputDecoration(
                    labelText: 'Insurance',
                    border: OutlineInputBorder(),
                  ),
                  items: insuranceOptions.map((String insurance) {
                    return DropdownMenuItem<String>(
                      value: insurance,
                      child: Text(insurance),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedInsurance = newValue!;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _applyColorFilter(context, selectedColor);
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
            ],
          );
        },
      );
    },
  );
}

  void _applyColorFilter(BuildContext context, String selectedColor) async {
    final url = Uri.parse('http://10.0.2.2:8000/filter-by-color/');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'color': selectedColor,
      }),
    );

    if (response.statusCode == 200) {
      // Handle successful response
      final responseData = json.decode(response.body);
      final filteredMotorcycles = responseData['vins'];

      setState(() {
        _filteredMotorcycles = filteredMotorcycles;
      });
      
      print('Filtered Vehicles: ${responseData['vins']}');
    } else {
      // Handle error response
      print('Error: ${response.body}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),

        // Search bar
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search Motorcycles...',
            prefixIcon: const Icon(Icons.search),

            // need to keep all three of these so it stays rounded 
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),  
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),  
              borderSide: const BorderSide(color: Colors.grey), 
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),  
              borderSide: const BorderSide(color: Colors.grey), 
            ),
          ),
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          }, 
        ),
      ),
        const SizedBox(height: 16),

        // Filter and Sort Buttons Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.filter_list),
              label: const Text(
                'Filter',
              ),
              onPressed: () {
                _showFilterDialog(context);
              },
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.sort),
              label: const Text(
                'Sort',
              ),
              onPressed: () {
                  // TODO: Add sort functionality
                  _showSortDialog(context);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),

        Expanded (
          child: FutureBuilder<List<dynamic>>(
          future: motorcyclesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final motorcycles = snapshot.data!;

              // filtering
              final filteredMotorcycles = motorcycles
                .where((motorcycle) => motorcycle['Model']
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
                .toList();
              
              return ListView.builder(
                itemCount: filteredMotorcycles.length,
                itemBuilder: (context, index) {
                  final motorcycle = filteredMotorcycles[index];

                  return ListTile(
                    title: Text(motorcycle['Model']),
                    subtitle: Text("Rental Price: \$${motorcycle['Rental_Price']}"),
                    trailing: const Icon(Icons.motorcycle),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MotorcycleDetailPage(
                            profileId: widget.profileId,
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
        ),
      )
    ]
  );}
}


// GearTab updated to fetch and display gear items
class GearTab extends StatelessWidget {
  final Future<List<dynamic>> gearFuture;
  final int profileId;

  const GearTab({super.key, required this.profileId, required this.gearFuture});

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
                        profileId: profileId,
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
  final int profileId;

  const LotTab(
      {super.key, required this.profileId, required this.storageLotsFuture});

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
                      builder: (context) => LotDetailsPage(profileId: profileId,
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
