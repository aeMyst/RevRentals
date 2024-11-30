import 'package:flutter/material.dart';

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
                          builder: (context) => TransactionAgreementsPage(),
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

class TransactionAgreementsPage extends StatefulWidget {
  const TransactionAgreementsPage({super.key});

  @override
  State<TransactionAgreementsPage> createState() =>
      _TransactionAgreementsPageState();
}

class _TransactionAgreementsPageState extends State<TransactionAgreementsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
      ),
    );
  }
}
