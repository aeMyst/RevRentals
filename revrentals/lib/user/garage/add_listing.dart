import 'package:flutter/material.dart';
import 'package:revrentals/services/listing_service.dart';

class AddListingPage extends StatefulWidget {
  final int profileId;

  const AddListingPage({super.key, required this.profileId});

  @override
  _AddListingPageState createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  final ListingService _listingService = ListingService();
  bool isMotorcycleSelected = true;

  // Controllers for text fields
  final TextEditingController modelController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController insuranceController = TextEditingController();
  final TextEditingController vinController = TextEditingController();
  final TextEditingController registrationController = TextEditingController();
  final TextEditingController rentalPriceController = TextEditingController();
  final TextEditingController specificAttributeController =
      TextEditingController();
  
  final TextEditingController gearSizeController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController materialController = TextEditingController();
  final TextEditingController gearNameController = TextEditingController();

  String? selectedMotorcycleType = 'Motorcycle';
  String? selectedGearType = 'Helmet';
  String vehicleAttributeLabel = 'Engine Type';

  Future<void> _addListing() async {
    try {
      // Fetch the garage ID based on the profile ID
      int garageId = await _listingService.fetchGarageId(widget.profileId);

      if (isMotorcycleSelected) {
        // Prepare motorized vehicle data
        Map<String, dynamic> listingData = {
          "garage_id": garageId,
          "vehicle_type": selectedMotorcycleType,
          "vin": vinController.text,
          "registration": registrationController.text,
          "rental_price": double.parse(rentalPriceController.text),
          "color": colorController.text,
          "mileage": int.parse(mileageController.text),
          "insurance": insuranceController.text,
          "model": modelController.text,
          "specific_attribute": specificAttributeController.text,
        };

        // Add motorized vehicle listing
        await _listingService.addListing(listingData);
      } else {
        // Prepare gear data
        Map<String, dynamic> listingData = {
          "garage_id": garageId,
          "gear_name": gearNameController.text,
          "brand": brandController.text,
          "material": materialController.text,
          "type": selectedGearType,
          "size": gearSizeController.text,
          "rental_price": double.parse(rentalPriceController.text),
        };

        // Add gear listing
        await _listingService.addListing(listingData);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing added successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding listing: $e')),
      );
    }
  }

// Method to show an error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    modelController.dispose();
    colorController.dispose();
    mileageController.dispose();
    insuranceController.dispose();
    vinController.dispose();
    registrationController.dispose();
    rentalPriceController.dispose();
    specificAttributeController.dispose();
    gearSizeController.dispose();
    brandController.dispose();
    materialController.dispose();
    gearNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Listing"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Toggle between Motorized Vehicle and Gear
            ToggleButtons(
              isSelected: [isMotorcycleSelected, !isMotorcycleSelected],
              onPressed: (index) {
                setState(() {
                  isMotorcycleSelected = index == 0;
                });
              },
              splashColor: Colors.blueGrey.withOpacity(0.5),
              color: Colors.grey,
              selectedColor: Colors.blueGrey,
              fillColor: Colors.blueGrey.withOpacity(0.2),
              borderColor: Colors.blueGrey,
              borderRadius: BorderRadius.circular(10),
              constraints: const BoxConstraints(minHeight: 50, minWidth: 100),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Motorcycle', textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text('Gear', textAlign: TextAlign.center),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Conditional form fields
            if (isMotorcycleSelected) ...[
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: selectedMotorcycleType,
                decoration: const InputDecoration(labelText: 'Vehicle Type'),
                items: const [
                  DropdownMenuItem(
                      value: 'Motorcycle', child: Text('Motorcycle')),
                  DropdownMenuItem(value: 'Moped', child: Text('Moped')),
                  DropdownMenuItem(value: 'Dirtbike', child: Text('Dirtbike')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedMotorcycleType = value;
                    vehicleAttributeLabel = value == 'Motorcycle'
                        ? 'Engine Type'
                        : value == 'Moped'
                            ? 'Cargo Rack'
                            : 'Terrain Type';
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: specificAttributeController,
                decoration: InputDecoration(labelText: vehicleAttributeLabel),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: vinController,
                decoration: const InputDecoration(labelText: 'VIN'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: registrationController,
                decoration: const InputDecoration(labelText: 'Registration'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: modelController,
                decoration: const InputDecoration(labelText: 'Model'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: colorController,
                decoration: const InputDecoration(labelText: 'Color'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: mileageController,
                decoration: const InputDecoration(labelText: 'Mileage'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: insuranceController,
                decoration: const InputDecoration(labelText: 'Insurance'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: rentalPriceController,
                decoration: const InputDecoration(labelText: 'Rental Price'),
                keyboardType: TextInputType.number,
              ),
            ] else ...[
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: selectedGearType,
                decoration: const InputDecoration(labelText: 'Gear Type'),
                items: const [
                  DropdownMenuItem(value: 'Helmet', child: Text('Helmet')),
                  DropdownMenuItem(value: 'Gloves', child: Text('Gloves')),
                  DropdownMenuItem(value: 'Jacket', child: Text('Jacket')),
                  DropdownMenuItem(value: 'Boots', child: Text('Boots')),
                  DropdownMenuItem(value: 'Pants', child: Text('Pants')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGearType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: gearNameController,
                decoration: const InputDecoration(labelText: 'Gear Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: brandController,
                decoration: const InputDecoration(labelText: 'Brand'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: materialController,
                decoration: const InputDecoration(labelText: 'Material'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: gearSizeController,
                decoration: const InputDecoration(labelText: 'Size'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: rentalPriceController,
                decoration: const InputDecoration(labelText: 'Rental Price'),
                keyboardType: TextInputType.number,
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Collect values from the text fields
                String model = modelController.text;
                String rentalPrice = rentalPriceController.text;
                // String imagePath = imagePathController.text;
                String gearType = gearSizeController.text;
                // Check if fields are filled out for either motorcycle or gear
                if (isMotorcycleSelected) {
                  // Validate motorcycle fields
                  if (model.isEmpty ||
                      rentalPrice.isEmpty ||
                      // imagePath.isEmpty ||
                      colorController.text.isEmpty ||
                      vinController.text.isEmpty ||
                      mileageController.text.isEmpty ||
                      insuranceController.text.isEmpty ||
                      registrationController.text.isEmpty) {
                    // Show an error message if any required fields are empty
                    _showErrorDialog(
                        'Please fill out all fields for the motorcycle.');
                    return;
                  } else {
                    _addListing();
                  }
                } else {
                  // Validate gear fields
                  if (gearType.isEmpty ||
                      rentalPrice.isEmpty ||
                      // imagePath.isEmpty ||
                      gearSizeController.text.isEmpty ||
                      brandController.text.isEmpty ||
                      materialController.text.isEmpty) {
                    // Show an error message if any required fields are empty
                    _showErrorDialog(
                        'Please fill out all fields for the gear.');
                    return;
                  } else {
                    _addListing();
                  }
                }
              },
              child: const Text('Add Listing'),
            ),
          ],
        ),
      ),
    );
  }
}
