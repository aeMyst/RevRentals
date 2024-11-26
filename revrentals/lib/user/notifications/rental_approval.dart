import 'package:flutter/material.dart';

class RentalApprovalPage extends StatelessWidget {
  final VoidCallback onActionCompleted;

  const RentalApprovalPage({super.key, required this.onActionCompleted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Rental Request Approval'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "You have received a rental request for your item.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Details of the rental request:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text("Requested by: John Doe"),
            const Text("Item: 2020 Tesla Model 3"),
            const SizedBox(height: 20),
            const Text("Rental Period: 5 days (from 12th Dec to 17th Dec)"),
            const SizedBox(height: 20),
            const Text("Rental Price: \$150/day"),
            const SizedBox(height: 20),
            const Text("Total Payment: \$750"),
            const SizedBox(height: 40),
            // Centered buttons
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Reject the rental request
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rental request rejected')),
                      );
                      // Notify parent widget that the action is completed
                      onActionCompleted();
                      Navigator.pop(context); // Go back to notifications page
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Reject"),
                  ),
                  const SizedBox(width: 16), // Space between buttons
                  ElevatedButton(
                    onPressed: () {
                      // Approve the rental request
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rental request approved')),
                      );
                      // Notify parent widget that the action is completed
                      onActionCompleted();

                      // TODO: Send notification to renter and back-end

                      Navigator.pop(context); // Go back to notifications page
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Approve"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}