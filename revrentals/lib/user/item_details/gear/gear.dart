import 'package:flutter/material.dart';
import 'package:revrentals/user/item_details/gear/gear_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GearTab extends StatefulWidget {
  final int profileId;
  final Future<List<dynamic>> gearFuture;

  const GearTab(
      {super.key, required this.profileId, required this.gearFuture});

  @override
  _GearTabState createState() => _GearTabState();

}

class _GearTabState extends State<GearTab> {
  late Future<List<dynamic>> gearFuture;
  late final int profileId;
  late List<dynamic> _filteredGear = [];
  late List<dynamic> _originalGear = [];
  bool filterApplied = false;
  String selectedGear = 'All';
  String selectedBrand = 'Any';
  String selectedSize = 'Any';
  String selectedMaterial = 'Any';
  String selectedPriceRange = 'Any';
  String _currentSort = 'None';
  Map<String, String?> _currentFilters = {
    'type': "All",
    'priceRange': "Any",
    'brand': "Any",
    'size': "Any",
    'material': "Any",
  };


  @override
  void initState() {
    super.initState();
    gearFuture = widget.gearFuture;
    profileId = widget.profileId;
    _filteredGear = [];
    _originalGear = [];
    filterApplied = false;
  }

  // Save original list for when user resets to 'None' sort option.
  void getOriginalList() async {
    try {
      final response = await fetchGear('http://10.0.2.2:8000/get-all-gear');
      if (response != null && response.isNotEmpty) {
        setState(() {
          _originalGear = response; 
          _filteredGear = List.from(response); 
        });
      }
    } catch (error) {
      print("Error fetching gear: $error");
    }
  }

