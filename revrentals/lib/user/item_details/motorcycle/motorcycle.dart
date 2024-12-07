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
  late final int profileId;
  bool filterApplied = false;
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

  String selectedColor = 'Any';
  String selectedMileage = 'Any';
  String selectedPriceRange = 'Any';
  String selectedVehicle = 'All';
  String selectedInsurance = 'Any';

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
                    print('Sort Option: $selectedSortOption');

                    _applySort(selectedSortOption);
                    print('Applying Sort Option: $selectedSortOption');

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
  
  void _showFilterDialog(BuildContext context, {required Map<String, String?> currentFilters}) {
  String selectedVehicle = currentFilters['vehicle'] ?? 'All';
  String selectedPriceRange = currentFilters['priceRange'] ?? 'Any';
  String selectedInsurance = currentFilters['insurance'] ?? 'Any';
  String selectedMileage = currentFilters['mileage'] ?? 'Any';
  String selectedColor = currentFilters['color'] ?? 'Any';
  String selectedEngineType = currentFilters['engine'] ??'Any';
  String selectedCargoRacks = currentFilters['cargoRacks'] ??'Any';
  String selectedDirtbikeType = currentFilters['dirtbikeType'] ??'Any';

  final List<String> vehicleType = [
    'All',
    'Motorcycle',
    'Dirtbike',
    'Moped'
  ];
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
                      _currentFilters['vehicle'] = newValue;
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
                        _currentFilters['engine'] = newValue;
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
                        _currentFilters['cargoRacks'] = newValue;
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
                        _currentFilters['dirtbikeType'] = newValue;
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
                      print('Current selected mileage value: $_currentFilters');

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
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              Row (
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
                    applyFilter(
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

  void applyFilter({
    required BuildContext context,
      String? selectedVehicle = "All",
      String? selectedColor = "Any",
      String? selectedPriceRange = "Any",
      String? selectedMileage = "Any",
      String? selectedInsurance = "Any",
      String? selectedCargoRacks = "Any",
      String? selectedEngineType = "Any",
      String? selectedDirtbikeType = "Any",
      final numericPrice, numericMileage,

    }) async {
      try {
        // keeping track of filters used.
        setState(() {
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

          print(_currentFilters);
        });

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

        final requestUrl = 'http://10.0.2.2:8000/filter-by-multiple-conditions/?$query';
        print("Request URL: $requestUrl");

        final response = await fetchMotorcycles(requestUrl);

        if (response != null && response.isNotEmpty) {
          setState(() {
            _filteredMotorcycles = response;
            filterApplied = true;
          });
        } else {
          setState(() {
            _filteredMotorcycles = [];
            filterApplied = true;
          });
        }
      } catch (error) {
        print("Error applying filters: $error");
        setState((){
          _filteredMotorcycles = [];
          filterApplied = true;
        });   
      }
    }

  Future<List<dynamic>?> fetchMotorcycles(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData.containsKey('vehicles') && responseData['vehicles'] is List) {
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

  double? parseMileage(String? input) {
  if (input == null) return null;

  final match = RegExp(r'[\d]+\.?\d*').firstMatch(input);

  return match != null ? double.tryParse(match.group(0)!) : null;
}

  int? parsePrice(String? input) {
  if (input == null) return null;

  final match = RegExp(r'\d+').firstMatch(input);

  return match != null ? int.tryParse(match.group(0)!) : null;
}

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

// old methods for filtering
/*
 void _applyFilter({
    required BuildContext context,
    String? selectedVehicle,
    String? selectedColor,
    String? selectedPriceRange,
    String? selectedMileage,
    String? selectedInsurance,
    String? selectedCargoRacks,
    String? selectedEngine,
    String? selectedDirtbikeType,

  }) async {
    // tracker
    int defaultFilterChanged = 0;

    //track user change 
    if (selectedVehicle != "All") defaultFilterChanged++;
    if (selectedColor != "Any") defaultFilterChanged++;
    if (selectedPriceRange != "Any") defaultFilterChanged++;
    if (selectedMileage != "Any") defaultFilterChanged++;
    if (selectedInsurance != "Any") defaultFilterChanged++;

    bool multipleFiltersUsed = defaultFilterChanged > 1;

    // If no filters are selected, reset to the original list (motorcyclesFuture)
    if (selectedVehicle == "All" && selectedColor == "Any" &&
    selectedPriceRange == "Any" &&
    selectedMileage == "Any" &&
    selectedInsurance == "Any") {
    try {
      // original list
      final motorcycles = await motorcyclesFuture;

      // filtering
      List<dynamic> filteredList = motorcycles;

      // applying filtering
      setState(() {
        _filteredMotorcycles = filteredList;
      });
    } catch (error) {
      print("Error resolving motorcyclesFuture: $error");
    }
  } else {
      // Initialize an empty list to collect filtered motorcycles
      List<dynamic> filteredList = [];
      final Set<String> uniqueVINs = {}; // prevent duplications

      if (multipleFiltersUsed) {
        print("Multiple filtering in progress....");

        // MULTIPLE FILTERING
        if (selectedVehicle != "All" ||
          selectedColor != "Any" ||
          selectedPriceRange != "Any" ||
          selectedInsurance != "Any" ||
          selectedCargoRacks != "Any" ||
          selectedEngine != "Any" ||
          selectedDirtbikeType != "Any"
          ) {
          final numericPrice = (selectedPriceRange != null && selectedPriceRange != "Any")
              ? int.tryParse(selectedPriceRange.replaceAll(RegExp(r'[^0-9]'), ''))
              : null;
          final numericMileage = (selectedMileage != null && selectedMileage != "Any")
              ? int.tryParse(selectedMileage.replaceAll(RegExp(r'[^0-9]'), ''))
              : null;

          final multipleFilterResults = await _applyMultipleFilters(
            vehicle: selectedVehicle,
            color: selectedColor,
            insurance: selectedInsurance,
            mileage: numericMileage,
            maxPrice: numericPrice?.toDouble(),
            engineType: selectedEngine,
            cargoRacks: selectedCargoRacks,
            dirtbikeType: selectedDirtbikeType,
          );

          for (var item in multipleFilterResults) {
            if (!uniqueVINs.contains(item['VIN'])) {
              uniqueVINs.add(item['VIN']);
              filteredList.add(item);
            }
          }
          _filteredMotorcycles = filteredList;
        }
        
        print("More than one filter used");

      } else {
        // Apply vehicle filter
        if (selectedVehicle != null && selectedVehicle != "Any") {
          final vehicleFilteredList = await _applyVehicleFilter(selectedVehicle);
          for (var item in vehicleFilteredList) {
          if (!uniqueVINs.contains(item['VIN'])) {
            uniqueVINs.add(item['VIN']);
            filteredList.add(item);
            }
          }
        }

        // Apply color filter
        if (selectedColor != null && selectedColor != "Any") {
          final colorFilteredList = await _applyColorFilter(selectedColor);
          for (var item in colorFilteredList) {
          if (!uniqueVINs.contains(item['VIN'])) {
            uniqueVINs.add(item['VIN']);
            filteredList.add(item);
            }
          }
        }

        // Apply price range filter
        if (selectedPriceRange != null && selectedPriceRange != "Any") {
          // Extract the numeric value from the selected price range
          final numericPrice = int.parse(
            selectedPriceRange.replaceAll(RegExp(r'[^0-9]'), '')
          );

          // Call the filter function with the numeric price
          final priceFilteredList = await _applyPriceFilter(numericPrice);
          for (var item in priceFilteredList) {
          if (!uniqueVINs.contains(item['VIN'])) {
            uniqueVINs.add(item['VIN']);
            filteredList.add(item);
            }
          }
        }

        // Apply mileage filter
        if (selectedMileage != null && selectedMileage != "Any") {
        final numericMileage = int.parse(
            selectedMileage.replaceAll(RegExp(r'[^0-9]'), '')
        );

        // Call the filter function with the numeric price
        final mileageFilteredList = await _applyMileageFilter(numericMileage);
        for (var item in mileageFilteredList) {
          if (!uniqueVINs.contains(item['VIN'])) {
            uniqueVINs.add(item['VIN']);
            filteredList.add(item);
            }
          }
        }

        // Apply insurance filter
        if (selectedInsurance != null && selectedInsurance != "Any") {
          final insuranceFilteredList = await _applyInsuranceFilter(selectedInsurance);
          for (var item in insuranceFilteredList) {
          if (!uniqueVINs.contains(item['VIN'])) {
            uniqueVINs.add(item['VIN']);
            filteredList.add(item);
            }
          }
        }
      }
     
      // Update state with the filtered list or reset if no results
      if (filteredList.isNotEmpty) {
        setState(() {
          _filteredMotorcycles = filteredList;
          filterApplied = true;
        });
      } else {
        setState(() {
          _filteredMotorcycles = [];
          filterApplied = true;
        });
      }
    }
  } */

/*
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

  Future<List<dynamic>> _applyMileageFilter(int selectedMileage) async {
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

Future<List<dynamic>> _applyMultipleFilters({
  String? vehicle,
  String? color,
  String? insurance,
  int? mileage,
  double? maxPrice,
  String? engineType,
  String? cargoRacks,
  String? dirtbikeType,
  
}) async {
  final url = Uri.parse('http://10.0.2.2:8000/filter-by-multiple-conditions/');
  
  final body = <String, dynamic>{};

  if (vehicle != null && vehicle.isNotEmpty) {
    body['vehicle_type'] = vehicle;
  }
  if (color != null && color.isNotEmpty) {
    body['color'] = color;
  }
  if (insurance != null && insurance.isNotEmpty) {
    body['insurance'] = insurance;
  }
  if (mileage != null) {
    body['mileage'] = mileage;
  }
  if (maxPrice != null) {
    body['rental_price'] = maxPrice;
  }
  if (engineType != null && engineType.isNotEmpty) {
    body['engine_type'] = engineType;
  }
  if (cargoRacks != null && cargoRacks.isNotEmpty) {
    body['cargo_rack'] = cargoRacks;
  }
  if (dirtbikeType != null && dirtbikeType.isNotEmpty) {
    body['dirt_bike_type'] = dirtbikeType;
  }


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
} */

  @override
  Widget build(BuildContext context) {
   List<dynamic> displayMotorcycles;

    return Column(
      children: [
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
                _showFilterDialog(context, currentFilters: _currentFilters);
              },
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.sort),
              label: const Text(
                'Sort',
              ),
              onPressed: () {
                  _showSortDialog(context);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),

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
                            }
                    );
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
                      final vehicles = snapshot.data!;

                      return ListView.builder(
                        itemCount: vehicles.length,
                        itemBuilder: (context, index) {
                          final motorcycle = vehicles[index];

                          return ListTile(
                            title: Text(motorcycle['Model'] ?? 'Unknown Model'),
                            subtitle: Text("Rental Price: \$${motorcycle['Rental_Price']}"),
                            trailing: const Icon(Icons.motorcycle),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MotorcycleDetailPage(
                                    profileId: widget.profileId, 
                                    motorcycleData: motorcycle, // GRRRAHHHHH??!?@?#?!@?
                                    ),
                                  ),
                              );
                            }
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text("No vehicles available."));
                    }
                  },
                );
              }
            },
          ),
        ),
      ],
    );}
  } 
     /*   Expanded (
          child: FutureBuilder<List<dynamic>>(
          future: motorcyclesFuture, // The original list is fetched here.
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final vehicles = snapshot.data!;

              if (_filteredMotorcycles.isNotEmpty && filterApplied) {
                // If there are filtered motorcycles, show them
                displayMotorcycles = _filteredMotorcycles;
                print("display");

              } else if (filterApplied) {
                // If a filter was applied and no motorcycles match, show a "No vehicles available" message
                return const Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), 
                    child: Text(
                      "No vehicles available. Please select other filter option(s).",
                      style: TextStyle(fontSize: 14), 
                      textAlign: TextAlign.center,   
                    ),
                  ),
                );
              } else {
                // If no filter is applied, show the original list
                displayMotorcycles = vehicles;
                print("HERE");
              }

              return ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];

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
      ), */

// Motorcycle card - not using
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
