 import 'package:flutter/material.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'package:revrentals/user/item_details/gear_details.dart';
import 'package:revrentals/user/item_details/lot_details.dart';
import 'package:revrentals/user/marketplace/gear.dart';
import 'package:revrentals/user/marketplace/lot.dart';
import 'package:revrentals/user/marketplace/motorcycle.dart';
import 'package:revrentals/user/notifications/notifications.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:revrentals/user/item_details/motorcycle/motorcycle_details.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  void signUserOut(BuildContext context) {
    // FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsPage()),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => signUserOut(context),
              icon: const Icon(Icons.logout),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DisplayProfileDetailsPage()),
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
              // const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  children: [
                    MotorcycleTab(),
                    GearTab(),
                    LotTab(),
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



