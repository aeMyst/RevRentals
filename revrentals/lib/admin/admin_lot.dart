
import 'package:flutter/material.dart';

class AdminLotPage extends StatelessWidget {
  const AdminLotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: const Text(
          "Lots",
          style: TextStyle(color: Colors.white),

        ),
        centerTitle: true,
        
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0), // Added padding around the body
        child: Center(
          child: Text(
            "List of lots will be displayed here.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
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
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  child: const Text("Add Lot", style: TextStyle(color: Colors.white),),
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