  // Function to fetch gear
  Future<List<dynamic>?> fetchGear(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('gear') && responseData['gear'] is List) {
            return responseData['gear'];
          } else {
            return [];
          }
      } else {
        print("Server responded with status code: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("Error fetching gear: $error");
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
  );}

  // Function to apply sorting
  void _applySort(String selectedSortOption) {
    setState(() {
      _currentSort = selectedSortOption;
      print("Current sort: $_currentSort");

      // Ensure _originalGear is used as the source when no filters are applied
      if (!filterApplied) {
        // Sorting original gear
        switch (selectedSortOption) {
          case 'None':
            _filteredGear = List.from(_originalGear); // Reset to original unsorted data
            break;
          case 'Price: Low to High':
            _filteredGear = List.from(_originalGear)
             ..sort((a, b) => (a['GRentalPrice'] as double).compareTo(b['GRentalPrice'] as double));
            break;
          case 'Price: High to Low':
            _filteredGear = List.from(_originalGear)
             ..sort((a, b) => (b['GRentalPrice'] as double).compareTo(a['GRentalPrice'] as double));
            break;
          default:
            _filteredGear = List.from(_originalGear); // Default behavior
        }
      } else {
        // Sorting filtered motorcycles
        switch (selectedSortOption) {
          case 'None':
            _filteredGear = List.from(_filteredGear); // Reset to filtered unsorted data
            break;
          case 'Price: Low to High':
            _filteredGear.sort((a, b) => double.parse(a['GRentalPrice']).compareTo(double.parse(b['GRentalPrice'])));
            break;
          case 'Price: High to Low':
            _filteredGear.sort((a, b) => double.parse(b['GRentalPrice']).compareTo(double.parse(a['GRentalPrice'])));
            break;
          default:
            _filteredGear = List.from(_filteredGear); // Default behavior
        }
      }
    });
  }

  // Show filter options when 'Filter' pressed
  void _showFilterDialog(BuildContext context, {required Map<String, String?> currentFilters}) {
    String selectedGear = currentFilters['type'] ?? 'All';
    String selectedPriceRange = currentFilters['priceRange'] ?? 'Any';
    String selectedBrand = currentFilters['brand'] ?? 'Any';
    String selectedSize = currentFilters['size'] ?? 'Any';
    String selectedMaterial = currentFilters['material'] ?? 'Any';

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
      'Under \$50',
      'Under \$100',
      'Under \$150',
      'Under \$200',
      'Under \$250'
    ];

    final List<String> brandOptions = [
      'Any',
      'Alpinestars',
      'AGV',
      'Shoei',
      'HJC',
      'Arai',
      'Dainese',
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
      'XS',
      'S',
      'M',
      'L',
      'XL',
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
                  // Dropdown for Gear Type
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
                        _currentFilters['type'] = newValue;
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
                        _currentFilters['priceRange'] = newValue;
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
                        _currentFilters['brand'] = newValue;
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
                        _currentFilters['size'] = newValue;
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
                        _currentFilters['material'] = newValue;
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
                      _applyGearPageFilter(
                        context: context,
                        selectedGear: selectedGear,
                        selectedBrand: selectedBrand,
                        selectedSize: selectedSize,
                        selectedPriceRange: selectedPriceRange,
                        selectedMaterial: selectedMaterial);
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
  void _applyGearPageFilter(
    {required BuildContext context,
    String? selectedGear,
    String? selectedPriceRange,
    String? selectedBrand,
    String? selectedMaterial,
    String? selectedSize,

    }) async {
      try {
         setState(() {
          // Keeping track of filters used
          _currentFilters = {
            'type': selectedGear,
            'brand': selectedBrand,
            'priceRange': selectedPriceRange,
            'size': selectedSize,
            'material': selectedMaterial,
          };

          print(_currentFilters);
        });

        final Map<String, String?> filters = {
          "type": selectedGear,
          "brand": selectedBrand,
          "size": selectedSize,
          "material": selectedMaterial,
          "grental_price": selectedPriceRange != "Any"
            ? parsePrice(selectedPriceRange)?.toString()
            : "Any",
        };

        final query = filters.entries
          .where((entry) => entry.value != "Any" && entry.value != "All")
          .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value!)}')
          .join('&');
        print("QUERY: $query");

        final requestUrl = 'http://10.0.2.2:8000/filter-gear-by-multiple-conditions/?$query';
        print("Request URL: $requestUrl");

        final response = await fetchGear(requestUrl);

        if (response != null && response.isNotEmpty) {
          setState(() {
            _filteredGear = response;
            _originalGear = response; // save original list
            filterApplied = true;
          });
        } else {
          setState(() {
            _filteredGear = [];
            _originalGear = [];
            filterApplied = true;
          });
        }
      } catch (error) {
        print("Error applying filters: $error");
        setState((){
          _filteredGear = [];
          _originalGear = [];
          filterApplied = false;
        });
      }
  }

  // Helper function to parsePrice
  int? parsePrice(String? input) {
    if (input == null) return null;

    final match = RegExp(r'\d+').firstMatch(input);

    return match != null ? int.tryParse(match.group(0)!) : null;
  }

  // Helper method to reset filtiner
  Future<void> resetFilters() async {
    try {
      final requestUrl = 'http://10.0.2.2:8000/api/gear-items/';
      print("Request URL: $requestUrl");

      final response = await fetchGear(requestUrl);

      if (response != null && response.isNotEmpty) {
        setState(() {
          _filteredGear = response;
          filterApplied = false; // Indicate filters are cleared
        });
      } else {
        setState(() {
          _filteredGear = [];
          filterApplied = false;
        });
      }

      setState(() {
              _currentFilters = {
                'type': "All",
                'priceRange': "Any",
                'brand': "Any",
                'size': "Any",
                'material': "Any",
              };
            });
    } catch (error) {
      print("Error resetting filters and fetching all vehicles: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> displayGear;

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
                  _showSortDialog(context, currentSort: _currentSort);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),

        Expanded(
          child: Builder(
            builder: (context) {
              if (_filteredGear.isNotEmpty) {

                // SHOW FILTERED GEAR
                print("Displaying filtered GEAR");
                return ListView.builder(
                  itemCount: _filteredGear.length,
                  itemBuilder: (context, index) {
                    final gear = _filteredGear[index];

                    return ListTile(
                        title: Text(gear['Gear_Name'] ?? 'Unknown Gear'),
                            subtitle: Text("Rental Price: \$${gear['GRentalPrice']}"),
                            trailing: const Icon(Icons.settings),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GearDetailPage(
                                    profileId: widget.profileId, 
                                    gearData: gear, 
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
                      "No gear available. Please select other filter option(s).",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                // Use FutureBuilder only for the initial fetch
                return FutureBuilder<List<dynamic>>(
                  future: gearFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      print("Displaying original gears list");
                      final vehicles = snapshot.data!;

                      return ListView.builder(
                        itemCount: vehicles.length,
                        itemBuilder: (context, index) {
                          final gear = vehicles[index];

                          return ListTile(
                            title: Text(gear['Gear_Name'] ?? 'Unknown Gear'),
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
                            }
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text("No gear available."));
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
    
    /*
      //tracker
      int defaultFilterChanged = 0;

      // track user change
      if (selectedGear != "All") defaultFilterChanged++;
      if (selectedSize != "Any") defaultFilterChanged++;
      if (selectedPriceRange != "Any") defaultFilterChanged++;
      if (selectedMaterial != "Any") defaultFilterChanged++;
      if (selectedBrand != "Any") defaultFilterChanged++;

      bool multipleFiltersUsed = defaultFilterChanged >1;

      // No filters selected, reset to original list
      if (selectedGear == "All" && selectedSize == "Any" &&
          selectedPriceRange == "Any" &&
          selectedMaterial == "Any" &&
          selectedBrand == "Any") {
      try {
        final gear = await gearFuture;

        List<dynamic> filteredGearList = gear;

        // applying
        setState (() {
          _filteredGear = filteredGearList;
        });
      } catch (error){
        print("Error resolving gearFuture: $error");
      }
    } else {
      List<dynamic> filteredGearList = [];
      final Set<int> uniqueProductNo = {}; // prevents duplications, tracks unique IDs

      if (multipleFiltersUsed) {
        print("Multiple filtering in progress....");

        // multiple filtering
        if (selectedGear != "All" ||
          selectedSize != "Any" ||
          selectedPriceRange != "Any" ||
          selectedMaterial != "Any" ||
          selectedBrand != "Any"
          ) {
          final numericPrice = (selectedPriceRange != null && selectedPriceRange != "Any")
              ? int.tryParse(selectedPriceRange.replaceAll(RegExp(r'[^0-9]'), ''))
              : null;

        final multipleFilterResults = await _applyMultipleFilters(
          brand: selectedBrand,
          material: selectedMaterial,
          gearType: selectedGear,
          size: selectedSize,
          maxPrice: numericPrice?.toDouble(),
        );
        print("multipleFilterResults type: ${multipleFilterResults.runtimeType}");
        print("multipleFilterResults length: ${multipleFilterResults.length}");
        print("Multiple filter results: $multipleFilterResults");
        print("_filteredMotorcycles + $_filteredGear");

        for (var item in multipleFilterResults) {
            if (!uniqueProductNo.contains(item['Product_No'])) {
              uniqueProductNo.add(item['Product_No']);
              filteredGearList.add(item);
            }
          }
          _filteredGear = filteredGearList;
          print("_filteredGear: $_filteredGear");

        } 

      print("More than one filter used");
      setState (() {
          _filteredGear = filteredGearList;
        });

      } else {
      // Apply gear filter
        if (selectedGear != null && selectedGear != "All") {
          final gearFilteredList = await _applyGearFilter(selectedGear);
          for (var item in gearFilteredList) {
          if (!uniqueProductNo.contains(item['Product_No'])) {
            uniqueProductNo.add(item['Product_No']);
            filteredGearList.add(item);
            }
          }
        }

        // Apply brand filter
        if (selectedBrand != null && selectedBrand != "Any") {
          final brandFilteredList = await _applyBrandFilter(selectedBrand);
          for (var item in brandFilteredList) {
          if (!uniqueProductNo.contains(item['Product_No'])) {
            uniqueProductNo.add(item['Product_No']);
            filteredGearList.add(item);
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
          if (!uniqueProductNo.contains(item['Product_No'])) {
            uniqueProductNo.add(item['Product_No']);
            filteredGearList.add(item);
            }
          }
        }

        // Apply size filter
        if (selectedSize != null && selectedSize != "Any") {
          final sizeFilteredList = await _applySizeFilter(selectedSize);
          for (var item in sizeFilteredList) {
          if (!uniqueProductNo.contains(item['Product_No'])) {
            uniqueProductNo.add(item['Product_No']);
            filteredGearList.add(item);
            }
          }
        }

        // Apply material filter
        if (selectedMaterial != null && selectedMaterial != "Any") {
          final insuranceFilteredList = await _applyMaterialFilter(selectedMaterial);
          for (var item in insuranceFilteredList) {
          if (!uniqueProductNo.contains(item['Product_No'])) {
            uniqueProductNo.add(item['Product_No']);
            filteredGearList.add(item);
            }
          }
        }

        // Update state with the filtered list or reset if no results
        if (filteredGearList.isNotEmpty) {
          setState(() {
            _filteredGear = filteredGearList;
            filterApplied = true;
          });
        } else {
          setState(() {
            _filteredGear = [];
            filterApplied = true;
          });
        }  
      }
    }
  } */
 
 /*
  Future<List<dynamic>> _applyGearFilter(String selectedGear) async {
    final url = Uri.parse('http://10.0.2.2:8000/filter-by-gear/');
    final body = {'type': selectedGear};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData.containsKey('gear') && responseData['gear'] is List) {
          return responseData['gear'];
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

  Future<List<dynamic>> _applyBrandFilter(String selectedBrand) async {
    final url = Uri.parse('http://10.0.2.2:8000/filter-by-brand/');
    final body = {'brand': selectedBrand};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData.containsKey('gear') && responseData['gear'] is List) {
          return responseData['gear'];
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
  final url = Uri.parse('http://10.0.2.2:8000/filter-by-gear-price/');
  final body = {'grental_price': maxPrice};

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData['gear'] ?? [];
  } else {
    throw Exception('Failed to filter by price: ${response.body}');
  }
}

  Future<List<dynamic>> _applySizeFilter(String selectedSize) async {
  final url = Uri.parse('http://10.0.2.2:8000/filter-by-size/');
  final body = {'size': selectedSize};

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData.containsKey('gear') && responseData['gear'] is List) {
        return responseData['gear'];
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

  Future<List<dynamic>> _applyMaterialFilter(String selectedMaterial) async {
  final url = Uri.parse('http://10.0.2.2:8000/filter-by-material/');
  final body = {'material': selectedMaterial};

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData.containsKey('gear') && responseData['gear'] is List) {
        return responseData['gear'];
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
  String? brand,
  String? material,
  String? gearType,
  String? size,
  double? maxPrice,
}) async {
  final url = Uri.parse('http://10.0.2.2:8000/filter-gear-by-multiple-conditions/');
  print("Checkpoint1");
  
  final body = <String, dynamic>{};

  if (brand != null && brand.isNotEmpty) {
    body['brand'] = brand;
  }
  if (material != null && material.isNotEmpty) {
    body['material'] = material;
  }
  if (gearType != null && gearType.isNotEmpty) {
    body['type'] = gearType;
  }
  if (size != null && size.isNotEmpty) {
    body['size'] = size;
  }
  if (maxPrice != null) {
    body['grental_price'] = maxPrice;
    print("Checkpoint2");

  }
  print("Checkpoint2");


  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    print("Request Body: ${json.encode(body)}");


    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData.containsKey('gear') && responseData['gear'] is List) {
        return responseData['gear'];
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
}  */
/*
  void _applySortGear(String selectedSortOption) {
    gearFuture.then((gear) {
      switch (selectedSortOption) {
        case 'Price: Low to High':
          gear.sort((a, b) => a['GRentalPrice'].compareTo(b['GRentalPrice']));
          break;
        case 'Price: High to Low':
          gear.sort((a, b) => b['GRentalPrice'].compareTo(a['GRentalPrice']));
          break;
       /* case 'Newest First':
          gear.sort((a, b) => b['dateAdded'].compareTo(a['dateAdded'])); // TO DO>?? idk
          break; */
        default:
          break;
      }

      // Update the motorcycles list
      setState(() {
        gearFuture = Future.value(gear);
      });
    });
  } */

  

  /*    Expanded (
        child: FutureBuilder<List<dynamic>>(
        future: gearFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final gearItems = snapshot.data!;

            if (_filteredGear.isNotEmpty) {
                // If there are filtered motorcycles, show them
                displayGear = _filteredGear;
              } else if (filterApplied) {
                // If a filter was applied and no motorcycles match, show a "No vehicles available" message
                return const Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), 
                    child: Text(
                      "No gear available. Please select other filter option(s).",
                      style: TextStyle(fontSize: 14), 
                      textAlign: TextAlign.center,   
                    ),
                  ),
                );
              } else {
                // If no filter is applied, show the original list
                displayGear = gearItems;
              }

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
} */

// Widget to display motorcycles in each tab
/*class GearTab extends StatelessWidget {
  const GearTab({super.key});

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

        // Filter and Sort Buttons Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.filter_list),
              label: const Text(
                'Filter',
              ),
              onPressed: () {
                // TODO: Add filter functionality
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
        // Motorcycle List
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: const [
              GearItem(
                imagePath: 'lib/images/gear/agv_pista.webp',
                name: 'AGV Pista GP RR',
                description: '',
                rentalPrice: 100.0,
              ),
              GearItem(
                imagePath: 'lib/images/gear/gloves.png',
                name: 'Alpinestars Stella SMX-2 Air Carbon V2',
                description:
                    'High-quality leather gloves for comfort and protection.',
                rentalPrice: 35.50,
              ),
              GearItem(
                imagePath: 'lib/images/gear/jacket.jpg',
                name: 'Alpinestars GPR Plus Jacket',
                description: 'Leather jacket with armor protection.',
                rentalPrice: 120.99,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GearItem extends StatefulWidget {
  final String imagePath;
  final String name;
  final String description;
  final double rentalPrice;

  const GearItem({
    super.key,
    required this.name,
    required this.rentalPrice,
    required this.imagePath,
    required this.description,
  });

  @override
  State<GearItem> createState() => _GearItemState();
}

class _GearItemState extends State<GearItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the GearDetailPage when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GearDetailPage(
              // imagePath: widget.imagePath,
              // name: widget.name,
              // description: widget.description,
              // rentalPrice: widget.rentalPrice,
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
                // Gear image
                Center(
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 10),
                // Gear name
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                // Rental price per day
                Text(
                  'Per Day: \$${widget.rentalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                // Description (if available)
                if (widget.description.isNotEmpty)
                  Text(
                    widget.description,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RentedItem extends StatefulWidget {
  const RentedItem({super.key});

  @override
  State<RentedItem> createState() => _RentedItemState();
}

class _RentedItemState extends State<RentedItem> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
} */