import 'package:flutter/material.dart';
import 'package:revrentals/user/item_details/gear/gear.dart';
import 'package:revrentals/user/notifications/notifications.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:revrentals/user/item_details/motorcycle/motorcycle.dart';
import 'package:revrentals/user/item_details/lot/lot.dart';
import 'package:revrentals/services/listing_service.dart';
import 'package:revrentals/main_pages/login_page.dart';

class MarketplacePage extends StatefulWidget {
  final int profileId;
  final Map<String, dynamic>? userData;

  const MarketplacePage({super.key, required this.profileId, this.userData});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final ListingService _listingService = ListingService();
  late Future<List<dynamic>> _motorcyclesFuture;
  late Future<List<dynamic>> _gearFuture;
  late Future<List<dynamic>> _storageLotsFuture;

  bool hasUnreadNotifications = false; // Track unread notifications

  @override
  void initState() {
    super.initState();
    _motorcyclesFuture = _listingService.fetchMotorizedVehicles();
    _gearFuture = _listingService.fetchGearItems();
    _storageLotsFuture = _listingService.fetchStorageLots();
    _checkNotifications();
  }

  Future<void> _checkNotifications() async {
    try {
      final hasNotifications =
          await _listingService.checkNotifications(widget.profileId);
      setState(() {
        hasUnreadNotifications = hasNotifications;
      });
    } catch (e) {
      print("Error checking notifications: $e");
    }
  }

  void _onNotificationsOpened() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationsPage(profileId: widget.profileId),
      ),
    );

    _checkNotifications(); // Refresh notifications after page visit
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                if (hasUnreadNotifications)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _onNotificationsOpened,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    ),
                    (route) => false);
              },
              icon: const Icon(Icons.logout),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayProfileDetailsPage(
                    profileId: widget.profileId,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TabBar(
                labelColor: Colors.blueGrey,
                indicatorColor: Colors.blueGrey,
                indicatorPadding: EdgeInsets.only(bottom: 8),
                tabs: [
                  Tab(text: 'Motorcycles'),
                  Tab(text: 'Gear'),
                  Tab(text: 'Storage Lots'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    MotorcycleTab(
                      profileId: widget.profileId,
                      motorcyclesFuture: _motorcyclesFuture,
                    ),
                    GearTab(
                      profileId: widget.profileId,
                      gearFuture: _gearFuture,
                    ),
                    LotTab(
                      profileId: widget.profileId,
                      storageLotsFuture: _storageLotsFuture,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
