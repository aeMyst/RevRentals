import 'package:flutter/material.dart';
import 'package:revrentals/user/notifications/agreement_transaction.dart';
import 'package:revrentals/user/notifications/rental_approval.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Dictionary of notifications
  final Map<int, String> notifications = {
    1: "Your rental request has been approved!",
    2: "You have a new rental request for your item!",
    3: "Your item is now available for rent.",
  };

  // Method to remove a notification by its ID
  void removeNotification(int id) {
    setState(() {
      notifications.remove(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          // Get the notification ID and message
          final notificationId = notifications.keys.elementAt(index);
          final notificationMessage = notifications[notificationId]!;

          return ListTile(
            leading: const Icon(Icons.notifications, color: Colors.blue),
            title: Text(notificationMessage),
            subtitle: const Text("Tap to view details"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              if (notificationId == 1) {
                // Show a SnackBar for other notifications
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AgreementTransactionPage(
                              itemName: "itemName",
                              renterName: "renterName",
                              rentalPeriod: "rentalPeriod",
                              rentalPrice: 0,
                              totalPrice: 0,
                              onActionCompleted: () {
                                removeNotification(notificationId);
                              },
                            ),));
              } else if (notificationId == 2) {
                // Navigate to rental approval page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RentalApprovalPage(
                      onActionCompleted: () {
                        removeNotification(
                            notificationId); // Dismiss notification after action
                      },
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
