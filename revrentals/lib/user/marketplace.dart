import 'package:flutter/material.dart';
import 'package:revrentals/main_pages/auth_page.dart';
import 'package:revrentals/user/item_details/gear_details.dart';
import 'package:revrentals/user/item_details/lot_details.dart';
import 'package:revrentals/user/notifications.dart';
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

// Widget to display motorcycles in each tab
class MotorcycleTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        // Search Bar Row
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Find motorcycle, etc',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Filter and Sort Buttons Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.filter_list, color: Colors.white),
              label: const Text(
                'Filter',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // TODO: Add filter functionality
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Filter Options'),
                      content: const Text('Filter functionality coming soon!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.sort, color: Colors.white),
              label: const Text(
                'Sort',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // TODO: Add sort functionality
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Sort Options'),
                      content: const Text('Sort functionality coming soon!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Motorcycle List
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              MotorcycleCard(
                imagePath: 'lib/images/motorcycle/ninja_zx4r.png',
                isFavorite: true,
                model: 'Kawasaki Ninja ZX-4R',
                rentalPrice: 150,
              ),
              MotorcycleCard(
                imagePath: 'lib/images/motorcycle/scooter.png',
                isFavorite: false,
                model: 'Velocifero TENNIS 4000W',
                rentalPrice: 120,
              ),
              MotorcycleCard(
                imagePath: 'lib/images/motorcycle/dirtbike.png',
                isFavorite: false,
                model: 'Honda CRF250R',
                rentalPrice: 200,
              ),
            ],
          ),
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

  const MotorcycleCard({
    super.key,
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
      child: SizedBox(
        width: 200,
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
                    height: 150,
                  ),
                ),
                if (widget.isFavorite)
                  const Positioned(
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

// Widget to display motorcycles in each tab
class GearTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        // Search Bar Row
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Find motorcycle, etc',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Filter and Sort Buttons Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.filter_list, color: Colors.white),
              label: const Text(
                'Filter',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // TODO: Add filter functionality
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Filter Options'),
                      content: const Text('Filter functionality coming soon!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.sort, color: Colors.white),
              label: const Text(
                'Sort',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // TODO: Add sort functionality
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Sort Options'),
                      content: const Text('Sort functionality coming soon!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Motorcycle List
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              GearItem(
                imagePath: 'lib/images/gear/agv_pista.webp',
                name: 'AGV Pista GP RR',
                description: '',
                rentalPrice: 100.0,
              ),
              GearItem(
                imagePath: 'lib/images/gear/gloves.png',
                name: 'Alpinestars Stella SMX-2 Air Carbon V2',
                description:
                    'High-quality leather gloves for comfort and protection.',
                rentalPrice: 35.50,
              ),
              GearItem(
                imagePath: 'lib/images/gear/jacket.jpg',
                name: 'Alpinestars GPR Plus Jacket',
                description: 'Leather jacket with armor protection.',
                rentalPrice: 120.99,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GearItem extends StatefulWidget {
  final String imagePath;
  final String name;
  final String description;
  final double rentalPrice;

  const GearItem({
    super.key,
    required this.name,
    required this.rentalPrice,
    required this.imagePath,
    required this.description,
  });

  @override
  State<GearItem> createState() => _GearItemState();
}

class _GearItemState extends State<GearItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the GearDetailPage when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GearDetailPage(
              imagePath: widget.imagePath,
              name: widget.name,
              description: widget.description,
              rentalPrice: widget.rentalPrice,
            ),
          ),
        );
      },
      child: SizedBox(
        width: 200,
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
                // Gear image
                Center(
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 10),
                // Gear name
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                // Rental price per day
                Text(
                  'Per Day: \$${widget.rentalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                // Description (if available)
                if (widget.description.isNotEmpty)
                  Text(
                    widget.description,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget to display motorcycles in each tab
class LotTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        // Search Bar Row
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Find motorcycle, etc',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Filter and Sort Buttons Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.filter_list, color: Colors.white),
              label: const Text(
                'Filter',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // TODO: Add filter functionality
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Filter Options'),
                      content: const Text('Filter functionality coming soon!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.sort, color: Colors.white),
              label: const Text(
                'Sort',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // TODO: Add sort functionality
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Sort Options'),
                      content: const Text('Sort functionality coming soon!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Motorcycle List
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: const [
              LotCard(
                  lotAddress: 'Example Lot 1',
                  rentalPrice: 25.0,
                  imagePath: 'lib/images/lots/public_parking.png',
                  description: ''),
              LotCard(
                  lotAddress: 'Example Lot 2',
                  rentalPrice: 50.0,
                  imagePath: 'lib/images/lots/outdoor_parking.png',
                  description: ''),
              LotCard(
                  lotAddress: 'Example Lot 3',
                  rentalPrice: 75.0,
                  imagePath: 'lib/images/lots/big_parking.png',
                  description: ''),
              LotCard(
                  lotAddress: 'Example Lot 4',
                  rentalPrice: 100.0,
                  imagePath: 'lib/images/lots/parking_garage.png',
                  description: ''),
              LotCard(
                  lotAddress: 'Example Lot 5',
                  rentalPrice: 150.0,
                  imagePath: 'lib/images/lots/storage_units.png',
                  description: ''),
            ],
          ),
        ),
      ],
    );
  }
}

class LotCard extends StatefulWidget {
  final String lotAddress;
  final String description;
  final double rentalPrice;
  final String imagePath;

  const LotCard({
    super.key,
    required this.lotAddress,
    required this.rentalPrice,
    required this.imagePath,
    required this.description,
  });

  @override
  State<LotCard> createState() => _LotCardState();
}

class _LotCardState extends State<LotCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to LotDetailsPage with the passed details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LotDetailsPage(
              lotAddress: widget.lotAddress,
              description: widget.description,
              rentalPrice: widget.rentalPrice,
              imagePath: widget.imagePath,
            ),
          ),
        );
      },
      child: SizedBox(
        width: 200,
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
                Center(
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.lotAddress,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                // Rental price per day
                Text(
                  'Per Day: \$${widget.rentalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                // Description (if available)
                if (widget.description.isNotEmpty)
                  Text(
                    widget.description,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
