import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        children: [
          MotorcycleCard(
            model: 'Kawasaki Ninja ZX-4R',
            rentalPrice: 0,
            imagePath: 'lib/images/ninja_zx4r.png',
          ),
          MotorcycleCard(
            model: 'Honda CRF250R',
            rentalPrice: 0,
            imagePath: 'lib/images/dirtbike.png',
          ),
          MotorcycleCard(
            model: 'Vespa Scooter',
            rentalPrice: 0,
            imagePath: 'lib/images/scooter.png',
          ),
        ],
      ),
    );
  }
}

class MotorcycleCard extends StatelessWidget {
  final String model;
  final double rentalPrice;
  final String imagePath;

  const MotorcycleCard({
    Key? key,
    required this.model,
    required this.rentalPrice,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  height: 100,
                ),
              ),
              SizedBox(height: 10),
              Text(
                model,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Per Hour: \$${rentalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class GaragePage extends StatelessWidget {
  const GaragePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garage'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        children: [
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
