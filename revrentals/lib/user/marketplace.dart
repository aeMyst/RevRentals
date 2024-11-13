import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/pages/auth_page.dart';
import 'package:revrentals/pages/login_page.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:revrentals/utils/utils.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({Key? key}) : super(key: key);

  void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const AuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          actions: [
            IconButton(
              onPressed: () => signUserOut(context),
              icon: Icon(Icons.logout, color: Colors.white),
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.white),
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
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Find motorcycle, etc',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TabBar(
                tabs: [
                  Tab(text: 'Favorite'),
                  Tab(text: 'Recommended'),
                  Tab(text: 'Nearby'),
                  Tab(text: 'Best Models'),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  children: [
                    MotorcycleTab(),
                    MotorcycleTab(),
                    MotorcycleTab(),
                    MotorcycleTab(),
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
          rentalPrice: 0,
        ),
        MotorcycleCard(
          imagePath: 'lib/images/moped.jpg',
          isFavorite: false,
          model: 'Velocifero TENNIS 4000W',
          rentalPrice: 0,
        ),
        MotorcycleCard(
          imagePath: 'lib/images/dirtbike.png',
          isFavorite: false,
          model: 'Honda CRF250R',
          rentalPrice: 0,
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
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite; // Initialize state with the passed value
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite; // Toggle favorite state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 16),
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Motorccycle image
            Center(
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
                height: 100,
              ),
            ),
            // Heart icon
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: toggleFavorite,
                child: Icon(
                  Icons.favorite,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
              ),
            ),
            SizedBox(height:10),
            //Model name
            Text(
              widget.model,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 5),
            //Rental price per hour
            Text(
              'Per Hour: \$${widget.rentalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
           ],
          ),
        ),
      ),
    );
  }

 

}
  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     width: 200,
  //     margin: EdgeInsets.only(right: 16),
  //     child: Card(
  //       color: Colors.white,
  //       elevation: 3,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.all(12.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Motorcycle image
  //             Center(
  //               child: Image.asset(
  //                 imagePath,
  //                 fit: BoxFit.cover,
  //                 height: 100,
  //               ),
  //             ),
  //             if (isFavorite)
  //               Positioned(
  //                 top: 8,
  //                 right: 8,
  //                 child: Icon(Icons.favorite, color: Colors.red),
  //               ),
  //             SizedBox(height: 10),
  //             // Model name
  //             Text(
  //               model,
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 18,
  //               ),
  //             ),
  //             SizedBox(height: 5),
  //             // Rental price per hour
  //             Text(
  //               'Per Hour: \$${rentalPrice.toStringAsFixed(2)}',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             SizedBox(height: 10),

              // Rent button
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Add action for rent button
              //     },
              //     child: Text('Rent Bike'),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.black,
              //     ),
              //   ),
              // ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
 // }
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
// }
// class MotorcycleCard extends StatelessWidget {
//   final String imagePath;
//   final bool isFavorite;

//   MotorcycleCard({required this.imagePath, this.isFavorite = false});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 150,
//       margin: EdgeInsets.only(right: 16),
//       child: Stack(
//         children: [
//           Card(
//               child: Image.asset(imagePath, fit: BoxFit.cover),
//               ),
//           if (isFavorite)
//             Positioned(
//               top: 8,
//               right: 8,
//               child: Icon(Icons.favorite, color: Colors.red),
//             ),
//         ],
//       ),
//     );
//   }
// }
