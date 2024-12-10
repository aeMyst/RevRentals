import 'package:flutter/material.dart';
import 'package:revrentals/user/item_details/lot/lot_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Widget to display motorcycles in each tab
class LotTab extends StatefulWidget {
  final Future<List<dynamic>> storageLotsFuture;
  final int profileId;

  const LotTab(
      {super.key, required this.profileId, required this.storageLotsFuture});
    
  @override
  _LotTabState createState() => _LotTabState();
}

class _LotTabState extends State<LotTab> {
  Future<List<dynamic>> _sortedLots = Future.value([]);
  List<dynamic> _originalLots = [];
  String _currentSortOption = 'None';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

   /// Fetch and initialize the initial lot data
  Future<void> _initializeData() async {
    try {
      final fetchedLots = await widget.storageLotsFuture;
      if (fetchedLots != null) {
        setState(() {
          _originalLots = fetchedLots;
          _sortedLots = Future.value(_originalLots); // Set default to show the unmodified list
        });
      } else {
        setState(() {
          _sortedLots = Future.value([]); // Handle edge case if no data
        });
      }
    } catch (error) {
      print("Error fetching lots: $error");
      setState(() {
        _sortedLots = Future.value([]); // Handle error by showing an empty state
      });
    }
  }
  
   /// Apply sorting logic to the fetched lot data
  Future<void> _applySort(String selectedSortOption) async {
    List<dynamic> sortedList = List.from(_originalLots); 
    switch (selectedSortOption) {
      case 'None': // return original data
        break;
      case 'Price: Low to High':
        sortedList.sort(
          (a, b) => (a['LRentalPrice'] as double)
              .compareTo(b['LRentalPrice'] as double),
        );
        break;
      case 'Price: High to Low':
        sortedList.sort(
          (a, b) => (b['LRentalPrice'] as double)
              .compareTo(a['LRentalPrice'] as double),
        );
        break;
      default:
        break;
    }
    setState(() {
      _currentSortOption = selectedSortOption;
      _sortedLots = Future.value(sortedList);
    });
  }


  // Show sort options when Sort button pressed
  void _showSortDialog(BuildContext context) {
    String selectedSortOption = 'None';
    final List<String> sortOptions = [
      'None',
      'Price: Low to High',
      'Price: High to Low',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedSortOption = _currentSortOption;

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
                    print('Applying Sort Option: $selectedSortOption');
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


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter and Sort Buttons Row
        Container(
          padding: const EdgeInsets.only(
              top: 16, left: 16, right: 16), // Adjust the value as needed
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
        ),

        Expanded (
          child: Builder (
            builder: (context) {
                return FutureBuilder<List<dynamic>>(
                future: _sortedLots,
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
                          subtitle: Text("Address: ${lot['LAddress']}" +
                              "\nRental Price: ${lot['LRentalPrice']}"),
                          trailing: const Icon(Icons.warehouse),
                          onTap: () {
                            print(
                                'Lot data before navigation: $lot'); // FOR SOME REASON RENTAL PRICE IS NOT BEING PASSED
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LotDetailsPage(
                                  profileId: widget.profileId,
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
          )
        )
      ],
    );
  
  }
}
