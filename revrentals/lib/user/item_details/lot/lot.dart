import 'package:flutter/material.dart';
import 'package:revrentals/user/item_details/lot/lot_details.dart';

// Widget to display motorcycles in each tab
class LotTab extends StatelessWidget {
  final Future<List<dynamic>> storageLotsFuture;
  final int profileId;

  const LotTab(
      {super.key, required this.profileId, required this.storageLotsFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: storageLotsFuture,
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
                        profileId: profileId,
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
}
