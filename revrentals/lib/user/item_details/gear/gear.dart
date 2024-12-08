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
                /* TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ), */
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
                    final gearItems = _filteredGear[index];

                    return ListTile (
                      title: Text(gearItems['Gear_Name'] ?? 'Unknown Gear'),
                      subtitle: Text("Rental Price: \$${gearItems['GRentalPrice']}"),
                      trailing: const Icon(Icons.settings),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GearDetailPage(
                              profileId: widget.profileId, 
                              gearData: gearItems, 
                              ),
                            ),
                        );
                      }
                    );
                  },
                );
              } else if (filterApplied) {
                // If a filter was applied and no gear match, show a message
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
                      print(_originalGear);
                      final gear = snapshot.data!;
                      _originalGear = gear;

                      return ListView.builder(
                        itemCount: gear.length,
                        itemBuilder: (context, index) {
                          final gearItems = gear[index];

                          return ListTile(
                            title: Text(gearItems['Gear_Name'] ?? 'Unknown Gear'),
                            subtitle: Text("Rental Price: \$${gearItems['GRentalPrice']}"),
                            trailing: const Icon(Icons.settings),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GearDetailPage(
                                    profileId: profileId, 
                                    gearData: gearItems,
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