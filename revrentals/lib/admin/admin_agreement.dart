import 'package:flutter/material.dart';
import 'package:revrentals/services/admin_service.dart';

class AdminReservationsPage extends StatefulWidget {
  final Future<List<dynamic>> reservationLotsFuture;

  const AdminReservationsPage({super.key, required this.reservationLotsFuture});

  @override
  State<AdminReservationsPage> createState() => _AdminReservationsPageState();
}

class _AdminReservationsPageState extends State<AdminReservationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reservations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<dynamic>>(
          future: widget.reservationLotsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final reservations = snapshot.data!;
              return ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final resos = reservations[index];
                  return ListTile(
                    title: Text("Reservation No: ${resos['Reservation_No']}"),
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
// class TransactionAgreementsPage extends StatefulWidget {
//   final int reservation_no; // Now it's a List<dynamic>

//   TransactionAgreementsPage({super.key, required this.reservation_no});

//   @override
//   State<TransactionAgreementsPage> createState() =>
//       _TransactionAgreementsPageState();
// }

// class _TransactionAgreementsPageState extends State<TransactionAgreementsPage> {
//   final AdminService _adminService = AdminService();
//   late Future<Map<String, dynamic>> transactionData;

//   @override
//   void initState() {
//     super.initState();
//     // Pass the reservation number from the first item in the list
//     transactionData = _adminService.fetchTransactions(widget.reservation_no);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Transaction & Agreement Details"),
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: transactionData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData) {
//             return const Center(
//                 child: Text("No transaction details available."));
//           } else {
//             final data = snapshot.data!['transaction'];

//             return Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Transaction ID: ${data['Transaction_ID']}"),
//                   Text("Agreement ID: ${data['Agreement_ID']}"),
//                   Text("Garage ID: ${data['Garage_ID']}"),
//                   Text("Payment Date: ${data['Pay_Date']}"),
//                   Text("Payment Method: ${data['Payment_Method']}"),
//                   Text("Amount Paid: \$${data['Amount_Paid']}"),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
