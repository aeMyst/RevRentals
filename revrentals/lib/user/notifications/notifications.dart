import 'package:flutter/material.dart';
import 'package:revrentals/user/notifications/agreement_transaction.dart';
import 'package:revrentals/user/notifications/rental_approval.dart';
import 'package:revrentals/services/listing_service.dart';

class NotificationsPage extends StatefulWidget {
  final int profileId;

  const NotificationsPage({super.key, required this.profileId});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final ListingService _listingService = ListingService();
  late Future<List<dynamic>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _fetchNotifications();
  }

  Future<List<dynamic>> _fetchNotifications() async {
    try {
      final sellerNotifications = await _listingService.fetchSellerNotifications(widget.profileId);
      final buyerNotifications = await _listingService.fetchBuyerNotifications(widget.profileId);
      
      // Mark seller notifications
      final markedSellerNotifications = sellerNotifications.map((notification) => {
        ...notification,
        'is_seller': true,
      }).toList();
      
      // Mark buyer notifications
      final markedBuyerNotifications = buyerNotifications.map((notification) => {
        ...notification,
        'is_seller': false,
      }).toList();
      
      return [...markedSellerNotifications, ...markedBuyerNotifications];
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      _notificationsFuture = _fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: FutureBuilder<List<dynamic>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final int reservationNo = notification['reservation_no'];
                final String itemName = notification['item_name'] ?? "Unknown Item";
                final String status = notification['status'] ?? "Unknown";
                final bool isSeller = notification['is_seller'] ?? false;
                final String renterName = notification.containsKey('renter_first_name') &&
                        notification.containsKey('renter_last_name')
                    ? "${notification['renter_first_name']} ${notification['renter_last_name']}"
                    : "N/A";
                final String rentalPeriod =
                    "${notification['start_date']} to ${notification['end_date']}";
                final double rentalPrice = (notification['rental_price'] ?? 0.0).toDouble();
                final double totalPrice = (notification['total_price'] ?? 0.0).toDouble();

                return ListTile(
                  leading: Icon(
                    status == "Pending Approval"
                        ? Icons.pending
                        : status == "Approved"
                            ? Icons.check_circle
                            : Icons.cancel,
                    color: status == "Pending Approval"
                        ? Colors.orange
                        : status == "Approved"
                            ? Colors.green
                            : Colors.red,
                  ),
                  title: Text(
                    status == "Rejected"
                        ? "Request for $itemName was rejected"
                        : "Rental request for $itemName",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Renter: $renterName\nPeriod: $rentalPeriod\nStatus: $status"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    if (status == "Pending Approval" && isSeller) {
                      // Only sellers see the approval page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RentalApprovalPage(
                            reservationNo: reservationNo,
                            onActionCompleted: _refreshNotifications,
                          ),
                        ),
                      );
                    } else if (status == "Approved" && !isSeller) {
                      // Only buyers see the transaction page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgreementTransactionPage(
                            itemName: itemName,
                            renterName: renterName,
                            rentalPeriod: rentalPeriod,
                            rentalPrice: rentalPrice,
                            totalPrice: totalPrice,
                            onActionCompleted: _refreshNotifications,
                            agreementId: reservationNo,
                          ),
                        ),
                      );
                    } else if (status == "Rejected") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "The request for $itemName was rejected. Tap to dismiss."),
                          action: SnackBarAction(
                            label: "Dismiss",
                            onPressed: () {
                              _listingService
                                  .deleteReservation(reservationNo)
                                  .then((_) => _refreshNotifications());
                            },
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          } else {
            return const Center(child: Text("No notifications."));
          }
        },
      ),
    );
  }
}