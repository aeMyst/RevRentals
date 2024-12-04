import 'package:flutter/material.dart';
import 'package:revrentals/user/item_details/motorcycle/motorcycle_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



// Widget to display motorcycles in each tab
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
  late final int profileId;
  String _searchQuery = '';
  String selectedColor = 'Any';
  String selectedMileage = 'Any';
  String selectedPriceRange = 'Any';
  String selectedVehicle = 'All';

  @override
  void initState() {
    super.initState();
    motorcyclesFuture = widget.motorcyclesFuture;
    
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

void _applySortTEST({
    required BuildContext context,
    String? selectedVehicle,
    String? selectedColor,
    String? selectedPriceRange,
    String? selectedMileage,
    String? selectedInsurance,
  }) async {
    // If no filters are selected, reset to the original list (motorcyclesFuture)
    if (selectedVehicle == "All" && selectedColor == "Any" &&
    selectedPriceRange == "Any" &&
    selectedMileage == "Any" &&
    selectedInsurance == "Any") {
    try {
      final motorcycles = await motorcyclesFuture;
      setState(() {
        _filteredMotorcycles = motorcycles;
      });
    } catch (error) {
      print("Error resolving motorcyclesFuture: $error");
    }
  } else{
      // Initialize an empty list to collect filtered motorcycles
      List<dynamic> filteredList = [];

      // Apply vehicle filter
      if (selectedVehicle != null && selectedVehicle != "Any") {
        final vehicleFilteredList = await _applyVehicleFilter(selectedVehicle);
        filteredList.addAll(vehicleFilteredList);
      }

      // Apply color filter
      if (selectedColor != null && selectedColor != "Any") {
        final colorFilteredList = await _applyColorFilter(selectedColor);
        filteredList.addAll(colorFilteredList);
      }

      // Apply price range filter
      if (selectedPriceRange != null && selectedPriceRange != "Any") {
        // Extract the numeric value from the selected price range
        final numericPrice = int.parse(
          selectedPriceRange.replaceAll(RegExp(r'[^0-9]'), '')
        );

        // Call the filter function with the numeric price
        final priceFilteredList = await _applyPriceFilter(numericPrice);
        filteredList.addAll(priceFilteredList);
      }

      // Apply mileage filter
      if (selectedMileage != null && selectedMileage != "Any") {
        final mileageFilteredList = await _applyMileageFilter(selectedMileage);
        filteredList.addAll(mileageFilteredList);
      }

      // Apply insurance filter
      if (selectedInsurance != null && selectedInsurance != "Any") {
        final insuranceFilteredList = await _applyInsuranceFilter(selectedInsurance);
        filteredList.addAll(insuranceFilteredList);
      }

      // Update state with the filtered list or reset if no results
      if (filteredList.isNotEmpty) {
        setState(() {
          _filteredMotorcycles = filteredList;
        });
      } else {
        setState(() {
          _filteredMotorcycles = [];
        });
      }
    }
  }

  void _showSortDialog(BuildContext context) {
    String selectedSortOption = 'None';
    final List<String> sortOptions = [
      'None',
      'Price: Low to High',
      'Price: High to Low',
      //'Newest First'
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
  String selectedEngineType = 'Any';
  String selectedCargoRacks = 'Any';
  String selectedDirtbikeType = 'Any';

  final List<String> vehicleType = [
    'All',
    'Motorcycle',
    'Dirtbike',
    'Moped'
  ];
  final List<String> priceRanges = [
    'Any',
    'Under \$100',
    'Under \$150',
    //'Above \$100',
    'Under \$200',
    'Under \$250',
    //'Above \$200'
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
  final List<String> engineTypes = [
    'Any',
    'Inline-4',
    'V-Twin',
    'Electric'
  ];
  final List<String> cargoRacks = [
    'Any',
    '1',
    '2'
  ];
  final List<String> dirtbikeType = [
    'Any',
    'Motocross',
    'Enduro'
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

                // Conditional dropdown for engine type when Motorcycles is selected
                if (selectedVehicle == 'Motorcycle') ...[
                  DropdownButtonFormField<String> (
                    value: selectedEngineType,
                    decoration: const InputDecoration (
                      labelText: 'Engine Type',
                      border: OutlineInputBorder(),
                    ),
                    items: engineTypes.map((String engine) {
                      return DropdownMenuItem<String> (
                        value: engine,
                        child: Text(engine),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedEngineType = newValue!;
                      });
                    },
                  ),
                const SizedBox(height:16),
                ],

                // Conditional dropdown for engine type when Moped is selected
                if (selectedVehicle == 'Moped') ...[
                  DropdownButtonFormField<String> (
                    value: selectedCargoRacks,
                    decoration: const InputDecoration (
                      labelText: 'Cargo Racks',
                      border: OutlineInputBorder(),
                    ),
                    items: cargoRacks.map((String cargo) {
                      return DropdownMenuItem<String> (
                        value: cargo,
                        child: Text(cargo),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCargoRacks = newValue!;
                      });
                    },
                  ),
                const SizedBox(height:16),
                ],

                // Conditional dropdown for engine type when Dirtbike is selected
                if (selectedVehicle == 'Dirtbike') ...[
                  DropdownButtonFormField<String> (
                    value: selectedDirtbikeType,
                    decoration: const InputDecoration (
                      labelText: 'Dirtbike Type',
                      border: OutlineInputBorder(),
                    ),
                    items: dirtbikeType.map((String dBikeType) {
                      return DropdownMenuItem<String> (
                        value: dBikeType,
                        child: Text(dBikeType),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDirtbikeType = newValue!;
                      });
                    },
                  ),
                const SizedBox(height:16),
                ],

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
                  _applyFilter(
                    context: context,
                    selectedVehicle: selectedVehicle,
                    selectedColor: selectedColor,
                    selectedPriceRange: selectedPriceRange,
                    selectedMileage: selectedMileage,
                    selectedInsurance: selectedInsurance,
                    );
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

  void _applyFilter({
    required BuildContext context,
    String? selectedVehicle,
    String? selectedColor,
    String? selectedPriceRange,
    String? selectedMileage,
    String? selectedInsurance,
  }) async {
    // If no filters are selected, reset to the original list (motorcyclesFuture)
    if (selectedVehicle == "All" && selectedColor == "Any" &&
    selectedPriceRange == "Any" &&
    selectedMileage == "Any" &&
    selectedInsurance == "Any") {
    try {
      final motorcycles = await motorcyclesFuture;
      setState(() {
        _filteredMotorcycles = motorcycles;
      });
    } catch (error) {
      print("Error resolving motorcyclesFuture: $error");
    }
  } else{
      // Initialize an empty list to collect filtered motorcycles
      List<dynamic> filteredList = [];

      // Apply vehicle filter
      if (selectedVehicle != null && selectedVehicle != "Any") {
        final vehicleFilteredList = await _applyVehicleFilter(selectedVehicle);
        filteredList.addAll(vehicleFilteredList);
      }

      // Apply color filter
      if (selectedColor != null && selectedColor != "Any") {
        final colorFilteredList = await _applyColorFilter(selectedColor);
        filteredList.addAll(colorFilteredList);
      }

      // Apply price range filter
      if (selectedPriceRange != null && selectedPriceRange != "Any") {
        // Extract the numeric value from the selected price range
        final numericPrice = int.parse(
          selectedPriceRange.replaceAll(RegExp(r'[^0-9]'), '')
        );

        // Call the filter function with the numeric price
        final priceFilteredList = await _applyPriceFilter(numericPrice);
        filteredList.addAll(priceFilteredList);
      }

      // Apply mileage filter
      if (selectedMileage != null && selectedMileage != "Any") {
        final mileageFilteredList = await _applyMileageFilter(selectedMileage);
        filteredList.addAll(mileageFilteredList);
      }

      // Apply insurance filter
      if (selectedInsurance != null && selectedInsurance != "Any") {
        final insuranceFilteredList = await _applyInsuranceFilter(selectedInsurance);
        filteredList.addAll(insuranceFilteredList);
      }

      // Update state with the filtered list or reset if no results
      if (filteredList.isNotEmpty) {
        setState(() {
          _filteredMotorcycles = filteredList;
        });
      } else {
        setState(() {
          _filteredMotorcycles = [];
        });
      }
    }
  }

  Future<List<dynamic>> _applyVehicleFilter(String selectedVehicle) async {
    final url = Uri.parse('http://10.0.2.2:8000/filter-by-vehicle/');
    final body = {'vehicle': selectedVehicle};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData.containsKey('vehicles') && responseData['vehicles'] is List) {
          return responseData['vehicles'];
        } else {
          return [];
        }
      } else {
        print('Error: ${response.body}');
        return [];
      }
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }

  Future<List<dynamic>> _applyColorFilter(String selectedColor) async {
    final url = Uri.parse('http://10.0.2.2:8000/filter-by-color/');
    final body = {'color': selectedColor};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData.containsKey('vehicles') && responseData['vehicles'] is List) {
          return responseData['vehicles'];
        } else {
          return [];
        }
      } else {
        print('Error: ${response.body}');
        return [];
      }
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }

  Future<List<dynamic>> _applyPriceFilter(int maxPrice) async {
  final url = Uri.parse('http://10.0.2.2:8000/filter-by-price/');
  final body = {'rental_price': maxPrice};

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData['vehicles'] ?? [];
  } else {
    throw Exception('Failed to filter by price: ${response.body}');
  }
}

  Future<List<dynamic>> _applyMileageFilter(String selectedMileage) async {
  final url = Uri.parse('http://10.0.2.2:8000/filter-by-mileage/');
  final body = {'mileage': selectedMileage};

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData.containsKey('vehicles') && responseData['vehicles'] is List) {
        return responseData['vehicles'];
      } else {
        return [];
      }
    } else {
      print('Error: ${response.body}');
      return [];
    }
  } catch (error) {
    print('Error: $error');
    return [];
  }
}

  Future<List<dynamic>> _applyInsuranceFilter(String selectedInsurance) async {
  final url = Uri.parse('http://10.0.2.2:8000/filter-by-insurance/');
  final body = {'insurance': selectedInsurance};

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData.containsKey('vehicles') && responseData['vehicles'] is List) {
        return responseData['vehicles'];
      } else {
        return [];
      }
    } else {
      print('Error: ${response.body}');
      return [];
    }
  } catch (error) {
    print('Error: $error');
    return [];
  }
}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
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
          future: motorcyclesFuture, // The original list is fetched here.
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final vehicles = snapshot.data!;

              // If there are no filtered motorcycles, show the original list
              final displayMotorcycles = _filteredMotorcycles.isNotEmpty
                  ? _filteredMotorcycles
                  : vehicles; // Use the filtered list if available, otherwise the original list

              // Apply search filtering if there is a search query
              final filteredBySearch = displayMotorcycles.where((motorcycle) {
                return motorcycle['Model']
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
              }).toList();

              return ListView.builder(
                itemCount: filteredBySearch.length,
                itemBuilder: (context, index) {
                  final vehicle = filteredBySearch[index];

                  return ListTile(
                    title: Text(vehicle['Model'] ?? 'Unknown Model'),
                    subtitle: Text("Rental Price: \$${vehicle['Rental_Price']}"),
                    trailing: const Icon(Icons.motorcycle),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MotorcycleDetailPage(
                            profileId: widget.profileId,
                            motorcycleData: vehicle,
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
      ),
    ],
  );}
}

