import 'package:flutter/material.dart';
import 'package:revrentals/services/admin_service.dart';

class AdminReservationsPage extends StatefulWidget {
  final Future<List<dynamic>> reservationLotsFuture;

  const AdminReservationsPage({super.key, required this.reservationLotsFuture});

  @override
  State<AdminReservationsPage> createState() => _AdminReservationsPageState();
}

class _AdminReservationsPageState extends State<AdminReservationsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late Future<List<dynamic>> _reservationLotsFuture;

  @override
  void initState() {
    super.initState();
    _reservationLotsFuture = widget.reservationLotsFuture; // Initialize Future
  }

  /// Method to refresh the screen completely
  void _refreshScreen() {
    setState(() {
      _searchController.clear(); // Clear the search field
      _searchQuery = ''; // Reset the search query
      _reservationLotsFuture =
          AdminService().fetchReservations(); // Re-fetch data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reservations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshScreen, // Trigger full screen refresh
            tooltip: 'Refresh',
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
                  hintText: 'Search by reservation number...',
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

            // Reservation list
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _reservationLotsFuture, // Use the local Future variable
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // Filter reservations based on search
                    final reservations = snapshot.data!;
                    final filteredReservations = reservations.where((resos) {
                      final reservationNo =
                          resos['Reservation_No'].toString().toLowerCase();
                      return reservationNo.contains(_searchQuery);
                    }).toList();

                    if (filteredReservations.isEmpty) {
                      return const Center(
                          child: Text("No matching reservations found."));
                    }

                    return ListView.builder(
                      itemCount: filteredReservations.length,
                      itemBuilder: (context, index) {
                        final resos = filteredReservations[index];
                        return ListTile(
                          title: Text(
                              "Reservation No: ${resos['Reservation_No']}"),
                          subtitle: Text("Profile_ID: ${resos['Profile_ID']}"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReservationDetailsPage(
                                    reservation_no: resos['Reservation_No']),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("No reservations found."));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReservationDetailsPage extends StatefulWidget {
  // Map<String, dynamic> reso;
  final int reservation_no;
  ReservationDetailsPage({super.key, required this.reservation_no});

  @override
  State<ReservationDetailsPage> createState() => _ReservationDetailsPageState();
}

class _ReservationDetailsPageState extends State<ReservationDetailsPage> {
  late Future<Map<String, dynamic>> reservationDetails;
  final AdminService _adminService = AdminService();

  @override
  void initState() {
    super.initState();
    reservationDetails =
        _adminService.fetchReservationDetails(widget.reservation_no);
  }

  // Helper function to format the keys (replace underscores with spaces and capitalize words)
  String formatKey(String key) {
    List<String> words = key.split('_');
    return words.map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reservation Details")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: reservationDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No reservation details found."));
          } else {
            final data = snapshot.data!;
            final reservationStatus = data['status'];

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final key =
                          data.keys.elementAt(index); // Get the key dynamically
                      final value = data[key]; // Get the value for the key

                      // Format the key using the helper function
                      final formattedKey = formatKey(key);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "$formattedKey:", // Use the formatted key here
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child:
                                  Text(value.toString()), // Display the value
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (reservationStatus == "Paid") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionAgreementsPage(
                              reservation_no: data['reservation_no'] as int,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Reservation is still in progress. No details available.",
                            ),
                          ),
                        );
                      }
                    },
                    label: const Text("View Transaction & Agreement Details"),
                    icon: const Icon(Icons.receipt_long),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class TransactionAgreementsPage extends StatefulWidget {
  final int reservation_no; // Reservation number passed from the previous page

  TransactionAgreementsPage({super.key, required this.reservation_no});

  @override
  State<TransactionAgreementsPage> createState() =>
      _TransactionAgreementsPageState();
}

class _TransactionAgreementsPageState extends State<TransactionAgreementsPage> {
  final AdminService _adminService = AdminService();
  late Future<Map<String, dynamic>> transactionData;
  late Future<Map<String, dynamic>> agreementData;

  @override
  void initState() {
    super.initState();
    // Fetch transaction details using the reservation number
    transactionData = _adminService.fetchTransaction(widget.reservation_no);
    agreementData = _adminService.fetchAgreement(widget.reservation_no);
  }

  String formatKey(String key) {
    List<String> words = key.split('_');
    return words.map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction & Agreement Details"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: transactionData,
        builder: (context, transactionSnapshot) {
          if (transactionSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (transactionSnapshot.hasError) {
            return Center(child: Text("Error: ${transactionSnapshot.error}"));
          } else if (!transactionSnapshot.hasData) {
            return const Center(
                child: Text("No transaction details available."));
          } else {
            final transaction = transactionSnapshot.data;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display transaction data dynamically
                  ...transaction!.keys.map((key) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "${formatKey(key)}:",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(transaction[key].toString()),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  // Display agreement data
                  FutureBuilder<Map<String, dynamic>>(
                    future: agreementData,
                    builder: (context, agreementSnapshot) {
                      if (agreementSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (agreementSnapshot.hasError) {
                        return Center(
                            child: Text("Error: ${agreementSnapshot.error}"));
                      } else if (!agreementSnapshot.hasData) {
                        return const Center(
                            child: Text("No agreement details available."));
                      } else {
                        final agreement = agreementSnapshot.data;

                        return Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display agreement data dynamically
                              ...agreement!.keys.map((key) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "${formatKey(key)}:",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(agreement[key].toString()),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
