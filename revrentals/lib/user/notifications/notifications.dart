import 'package:flutter/material.dart';
import 'package:revrentals/user/notifications/agreement_transaction.dart';
import 'package:revrentals/user/notifications/rental_approval.dart';

class NotificationsPage extends StatefulWidget {
  final int profileId;
  const NotificationsPage({super.key, required this.profileId});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Dictionary of notifications
  final Map<int, Map<String, dynamic>> notifications = {
    // hardcoded notifications, need some way to retrieve corresponding reservation_no
    1: {"message": "Your rental request has been approved!", "reservation_no": 19},
    2: {"message": "You have a new rental request for your item!", "reservation_no": 19},
    3: {"message": "Your item is now available for rent.", "reservation_no": 103},
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
          final notificationId = notifications.keys.elementAt(index);   // gets the ID of the notification
          final notificationData = notifications[notificationId]!;      // gets message and reservation_no of notifID
          final int reservationNo = notificationData['reservation_no'] as int; // extract reservation_no
          
          return ListTile(
            leading: const Icon(Icons.notifications, color: Colors.blue),
            title: Text(notificationData['message']),
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
                              agreementId: reservationNo,   // agreementID is the same as reservationNo
                            ),));
              } else if (notificationId == 2) {
                // Navigate to rental approval page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RentalApprovalPage(
                      reservationNo: reservationNo,
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