// Motorcycle card
/*
class MotorcycleCard extends StatefulWidget {
  final String model;
  final double rentalPrice;
  final String imagePath;
  final bool isFavorite;

  const MotorcycleCard({
    super.key,
    required this.model,
    required this.rentalPrice,
    required this.imagePath,
    required this.isFavorite,
  });

  @override
  _MotorcycleCardState createState() => _MotorcycleCardState();
}

class _MotorcycleCardState extends State<MotorcycleCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the MotorcycleDetailPage when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MotorcycleDetailPage(
              profileId: widget.profileId,
              motorcycleData: {
                'model': widget.model, // Pass the model to the detail page
                'rentalPrice': widget.rentalPrice, // Pass rental price
                'imagePath': widget.imagePath, // Pass image path
              },
             
            ),
          ),
        );
      },
      child: SizedBox(
        width: 200,
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Motorcycle image
                Center(
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    height: 150,
                  ),
                ),
                if (widget.isFavorite)
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.favorite, color: Colors.red),
                  ),
                const SizedBox(height: 10),
                // Model name
                Text(
                  widget.model,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                // Rental price per hour
                Text(
                  'Per Day: \$${widget.rentalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RentedMotorcycleCard extends StatefulWidget {
  final String model;
  final String imagePath;
  final double totalRentalPrice;

  const RentedMotorcycleCard({
    super.key,
    required this.model,
    required this.totalRentalPrice,
    required this.imagePath,
  });

  @override
  State<RentedMotorcycleCard> createState() => _RentedMotorcycleCardState();
}

class _RentedMotorcycleCardState extends State<RentedMotorcycleCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentedMotorcycleDetails(
              model: widget.model,
              totalRentalPrice: widget.totalRentalPrice,
              imagePath: widget.imagePath,
            ),
          ),
        );
      },
      child: SizedBox(
        width: 200,
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Motorcycle image
                Center(
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 10),
                // Model name
                Text(
                  widget.model,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                // Rental price per hour
                Text(
                  'Per Day: \$${widget.totalRentalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
} */
