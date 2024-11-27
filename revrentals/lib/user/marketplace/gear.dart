import 'package:flutter/material.dart';
import 'package:revrentals/user/item_details/gear_details.dart';

// Widget to display motorcycles in each tab
class GearTab extends StatelessWidget {
  const GearTab({super.key});

  void _showFilterDialog(BuildContext context) {
    String selectedGear = 'All';
    String selectedPriceRange = 'Any';
    String selectedBrand = 'Any';
    String selectedSize = 'Any';
    String selectedMaterial = 'Any';

    final List<String> gearType = [
      'All',
      'Helmet',
      'Gloves',
      'Jacket',
      'Boots',
      'Pants',
    ];
    final List<String> priceRanges = [
      'Any',
      'Under \$100',
      'Above \$100',
      'Under \$200',
      'Above \$200'
    ];

    final List<String> brandOptions = [
      'Any',
      'Alpinestars',
      'AGV',
      'Shoei',
      'HJC',
      'Arai',
    ];

    final List<String> materialOptions = [
      'Any',
      'Leather',
      'Plastic',
      'Textile',
      'Kevlar',
    ];

    final List<String> sizeOptions = [
      'Any',
      'X-Small',
      'Small',
      'Medium',
      'Large',
      'X-Large',
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
                    value: selectedGear,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                    ),
                    items: gearType.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGear = newValue!;
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

                  // Dropdown for Insurance
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedBrand,
                    decoration: const InputDecoration(
                      labelText: 'Brand',
                      border: OutlineInputBorder(),
                    ),
                    items: brandOptions.map((String brand) {
                      return DropdownMenuItem<String>(
                        value: brand,
                        child: Text(brand),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBrand = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedSize,
                    decoration: const InputDecoration(
                      labelText: 'Size',
                      border: OutlineInputBorder(),
                    ),
                    items: sizeOptions.map((String size) {
                      return DropdownMenuItem<String>(
                        value: size,
                        child: Text(size),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSize = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Dropdown for Color
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedMaterial,
                    decoration: const InputDecoration(
                      labelText: 'Material',
                      border: OutlineInputBorder(),
                    ),
                    items: materialOptions.map((String material) {
                      return DropdownMenuItem<String>(
                        value: material,
                        child: Text(material),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMaterial = newValue!;
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
                        'Category: $selectedGear, Price Range: $selectedPriceRange');
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
                // TODO: Add filter functionality
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
