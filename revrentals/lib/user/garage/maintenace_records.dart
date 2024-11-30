// import 'package:flutter/material.dart';

// class MaintenaceRecordsPage extends StatefulWidget {
//   String vin;

//   MaintenaceRecordsPage({super.key, required this.vin});

//   @override
//   State<MaintenaceRecordsPage> createState() => _MaintenaceRecordsPageState();
// }

// class _MaintenaceRecordsPageState extends State<MaintenaceRecordsPage> {
//   final TextEditingController servicedByController = TextEditingController();
//   final TextEditingController serviceDetailsController =
//       TextEditingController();

//   @override
//   void dispose() {
//     super.dispose();
//     serviceDetailsController.dispose();
//     servicedByController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Maintenance Records"),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: servicedByController,
//               decoration: const InputDecoration(labelText: 'Serviced By'),
//             ),
//               const SizedBox(height: 16),
//             TextField(
//               controller: serviceDetailsController,
//               decoration: const InputDecoration(labelText: 'Service Details'),
//             ),
//               const SizedBox(height: 16),

//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates

class MaintenanceRecordsPage extends StatefulWidget {
  final String vin;

  MaintenanceRecordsPage({super.key, required this.vin});

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
                  key: ValueKey(index),
                  record: record,
                  onDelete: () => _deleteRecord(index),
                  onUpdate: (updatedRecord) => _updateRecord(index, updatedRecord),
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
        onPressed: _saveRecords,
        child: const Icon(Icons.save),
      ),
    );
  }

  void _addNewRecord() {
    setState(() {
      maintenanceRecords.add({"date": null, "servicedBy": "", "serviceDetails": ""});
    });
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

  void _saveRecords() {
    // Handle saving records (e.g., sending to backend or storing locally)
    print("Saving records: $maintenanceRecords");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Maintenance records saved.")),
    );
  }
}

class MaintenanceRecordRow extends StatefulWidget {
  final Map<String, dynamic> record;
  final VoidCallback onDelete;
  final Function(Map<String, dynamic>) onUpdate;

  const MaintenanceRecordRow({
    Key? key,
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
    servicedByController = TextEditingController(text: widget.record["servicedBy"]);
    serviceDetailsController = TextEditingController(text: widget.record["serviceDetails"]);
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
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
      _notifyUpdate();
    }
  }

  void _notifyUpdate() {
    widget.onUpdate({
      "date": selectedDate,
      "servicedBy": servicedByController.text,
      "serviceDetails": serviceDetailsController.text,
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
                label: const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

