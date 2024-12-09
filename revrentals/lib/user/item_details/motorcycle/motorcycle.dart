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
  late List<dynamic> _filteredMotorcycles =
      []; // local storage of filtered vehicles
  late List<dynamic> _originalMotorcycles = [];
  late final int profileId;
  bool filterApplied = false;
  String _currentSort = 'None';
  String selectedColor = 'Any';
  String selectedMileage = 'Any';
  String selectedPriceRange = 'Any';
  String selectedVehicle = 'All';
  String selectedInsurance = 'Any';
  Map<String, String?> _currentFilters = {
    'vehicle': "All",
    'color': "Any",
    'priceRange': "Any",
    'mileage': "Any",
    'insurance': "Any",
    'cargoRacks': "Any",
    'engine': "Any",
    'dirtbikeType': "Any",
  };

  @override
  void initState() {
    super.initState();
    motorcyclesFuture = widget.motorcyclesFuture;
    _filteredMotorcycles = [];
    _originalMotorcycles = [];
    filterApplied = false;
  }

  // Save original list for when user resets to 'None' sort option.
  void getOriginalList() async {
    try {
      final response =
          await fetchMotorcycles('http://10.0.2.2:8000/get-all-vehicles');
      if (response != null && response.isNotEmpty) {
        setState(() {
          _originalMotorcycles = response; // Save full unfiltered data here.
          _filteredMotorcycles =
              List.from(response); // Make a copy for filtered data.
        });
      }
    } catch (error) {
      print("Error fetching motorcycles: $error");
    }
  }

  // Function to fetch motorcyles
  Future<List<dynamic>?> fetchMotorcycles(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('vehicles') &&
            responseData['vehicles'] is List) {
          return responseData['vehicles'];
        } else {
          return [];
        }
      } else {
        print("Server responded with status code: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("Error fetching motorcycles: $error");
      return null;
    }
  }

  // Show sort options when Sort button pressed
  void _showSortDialog(BuildContext context, {required String currentSort}) {
    String selectedSortOption = _currentSort;
    final List<String> sortOptions = [
      'None',
      'Price: Low to High',
      'Price: High to Low',
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
                    _currentSort = newValue;
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
                    print('Applying Sort Option: $selectedSortOption');
                    _applySort(selectedSortOption);
                    _currentSort = selectedSortOption;
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

  // Function to apply sorting
  void _applySort(String selectedSortOption) {
    setState(() {
      _currentSort = selectedSortOption;
      print("Current sort: $_currentSort");

      // Ensure _originalMotorcycles is used as the source when no filters are applied
      if (!filterApplied) {
        // Sorting original motorcycles
        switch (selectedSortOption) {
          case 'None':
            _filteredMotorcycles = List.from(
                _originalMotorcycles); // Reset to original unsorted data
            break;
          case 'Price: Low to High':
            _filteredMotorcycles = List.from(_originalMotorcycles)
              ..sort((a, b) => (a['Rental_Price'] as double)
                  .compareTo(b['Rental_Price'] as double));
            break;
          case 'Price: High to Low':
            _filteredMotorcycles = List.from(_originalMotorcycles)
              ..sort((a, b) => (b['Rental_Price'] as double)
                  .compareTo(a['Rental_Price'] as double));
            break;
          default:
            _filteredMotorcycles =
                List.from(_originalMotorcycles); // Default behavior
        }
      } else {
        // Sorting filtered motorcycles
        switch (selectedSortOption) {
          case 'None':
            _filteredMotorcycles = List.from(
                _filteredMotorcycles); // Reset to filtered unsorted data
            break;
          case 'Price: Low to High':
            _filteredMotorcycles.sort((a, b) => double.parse(a['Rental_Price'])
                .compareTo(double.parse(b['Rental_Price'])));
            break;
          case 'Price: High to Low':
            _filteredMotorcycles.sort((a, b) => double.parse(b['Rental_Price'])
                .compareTo(double.parse(a['Rental_Price'])));
            break;
          default:
            _filteredMotorcycles =
                List.from(_filteredMotorcycles); // Default behavior
        }
      }
    });
  }

  // Show filter options when 'Filter' pressed
  void _showFilterDialog(BuildContext context,
      {required Map<String, String?> currentFilters}) {
    String selectedVehicle = currentFilters['vehicle'] ?? 'All';
    String selectedPriceRange = currentFilters['priceRange'] ?? 'Any';
    String selectedInsurance = currentFilters['insurance'] ?? 'Any';
    String selectedMileage = currentFilters['mileage'] ?? 'Any';
    String selectedColor = currentFilters['color'] ?? 'Any';
    String selectedEngineType = currentFilters['engine'] ?? 'Any';
    String selectedCargoRacks = currentFilters['cargoRacks'] ?? 'Any';
    String selectedDirtbikeType = currentFilters['dirtbikeType'] ?? 'Any';

    final List<String> vehicleType = ['All', 'Motorcycle', 'Dirtbike', 'Moped'];
    final List<String> priceRanges = [
      'Any',
      'Below \$100',
      'Below \$150',
      'Below \$200',
      'Below \$250',
      'Below \$300',
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
      'Multicolor',
      'Other',
    ];
    final List<String> mileageOptions = [
      'Any',
      'Under 10000',
      'Under 50000',
      'Under 100000'
    ];
    final List<String> engineTypes = [
      'Any',
      'Parallel-Twin',
      'Single',
      'Inline-Three',
      'Inline-Four',
      'V-Twin',
      'L-Twin',
      'V4',
      'Flat-Twins'
    ];
    final List<String> cargoRacks = [
      'Any',
      '0',
      '1',
    ];
    final List<String> dirtbikeType = [
      'Any',
      'Off-Road',
      'Trail',
      'Motocross',
      'Enduro',
      'Dual-Sport',
      'Adventure',
      'Hill-Climb'
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
                        _currentFilters['vehicle'] = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Conditional dropdown for engine type when Motorcycles is selected
                  if (selectedVehicle == 'Motorcycle') ...[
                    DropdownButtonFormField<String>(
                      value: selectedEngineType,
                      decoration: const InputDecoration(
                        labelText: 'Engine Type',
                        border: OutlineInputBorder(),
                      ),
                      items: engineTypes.map((String engine) {
                        return DropdownMenuItem<String>(
                          value: engine,
                          child: Text(engine),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedEngineType = newValue!;
                          _currentFilters['engine'] = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Conditional dropdown for engine type when Moped is selected
                  if (selectedVehicle == 'Moped') ...[
                    DropdownButtonFormField<String>(
                      value: selectedCargoRacks,
                      decoration: const InputDecoration(
                        labelText: 'Cargo Racks',
                        border: OutlineInputBorder(),
                      ),
                      items: cargoRacks.map((String cargo) {
                        return DropdownMenuItem<String>(
                          value: cargo,
                          child: Text(cargo),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCargoRacks = newValue!;
                          _currentFilters['cargoRacks'] = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Conditional dropdown for engine type when Dirtbike is selected
                  if (selectedVehicle == 'Dirtbike') ...[
                    DropdownButtonFormField<String>(
                      value: selectedDirtbikeType,
                      decoration: const InputDecoration(
                        labelText: 'Dirtbike Type',
                        border: OutlineInputBorder(),
                      ),
                      items: dirtbikeType.map((String dBikeType) {
                        return DropdownMenuItem<String>(
                          value: dBikeType,
                          child: Text(dBikeType),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDirtbikeType = newValue!;
                          _currentFilters['dirtbikeType'] = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
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
                        _currentFilters['priceRange'] = newValue;
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
                        _currentFilters['color'] = newValue;
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
                        _currentFilters['mileage'] = newValue;
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
                        _currentFilters['insurance'] = newValue;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        resetFilters();
                        Navigator.pop(context);
                      },
                      child: const Text('Reset Filters'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        _applyFilter(
                          context: context,
                          selectedVehicle: selectedVehicle,
                          selectedColor: selectedColor,
                          selectedPriceRange: selectedPriceRange,
                          selectedMileage: selectedMileage,
                          selectedInsurance: selectedInsurance,
                          selectedCargoRacks: selectedCargoRacks,
                          selectedDirtbikeType: selectedDirtbikeType,
                          selectedEngineType: selectedEngineType,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Function to apply filtering
  void _applyFilter({
    required BuildContext context,
    String? selectedVehicle = "All",
    String? selectedColor = "Any",
    String? selectedPriceRange = "Any",
    String? selectedMileage = "Any",
    String? selectedInsurance = "Any",
    String? selectedCargoRacks = "Any",
    String? selectedEngineType = "Any",
    String? selectedDirtbikeType = "Any",
    // final numericPrice, numericMileage,
  }) async {
    try {
      // Keeping track of filters used.
      setState(
        () {
          _currentFilters = {
            'vehicle': selectedVehicle,
            'color': selectedColor,
            'priceRange': selectedPriceRange,
            'mileage': selectedMileage,
            'insurance': selectedInsurance,
            'cargoRacks': selectedCargoRacks,
            'engine': selectedEngineType,
            'dirtbikeType': selectedDirtbikeType,
          };
        },
      );

      final Map<String, String?> filters = {
        "vehicle": selectedVehicle,
        "color": selectedColor,
        "rental_price": selectedPriceRange != "Any"
            ? parsePrice(selectedPriceRange)?.toString()
            : "Any",
        "mileage": selectedMileage != "Any"
            ? parseMileage(selectedMileage)?.toString()
            : "Any",
        "insurance": selectedInsurance,
        "cargo_rack": selectedCargoRacks,
        "engine_type": selectedEngineType,
        "dirt_bike_type": selectedDirtbikeType,
      };

      final query = filters.entries
          .where((entry) => entry.value != "Any" && entry.value != "All")
          .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value!)}')
          .join('&');

      final requestUrl =
          'http://10.0.2.2:8000/filter-by-multiple-conditions/?$query';
      print("Request URL: $requestUrl");

      final response = await fetchMotorcycles(requestUrl);

      if (response != null && response.isNotEmpty) {
        setState(() {
          _filteredMotorcycles = response;
          _originalMotorcycles = response; // save original list
          filterApplied = true;
        });
      } else {
        setState(() {
          _filteredMotorcycles = [];
          _originalMotorcycles = [];
          filterApplied = true;
        });
      }
    } catch (error) {
      print("Error applying filters: $error");
      setState(() {
        _filteredMotorcycles = [];
        _originalMotorcycles = [];
        filterApplied = false;
      });
    }
  }

  // Helper method to parse Price
  int? parsePrice(String? input) {
    if (input == null) return null;

    final match = RegExp(r'\d+').firstMatch(input);

    return match != null ? int.tryParse(match.group(0)!) : null;
  }

  // Helper method to parse Mileage
  double? parseMileage(String? input) {
    if (input == null) return null;

    final match = RegExp(r'[\d]+\.?\d*').firstMatch(input);

    return match != null ? double.tryParse(match.group(0)!) : null;
  }

  // Helper method to reset filtiner
  Future<void> resetFilters() async {
    try {
      final requestUrl = 'http://10.0.2.2:8000/api/motorized-vehicles/';
      print("Request URL: $requestUrl");

      final response = await fetchMotorcycles(requestUrl);

      if (response != null && response.isNotEmpty) {
        setState(() {
          _filteredMotorcycles = response;
          filterApplied = false; // Indicate filters are cleared
        });
      } else {
        setState(() {
          _filteredMotorcycles = [];
          filterApplied = false;
        });
      }

      setState(() {
        _currentFilters = {
          'vehicle': "All",
          'color': "Any",
          'priceRange': "Any",
          'mileage': "Any",
          'insurance': "Any",
          'cargoRacks': "Any",
          'engine': "Any",
          'dirtbikeType': "Any",
        };
      });
    } catch (error) {
      print("Error resetting filters and fetching all vehicles: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> displayMotorcycles;

    return Column(
      children: [
        // Filter and Sort Buttons Row
        Container(
          padding: const EdgeInsets.only(
              top: 16, left: 16, right: 16), // Adjust the value as needed
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.filter_list),
                label: const Text(
                  'Filter',
                ),
                onPressed: () {
                  _showFilterDialog(context, currentFilters: _currentFilters);
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.sort),
                label: const Text(
                  'Sort',
                ),
                onPressed: () {
                  _showSortDialog(context, currentSort: _currentSort);
                },
              ),
            ],
          ),
        ),

        Expanded(
          child: Builder(
            builder: (context) {
              if (_filteredMotorcycles.isNotEmpty) {
                // SHOW FILTERED MOTORCYCLES
                print("Displaying filtered motorcycles");
                return ListView.builder(
                  itemCount: _filteredMotorcycles.length,
                  itemBuilder: (context, index) {
                    final motorcycle = _filteredMotorcycles[index];

                    return ListTile(
                        title: Text(motorcycle['Model'] ?? 'Unknown Model'),
                        subtitle: Text(
                            "Rental Price: \$${motorcycle['Rental_Price']}"),
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
                        });
                  },
                );
              } else if (filterApplied) {
                // If a filter was applied and no motorcycles match, show a message
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "No vehicles available. Please select other filter option(s).",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                // Use FutureBuilder only for the initial fetch
                return FutureBuilder<List<dynamic>>(
                  future: motorcyclesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      print("Displaying original motorcycles list");
                      print(_originalMotorcycles);
                      final vehicles = snapshot.data!;
                      _originalMotorcycles = vehicles;

                      return ListView.builder(
                        itemCount: vehicles.length,
                        itemBuilder: (context, index) {
                          final motorcycle = vehicles[index];

                          return ListTile(
                              title:
                                  Text(motorcycle['Model'] ?? 'Unknown Model'),
                              subtitle: Text(
                                  "Rental Price: \$${motorcycle['Rental_Price']}"),
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
                              });
                        },
                      );
                    } else {
                      return const Center(
                          child: Text("No vehicles available."));
                    }
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
