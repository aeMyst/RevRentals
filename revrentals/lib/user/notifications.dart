import 'package:flutter/material.dart';


class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: const [
          // MotorcycleCard(
          //   model: 'Yamaha YZF R1',
          //   rentalPrice: 0,
          //   imagePath: 'lib/images/yamaha_r1.png',
          // ),
          // MotorcycleCard(
          //   model: 'Ducati Panigale V4',
          //   rentalPrice: 0,
          //   imagePath: 'lib/images/ducati_panigale.png',
          // ),
          // MotorcycleCard(
          //   model: 'BMW S1000RR',
          //   rentalPrice: 0,
          //   imagePath: 'lib/images/bmw_s1000rr.png',
          // ),
        ],
      ),
    );
  }
}
