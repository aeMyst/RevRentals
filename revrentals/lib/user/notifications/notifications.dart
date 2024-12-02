import 'package:flutter/material.dart';
import 'package:revrentals/user/notifications/agreement_transaction.dart';
import 'package:revrentals/user/notifications/rental_approval.dart';
import 'package:revrentals/services/listing_service.dart';

class NotificationsPage extends StatefulWidget {
  final int profileId; // Seller's profile ID
  const NotificationsPage({super.key, required this.profileId});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final ListingService _listingService =
      ListingService(); // Initialize ListingService
  late Future<List<dynamic>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _fetchNotifications();
  }

  // Fetch notifications from the backend
  Future<List<dynamic>> _fetchNotifications() async {
    try {
      final response =
          await _listingService.fetchSellerNotifications(widget.profileId);
      if (response.isNotEmpty) {
        return response;
      } else {
        return []; // Return an empty list if no notifications
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }

  // Refresh notifications locally
  void _refreshNotifications() {
    setState(() {
      _notificationsFuture = _fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && (snapshot.data?.isNotEmpty ?? false)) {
            final notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final int reservationNo = notification['reservation_no'] ?? 0;
                final String itemName =
                    notification['item_name'] ?? "Unknown Item";
                final String renterName =
                    "${notification['renter_first_name'] ?? 'Unknown'} ${notification['renter_last_name'] ?? ''}";
                final String rentalPeriod =
                    "${notification['start_date'] ?? 'N/A'} to ${notification['end_date'] ?? 'N/A'}";
                final String status = notification['status'] ?? "N/A";
                final String message = (status == "Pending Approval")
                    ? "You have a new rental request for $itemName."
                    : "Rental request for $itemName has been $status.";

                return ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.blue),
                  title: Text(message),
                  subtitle: Text("Renter: $renterName\nPeriod: $rentalPeriod"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    if (status == "Pending Approval") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RentalApprovalPage(
                            reservationNo: reservationNo,
                            onActionCompleted: _refreshNotifications,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgreementTransactionPage(
                            itemName: itemName,
                            renterName: renterName,
                            rentalPeriod: rentalPeriod,
                            rentalPrice: notification['rental_price'] ?? 0.0,
                            totalPrice: notification['total_price'] ?? 0.0,
                            onActionCompleted: _refreshNotifications,
                            agreementId: reservationNo,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          } else {
            return const Center(child: Text("No notifications"));
          }
        },
      ),
    );
  }
}
