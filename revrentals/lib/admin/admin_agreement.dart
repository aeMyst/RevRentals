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
                          builder: (context) =>
                              ReservationDetailsPage(reso: resos),
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
  Map<String, dynamic> reso;
  ReservationDetailsPage({super.key, required this.reso});

  @override
  State<ReservationDetailsPage> createState() => _ReservationDetailsPageState();
}

class _ReservationDetailsPageState extends State<ReservationDetailsPage> {
  late Future<dynamic> data;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservation Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...widget.reso.entries
                  .where(
                      (entry) => entry.value != null) // Filter non-null values
                  .map((entry) =>
                      Text("${entry.key.replaceAll('_', ' ')}: ${entry.value}"))
                  .toList(),
              // data = _adminService.fetchTransactions(widget.reso['Reservation_No'] as int);
              const SizedBox(height: 16),
              Center(
                  child: ElevatedButton.icon(
                      onPressed: () {
                        if (widget.reso['Status'] != "Pending Approval") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionAgreementsPage(
                                  reservationNo:
                                      widget.reso['Reservation_No'] as int),
                            ),
                          );
                        } else {
                          // Show a message or perform an alternative action
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Approval is still pending. No details available.")),
                          );
                        }
                      },
                      label:
                          const Text("View Transaction & Agreement Details"))),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionAgreementsPage extends StatefulWidget {
  final int reservationNo; // Reservation number passed from the previous page

  TransactionAgreementsPage({super.key, required this.reservationNo});

  @override
  State<TransactionAgreementsPage> createState() =>
      _TransactionAgreementsPageState();
}

class _TransactionAgreementsPageState extends State<TransactionAgreementsPage> {
  final AdminService _adminService = AdminService();
  late Future<Map<String, dynamic>> transactionData;

  @override
  void initState() {
    super.initState();
    // Fetch transaction details using the reservation number
    transactionData = _adminService.fetchTransactions(widget.reservationNo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction & Agreement Details"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: transactionData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(
                child: Text("No transaction details available."));
          } else {
            final transaction =
                snapshot.data; // Access the 'transaction' 
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Transaction ID: ${transaction!['Transaction_ID']}"),
                  Text("Agreement ID: ${transaction['Agreement_ID']}"),
                  Text("Garage ID: ${transaction['Garage_ID']}"),
                  Text("Payment Date: ${transaction['Pay_Date']}"),
                  Text("Payment Method: ${transaction['Payment_Method']}"),
                  Text("Amount Paid: \$${transaction['Amount_Paid']}"),
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
