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
  bool filterApplied = false;

  String selectedGear = 'All';
  String selectedBrand = 'Any';
  String selectedSize = 'Any';
  String selectedMaterial = 'Any';
  String selectedPriceRange = 'Any';

  @override
  void initState() {
    super.initState();
    gearFuture = widget.gearFuture;
    
    _filteredGear = [];
  }

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
            );
          },
        );
      },
    );
  }
  
  void _applyGearPageFilter(
    {required BuildContext context,
    String? selectedGear,
    String? selectedPriceRange,
    String? selectedBrand,
    String? selectedMaterial,
    String? selectedSize,

    }) async {
      if (selectedGear == "All" && selectedSize == "Any" &&
          selectedPriceRange == "Any" &&
          selectedMaterial == "Any" &&
          selectedBrand == "Any") {

      try {
        final gear = await gearFuture;

        List<dynamic> filteredGearList = gear;

        setState (() {
          _filteredGear = filteredGearList;
        });
      } catch (error){
        print("Error resolving gearFuture: $error");
      }
    } else {
      List<dynamic> filteredGearList = [];

      if (selectedGear != "All" ||
        selectedSize != "Any" ||
        selectedPriceRange != "Any" ||
        selectedMaterial != "Any" ||
        selectedBrand != "Any") {
        final numericPrice = (selectedPriceRange != null && selectedPriceRange != "Any")
            ? int.tryParse(selectedPriceRange.replaceAll(RegExp(r'[^0-9]'), ''))
            : null;

      final multipleFilterResults = await _applyMultipleFilters(
        brand: selectedBrand != "Any" ? selectedBrand : null,
        material: selectedMaterial != "Any" ? selectedMaterial : null,
        gearType: selectedGear != "All" ? selectedGear : null,
        size: selectedSize != "Any" ? selectedSize : null,
        maxPrice: numericPrice?.toDouble(),
      );

      filteredGearList.addAll(multipleFilterResults);
      }

       // Apply gear filter
      if (selectedGear != null && selectedGear != "All") {
        final gearFilteredList = await _applyGearFilter(selectedGear);
        filteredGearList.addAll(gearFilteredList);
      }

      // Apply brand filter
      if (selectedBrand != null && selectedBrand != "Any") {
        final brandFilteredList = await _applyBrandFilter(selectedBrand);
        filteredGearList.addAll(brandFilteredList);
      }

      // Apply price range filter
      if (selectedPriceRange != null && selectedPriceRange != "Any") {
        // Extract the numeric value from the selected price range
        final numericPrice = int.parse(
          selectedPriceRange.replaceAll(RegExp(r'[^0-9]'), '')
        );

        // Call the filter function with the numeric price
        final priceFilteredList = await _applyPriceFilter(numericPrice);
        filteredGearList.addAll(priceFilteredList);
      }

      // Apply size filter
      if (selectedSize != null && selectedSize != "Any") {
        final sizeFilteredList = await _applySizeFilter(selectedSize);
        filteredGearList.addAll(sizeFilteredList);
      }

      // Apply material filter
      if (selectedMaterial != null && selectedMaterial != "Any") {
        final insuranceFilteredList = await _applyMaterialFilter(selectedMaterial);
        filteredGearList.addAll(insuranceFilteredList);
      }

      // Update state with the filtered list or reset if no results
      if (filteredGearList.isNotEmpty) {
        setState(() {
          _filteredGear = filteredGearList;
        });
      } else {
        setState(() {
          _filteredGear = [];
          filterApplied = true;
        });
      }
    }
  }

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
  final body = {'rental_price': maxPrice};

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
  
  // Build the body dynamically
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
  }

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
                    _applySortGear(selectedSortOption);

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
                  _showSortDialog(context);
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
                            trailing: const Icon(Icons.motorcycle),
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
                      print("Displaying original motorcycles list");
                      final vehicles = snapshot.data!;

                      return ListView.builder(
                        itemCount: vehicles.length,
                        itemBuilder: (context, index) {
                          final gear = vehicles[index];

                          return ListTile(
                            title: Text(gear['Gear_Name'] ?? 'Unknown Gear'),
                            subtitle: Text("Rental Price: \$${gear['GRentalPrice']}"),
                            trailing: const Icon(Icons.motorcycle),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GearDetailPage(
                                    profileId: profileId, 
                                    gearData: gear, // GRRRAHHHHH??!?@?#?!@?
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