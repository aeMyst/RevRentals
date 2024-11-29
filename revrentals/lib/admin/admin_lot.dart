import 'package:flutter/material.dart';
import 'package:revrentals/user/item_details/lot/lot_details.dart';

class AdminLotPage extends StatefulWidget {
  final Future<List<dynamic>> storageLotsFuture;

  const AdminLotPage({super.key, required this.storageLotsFuture});

  @override
  State<AdminLotPage> createState() => _AdminLotPageState();
}

class _AdminLotPageState extends State<AdminLotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Lots",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<dynamic>>(
          future: widget.storageLotsFuture,
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
                            builder: (context) => EditLotPage(),
                          ),
                        );
                      });
                },
              );
            } else {
              return const Center(child: Text("No storage lots found."));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the add lot page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddLotPage(),
            ),
          );
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddLotPage extends StatelessWidget {
  final TextEditingController addressController = TextEditingController();

  AddLotPage({super.key});

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
  void _validateAndAddLot(BuildContext context) {
    final lotAddress = addressController.text.trim();

    if (lotAddress.isEmpty) {
      _showErrorDialog(context, "Lot address cannot be empty!");
    } else {
      // Add logic to handle a valid lot address
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lot added successfully!")),
      );

      addressController.clear(); // Clear the input field after submission
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
  const EditLotPage({super.key});

  @override
  State<EditLotPage> createState() => _EditLotPageState();
}

class _EditLotPageState extends State<EditLotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),

    );
  }
}
