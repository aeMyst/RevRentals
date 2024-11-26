import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'package:revrentals/user/notifications.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:revrentals/user/motorcycle_details.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({Key? key}) : super(key: key);

  void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const AuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs reduced to 3 (without Favorites tab)
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          leading: IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsPage()),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => signUserOut(context),
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DisplayProfileDetailsPage()),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 8),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.grey[200],
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   padding: const EdgeInsets.symmetric(horizontal: 8),
              //   child: const TextField(
              //     decoration: InputDecoration(
              //       hintText: 'Find motorcycle, etc',
              //       border: InputBorder.none,
              //       icon: Icon(Icons.search),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 16),
              // Updated TabBar with 3 tabs (without 'Favorite' tab)
              TabBar(
                tabs: [
                  const Tab(text: 'Motorcycles'),
                  const Tab(text: 'Gear'),
                  const Tab(text: 'Storage Lots'),
                ],
              ),
              const SizedBox(height: 16),
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

// Widget to display motorcycles in each tab
class MotorcycleTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        MotorcycleCard(
          imagePath: 'lib/images/ninja_zx4r.png',
          isFavorite: true,
          model: 'Kawasaki Ninja ZX-4R',
          rentalPrice: 150,
        ),
        MotorcycleCard(
          imagePath: 'lib/images/moped.jpg',
          isFavorite: false,
          model: 'Velocifero TENNIS 4000W',
          rentalPrice: 120,
        ),
        MotorcycleCard(
          imagePath: 'lib/images/dirtbike.png',
          isFavorite: false,
          model: 'Honda CRF250R',
          rentalPrice: 200,
        ),
      ],
    );
  }
}

class MotorcycleCard extends StatefulWidget {
  final String model;
  final double rentalPrice;
  final String imagePath;
  final bool isFavorite;

  MotorcycleCard({
    required this.model,
    required this.rentalPrice,
    required this.imagePath,
    required this.isFavorite,
  });

  @override
  _MotorcycleCardState createState() => _MotorcycleCardState();
}

class _MotorcycleCardState extends State<MotorcycleCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the MotorcycleDetailPage when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MotorcycleDetailPage(
              model: widget.model, // Pass the model to the detail page
              rentalPrice: widget.rentalPrice, // Pass rental price
              imagePath: widget.imagePath, // Pass image path
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Motorcycle image
                Center(
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    height: 100,
                  ),
                ),
                if (widget.isFavorite)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.favorite, color: Colors.red),
                  ),
                const SizedBox(height: 10),
                // Model name
                Text(
                  widget.model,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                // Rental price per hour
                Text(
                  'Per Day: \$${widget.rentalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GearTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: const [
        GearItem(
          imagePath: 'lib/images/agv_pista.webp',
          name: 'AGV Pista GP RR',
          description: '',
          price: 0,
        ),
        GearItem(
          imagePath: 'lib/images/gloves.png',
          name: 'Alpinestars Stella SMX-2 Air Carbon V2',
          description:
              'High-quality leather gloves for comfort and protection.',
          price: 35.50,
        ),
        GearItem(
          imagePath: 'lib/images/jacket.jpg',
          name: 'Alpinestars GPR Plus Jacket',
          description: 'Leather jacket with armor protection.',
          price: 120.99,
        ),
      ],
    );
  }
}

class GearItem extends StatefulWidget {
  final String imagePath;
  final String name;
  final String description;
  final double price;

  const GearItem({
    required this.imagePath,
    required this.name,
    required this.description,
    required this.price,
  });

  @override
  State<GearItem> createState() => _GearItemState();
}

class _GearItemState extends State<GearItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gear image
            Image.asset(
              widget.imagePath,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            // Gear details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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

class LotTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [],
    );
  }
}

// class LotCard extends StatefulWidget {
//   final String lotAddress;
//   final double rentalPrice;
//   final String imagePath;

//   LotCard({
//     required this.lotAddress,
//     required this.rentalPrice,
//     required this.imagePath,
//   })
  
//   @override
//   // ignore: library_private_types_in_public_api
//   _LotCardState createState() => _LotCardState();
// }

// class _LotCardState extends State<LotCard> {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }
