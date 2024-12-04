import 'package:flutter/material.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'package:revrentals/user/item_details/gear/gear_details.dart';
import 'package:revrentals/user/item_details/lot/lot_details.dart';
import 'package:revrentals/user/item_details/motorcycle/motorcycle_details.dart';
import 'package:revrentals/user/item_details/gear/gear.dart';
import 'package:revrentals/user/notifications/notifications.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:revrentals/user/item_details/motorcycle/motorcycle.dart';
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
/* class MotorcycleTab extends StatefulWidget {
  final int profileId;
  final Future<List<dynamic>> motorcyclesFuture;
  

  const MotorcycleTab(
      {super.key, required this.profileId, required this.motorcyclesFuture});

  @override
  _MotorcycleTabState createState() => _MotorcycleTabState();
  
}

class _MotorcycleTabState extends State<MotorcycleTab> {
  
} */


// GearTab updated to fetch and display gear items
/*class GearTab extends StatelessWidget {
  final Future<List<dynamic>> gearFuture;
  final int profileId;

  const GearTab({super.key, required this.profileId, required this.gearFuture});

  void _showFilterDialog(BuildContext context) {
    String selectedGear = 'All';
    String selectedPriceRange = 'Any';
    String selectedBrand = 'Any';
    String selectedSize = 'Any';
    String selectedMaterial = 'Any';

    final List<String> gearType = [
      'All',
      'Helmet',
      'Gloves',
      'Jacket',
      'Boots',
      'Pants',
    ];
    final List<String> priceRanges = [
      'Any',
      'Under \$100',
      'Above \$100',
      'Under \$200',
      'Above \$200'
    ];

    final List<String> brandOptions = [
      'Any',
      'Alpinestars',
      'AGV',
      'Shoei',
      'HJC',
      'Arai',
    ];

    final List<String> materialOptions = [
      'Any',
      'Leather',
      'Plastic',
      'Textile',
      'Kevlar',
    ];

    final List<String> sizeOptions = [
      'Any',
      'X-Small',
      'Small',
      'Medium',
      'Large',
      'X-Large',
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
                  // Dropdown for Category
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedGear,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                    ),
                    items: gearType.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGear = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Dropdown for Price Range
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
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

                  // Dropdown for Insurance
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedBrand,
                    decoration: const InputDecoration(
                      labelText: 'Brand',
                      border: OutlineInputBorder(),
                    ),
                    items: brandOptions.map((String brand) {
                      return DropdownMenuItem<String>(
                        value: brand,
                        child: Text(brand),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBrand = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedSize,
                    decoration: const InputDecoration(
                      labelText: 'Size',
                      border: OutlineInputBorder(),
                    ),
                    items: sizeOptions.map((String size) {
                      return DropdownMenuItem<String>(
                        value: size,
                        child: Text(size),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSize = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Dropdown for Color
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedMaterial,
                    decoration: const InputDecoration(
                      labelText: 'Material',
                      border: OutlineInputBorder(),
                    ),
                    items: materialOptions.map((String material) {
                      return DropdownMenuItem<String>(
                        value: material,
                        child: Text(material),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMaterial = newValue!;
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
                    // Handle the filter logic here
                    print(
                        'Category: $selectedGear, Price Range: $selectedPriceRange');
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
          /*onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          }, */
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
      ),
      ),
    ]);
  }
} 
*/

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
