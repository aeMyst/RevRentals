import 'package:flutter/material.dart';
import 'package:revrentals/user/item_details/motorcycle/motorcycle_details.dart';

// Widget to display motorcycles in each tab
class MotorcycleTab extends StatelessWidget {
  const MotorcycleTab({super.key});

  void _showFilterDialog(BuildContext context) {
    String selectedVehicle = 'All';
    String selectedPriceRange = 'Any';
    String selectedInsurance = 'Any';
    String selectedMileage = 'Any';
    String selectedColor = 'Any';

    final List<String> vehicleType = [
      'All',
      'Motorcycles',
      'Dirtbike',
      'Moped'
    ];
    final List<String> priceRanges = [
      'Any',
      'Under \$100',
      'Above \$100',
      'Under \$200',
      'Above \$200'
    ];
    final List<String> insuranceOptions = [
      'Any',
      'Basic',
      'Premium',
      'Comprehensive'
    ];
    final List<String> colorOptions = [
      'Any',
      'Red',
      'Orange',
      'Yellow',
      'Green',
      'Blue',
      'Purple',
      'Pink',
      'Black',
      'White',
      'Other',
    ];

    final List<String> mileageOptions = [
      'Any',
      'Under 10,000 km',
      '10,000 - 50,000 km',
      'Above 50,000 km'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Filter Options'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dropdown for Category
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedVehicle,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                    ),
                    items: vehicleType.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedVehicle = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Dropdown for Price Range
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedPriceRange,
                    decoration: const InputDecoration(
                      labelText: 'Price Range',
                      border: OutlineInputBorder(),
                    ),
                    items: priceRanges.map((String range) {
                      return DropdownMenuItem<String>(
                        value: range,
                        child: Text(range),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPriceRange = newValue!;
                      });
                    },
                  ),

                  const SizedBox(height: 16),
                  // Dropdown for Color
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedColor,
                    decoration: const InputDecoration(
                      labelText: 'Color',
                      border: OutlineInputBorder(),
                    ),
                    items: colorOptions.map((String color) {
                      return DropdownMenuItem<String>(
                        value: color,
                        child: Text(color),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedColor = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedMileage,
                    decoration: const InputDecoration(
                      labelText: 'Mileage',
                      border: OutlineInputBorder(),
                    ),
                    items: mileageOptions.map((String mileage) {
                      return DropdownMenuItem<String>(
                        value: mileage,
                        child: Text(mileage),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMileage = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Dropdown for Insurance
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedInsurance,
                    decoration: const InputDecoration(
                      labelText: 'Insurance',
                      border: OutlineInputBorder(),
                    ),
                    items: insuranceOptions.map((String insurance) {
                      return DropdownMenuItem<String>(
                        value: insurance,
                        child: Text(insurance),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedInsurance = newValue!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle the filter logic here
                    print(
                        'Category: $selectedVehicle, Price Range: $selectedPriceRange');
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSortDialog(BuildContext context) {
    String selectedSortOption = 'None';
    final List<String> sortOptions = [
      'None',
      'Price: Low to High',
      'Price: High to Low',
      'Newest First'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Sort Options'),
              content: DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: selectedSortOption,
                decoration: const InputDecoration(
                  labelText: 'Sort By',
                  border: OutlineInputBorder(),
                ),
                items: sortOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSortOption = newValue!;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle the sort logic here
                    print('Sort Option: $selectedSortOption');
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        // Filter and Sort Buttons Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.filter_list),
              label: const Text(
                'Filter',
              ),
              onPressed: () {
                _showFilterDialog(context);
              },
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.sort),
              label: const Text(
                'Sort',
              ),
              onPressed: () {
                // TODO: Add sort functionality
                _showSortDialog(context);
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
