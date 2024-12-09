import 'package:flutter/material.dart';
import 'package:revrentals/services/admin_service.dart';
import 'package:revrentals/services/listing_service.dart';

class AdminLotPage extends StatefulWidget {
  final Future<List<dynamic>> storageLotsFuture;
  final int adminId;
  final VoidCallback onLotUpdated; // Add a callback for refreshing

  const AdminLotPage({
    super.key,
    required this.storageLotsFuture,
    required this.adminId,
    required this.onLotUpdated, // Pass the callback here
  });

  @override
  State<AdminLotPage> createState() => _AdminLotPageState();
}

class _AdminLotPageState extends State<AdminLotPage> {
  late Future<List<dynamic>> _storageLotsFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Initialize the future with the provided future
    _storageLotsFuture = widget.storageLotsFuture;
  }

  /// Method to reload the screen and fetch fresh data
  void _reloadScreen() {
    setState(() {
      _searchController.clear(); // Clear the search field
      _searchQuery = ''; // Reset the search query
      _storageLotsFuture =
          ListingService().fetchStorageLots(); // Correctly assign the Future
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Lots"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reloadScreen, // Trigger full screen reload
            tooltip: 'Reload',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query.toLowerCase(); // Update search query
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search storage lots by lot number...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Lot list
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _storageLotsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // Filter the data based on the search query
                    final storageLots = snapshot.data!.where((lot) {
                      final lotNo = lot['Lot_No'].toString().toLowerCase();
                      final address = lot['LAddress'].toString().toLowerCase();
                      return lotNo.contains(_searchQuery) ||
                          address.contains(_searchQuery);
                    }).toList();

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
                                builder: (context) => EditLotPage(
                                  lotData: lot,
                                  onLotUpdated: _reloadScreen,
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
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the add lot page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddLotPage(
                adminId: widget.adminId,
                onLotAdded: _reloadScreen,
              ),
            ),
          );
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddLotPage extends StatefulWidget {
  final int adminId;
  final VoidCallback onLotAdded; // Callback to notify the parent of changes

  const AddLotPage(
      {super.key, required this.adminId, required this.onLotAdded});

  @override
  State<AddLotPage> createState() => _AddLotPageState();
}

class _AddLotPageState extends State<AddLotPage> {
  final AdminService _adminService = AdminService();

  final TextEditingController addressController = TextEditingController();
  final TextEditingController rentalPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add New Lot"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Lot Address",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    hintText: 'Enter lot address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Price:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: rentalPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter the lot price",
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _validateAndAddLot(context);
                  },
                  child: const Text(
                    "Add Lot",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Method to validate the lot address and show an error dialog if empty
  Future<void> _validateAndAddLot(BuildContext context) async {
    final lotAddress = addressController.text.trim();
    final rentalPriceText = rentalPriceController.text.trim();

    // Check for empty or "null" (case-insensitive) values
    if (lotAddress.isEmpty || lotAddress.toLowerCase() == "null") {
      _showErrorDialog(context, "Lot address cannot be empty or 'null'!");
      return;
    }
    if (rentalPriceText.isEmpty || rentalPriceText.toLowerCase() == "null") {
      _showErrorDialog(context, "Rental price cannot be empty or 'null'!");
      return;
    }

    // Parse and validate rental price
    final rentalPrice = double.tryParse(rentalPriceText);
    if (rentalPrice == null || rentalPrice <= 0) {
      _showErrorDialog(
          context, "Rental price must be a valid positive number.");
      return;
    }

    Map<String, dynamic> lotListingData = {
      "admin_id": widget.adminId,
      "laddress": lotAddress,
      "lrentalprice": rentalPrice,
    };

    try {
      await _adminService.addLotListing(lotListingData);
      widget.onLotAdded();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing added successfully!')),
      );
      Navigator.pop(context); // Navigate back to the previous screen
    } catch (e) {
      _showErrorDialog(context, "Unable to insert lot data.");
    }
  }

  /// Method to show an error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Error",
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class EditLotPage extends StatefulWidget {
  final Map<String, dynamic> lotData; // Accept the full lot data as a Map
  final VoidCallback onLotUpdated; // Add callback

  const EditLotPage(
      {super.key, required this.lotData, required this.onLotUpdated});

  @override
  State<EditLotPage> createState() => _EditLotPageState();
}

class _EditLotPageState extends State<EditLotPage> {
  final AdminService _adminService = AdminService();

  late TextEditingController addressController;
  late TextEditingController rentalPriceController;

  @override
  void initState() {
    super.initState();
    // Initialize the text controller with the current lot address
    addressController = TextEditingController(text: widget.lotData['LAddress']);
    rentalPriceController =
        TextEditingController(text: widget.lotData['LRentalPrice'].toString());
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  Future<void> _updateLot() async {
    final updatedAddress = addressController.text.trim();
    final updatedPriceText = rentalPriceController.text.trim();

    // Check for empty or "null" (case-insensitive) values
    if (updatedAddress.isEmpty || updatedAddress.toLowerCase() == "null") {
      _showErrorDialog("Address cannot be empty or 'null'!");
      return;
    }
    if (updatedPriceText.isEmpty || updatedPriceText.toLowerCase() == "null") {
      _showErrorDialog("Price cannot be empty or 'null'!");
      return;
    }

    // Parse and validate updated price
    final updatedPrice = double.tryParse(updatedPriceText);
    if (updatedPrice == null || updatedPrice <= 0) {
      _showErrorDialog("Price must be a valid positive number.");
      return;
    }

    final updatedData = {
      "Lot_No": widget.lotData['Lot_No'], // Include the Lot ID here
      "LAddress": updatedAddress,
      "LRentalPrice": updatedPrice,
    };

    try {
      final response = await _adminService.updateLotListing(
          updatedAddress, widget.lotData['Lot_No'], updatedPrice);

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
        widget.onLotUpdated();
        Navigator.of(context).pop(true); // Pass true to indicate success
      } else {
        _showErrorDialog(
            response['error'] ?? "An error occurred while updating.");
      }
    } catch (e) {
      _showErrorDialog("Unable to update lot data.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lot = widget.lotData;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Lot"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Lot Number
              Text(
                "Lot No: ${lot['Lot_No']}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),

              // Editable Address Field
              const Text(
                "Address:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter new address",
                ),
              ),
              const SizedBox(height: 20),
              // Editable price field
              const Text(
                "Price:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: rentalPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter a new price",
                ),
              ),
              const SizedBox(height: 20),
              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _updateLot,
                  child: const Text("Save Changes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
