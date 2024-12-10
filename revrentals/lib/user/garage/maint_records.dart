import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:revrentals/services/auth_service.dart';
import 'package:revrentals/services/listing_service.dart';
import 'package:revrentals/user/user_home.dart';
import 'package:revrentals/regex/listing_regex.dart';

final ListingService _listingService = ListingService();
final AuthService _authService = AuthService();

class MaintenanceRecordsPage extends StatefulWidget {
  final String vin;
  final int profileId;
  final Map<String, dynamic>? userData;

  // final garageId;
  MaintenanceRecordsPage({
    super.key,
    required this.vin,
    required this.profileId,
    required this.userData,
    // required this.garageId
  });

  @override
  State<MaintenanceRecordsPage> createState() => _MaintenanceRecordsPageState();
}

class _MaintenanceRecordsPageState extends State<MaintenanceRecordsPage> {
  List<Map<String, dynamic>> maintenanceRecords = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maintenance Records"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: maintenanceRecords.length,
              itemBuilder: (context, index) {
                final record = maintenanceRecords[index];
                return MaintenanceRecordRow(
                  vin: widget.vin,
                  key: ValueKey(index),
                  record: record,
                  onDelete: () => _deleteRecord(index),
                  onUpdate: (updatedRecord) =>
                      _updateRecord(index, updatedRecord),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addNewRecord,
              icon: const Icon(Icons.add),
              label: const Text("Add Maintenance Record"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveRecords(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  void _addNewRecord() {
    setState(() {
      print(widget.vin);
      maintenanceRecords.add(
        {
          "vin": widget.vin,
          "date": null,
          "servicedBy": "",
          "serviceDetails": ""
        },
      );
    });
  }

  void errorMessage(BuildContext context, String message) {
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

  void _updateRecord(int index, Map<String, dynamic> updatedRecord) {
    setState(() {
      maintenanceRecords[index] = updatedRecord;
    });
  }

  void _deleteRecord(int index) {
    setState(() {
      maintenanceRecords.removeAt(index);
    });
  }

  // Validate records before saving
  bool _validateRecords() {
    for (var record in maintenanceRecords) {
      if (record['date'] == null) {
        return false; // Invalid if date is null or empty
      }
      
      // Validate service provider name
      String? serviceByError = Validators.validateName(record['serviced_by']?.trim() ?? '');
      if (serviceByError != null) {
        return false;
      }
      
      // Validate service details
      String? serviceDetailsError = Validators.validateName(record['service_details']?.trim() ?? '');
      if (serviceDetailsError != null) {
        return false;
      }
    }
    return true; // All records are valid
  }

  Future<void> _saveRecords(BuildContext context) async {
    if (maintenanceRecords.isEmpty) {
      errorMessage(context, "No maintenance records inputted.");
    } else if (!_validateRecords()) {
      errorMessage(context, "Fields cannot be null.");
    } else {
      try {
        // Handle saving records (e.g., sending to backend or storing locally)
        // print("Saving records: $maintenanceRecords");
        await _listingService.addMaintRecords(maintenanceRecords);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Maintenance records saved.")),
        );

        _navigateToHomePageWithGarageTab(context);
      } catch (e) {
        errorMessage(context, e.toString());
      }
    }
  }

  // Method to navigate to UserHomePage with Garage Tab selected
  void _navigateToHomePageWithGarageTab(BuildContext context) {
    // Navigate back to the user home page (under garage tab)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => UserHomePage(
                userData: widget.userData,
                selectedTab: 1,
              )),
      (route) =>
          false, // This will remove all previous routes, ensuring we go to the home page
    );
  }
}

class MaintenanceRecordRow extends StatefulWidget {
  final String vin;
  final Map<String, dynamic> record;
  final VoidCallback onDelete;
  final Function(Map<String, dynamic>) onUpdate;

  const MaintenanceRecordRow({
    Key? key,
    required this.vin,
    required this.record,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<MaintenanceRecordRow> createState() => _MaintenanceRecordRowState();
}

class _MaintenanceRecordRowState extends State<MaintenanceRecordRow> {
  late TextEditingController servicedByController;
  late TextEditingController serviceDetailsController;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    servicedByController =
        TextEditingController(text: widget.record["serviced_by"]);
    serviceDetailsController =
        TextEditingController(text: widget.record["service_details"]);
    selectedDate = widget.record["date"];
  }

  @override
  void dispose() {
    servicedByController.dispose();
    serviceDetailsController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      // lastDate: DateTime(2100),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
      _notifyUpdate();
    }
  }

  void _notifyUpdate() {
    // Format the date in yyyy-MM-dd format before updating the record
    String formattedDate = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : ''; // You can use an empty string or null if you want to handle it differently

    widget.onUpdate({
      "vin": widget.vin,
      "date": formattedDate,
      "serviced_by": servicedByController.text,
      "service_details": serviceDetailsController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                        : "Select Date",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: servicedByController,
              decoration: const InputDecoration(labelText: "Serviced By"),
              onChanged: (_) => _notifyUpdate(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: serviceDetailsController,
              decoration: const InputDecoration(labelText: "Service Details"),
              onChanged: (_) => _notifyUpdate(),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete, color: Colors.red),
                label:
                    const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DisplayMaintenanceRecordsPage extends StatefulWidget {
  final String vin;
  final int profileId;
  final Map<String, dynamic>? userData;
  const DisplayMaintenanceRecordsPage(
      {super.key,
      required this.profileId,
      required this.vin,
      required this.userData});

  @override
  State<DisplayMaintenanceRecordsPage> createState() =>
      _DisplayMaintenanceRecordsPageState();
}

class _DisplayMaintenanceRecordsPageState
    extends State<DisplayMaintenanceRecordsPage> {
  // final ListingService _listingService =
  //     ListingService(); // Initialize ListingService
  late Future<List<dynamic>> _maintRecordsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch maintenance records
    _maintRecordsFuture = _listingService.fetchMaintRecords(vin: widget.vin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Maintenance Records")),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _maintRecordsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No maintenance records found."),
                  );
                } else {
                  final records = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Date: ${record['date'] != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(record['date'])) : 'Unknown'}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  "Serviced By: ${record['serviced_by'] ?? 'Unknown'}"),
                              const SizedBox(height: 8),
                              Text(
                                  "Service Details: ${record['service_details'] ?? 'N/A'}"),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MaintenanceRecordsPage(
                        userData: widget.userData,
                        vin: widget.vin,
                        profileId: widget.profileId,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.build),
                label: const Text("Update Maintenance Records"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ViewMaintenanceRecordsPage extends StatefulWidget {
  String vin;
  ViewMaintenanceRecordsPage({super.key, required this.vin});

  @override
  State<ViewMaintenanceRecordsPage> createState() =>
      _ViewMaintenanceRecordsPageState();
}

class _ViewMaintenanceRecordsPageState
    extends State<ViewMaintenanceRecordsPage> {
  @override
  late Future<List<dynamic>> _maintRecordsFuture;
  @override
  void initState() {
    super.initState();
    // Fetch maintenance records
    _maintRecordsFuture = _listingService.fetchMaintRecords(vin: widget.vin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Maintenance Records")),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _maintRecordsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No maintenance records found."),
                  );
                } else {
                  final records = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Date: ${record['date'] != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(record['date'])) : 'Unknown'}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  "Serviced By: ${record['serviced_by'] ?? 'Unknown'}"),
                              const SizedBox(height: 8),
                              Text(
                                  "Service Details: ${record['service_details'] ?? 'N/A'}"),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
