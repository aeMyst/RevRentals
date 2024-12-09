import 'package:flutter/material.dart';
import 'package:revrentals/services/listing_service.dart';
import 'package:revrentals/user/garage/maint_records.dart';
import 'package:revrentals/regex/listing_regex.dart';
import 'package:revrentals/user/user_home.dart';

class AddListingPage extends StatefulWidget {
  final int profileId;
  final Map<String, dynamic>? userData;

  const AddListingPage(
      {super.key, required this.profileId, required this.userData});

  @override
  _AddListingPageState createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  final ListingService _listingService = ListingService();
  bool isMotorcycleSelected = true;

  // Controllers for motorized vehicle
  final TextEditingController modelController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController insuranceController = TextEditingController();
  final TextEditingController vinController = TextEditingController();
  final TextEditingController registrationController = TextEditingController();
  final TextEditingController rentalPriceController = TextEditingController();
  final TextEditingController specificAttributeController =
      TextEditingController();

// Gear controllers
  final TextEditingController gearSizeController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController materialController = TextEditingController();
  final TextEditingController gearNameController = TextEditingController();

  String? selectedMotorcycleType = 'Motorcycle';
  String? selectedGearType = 'Helmet';
  String? selectedInsuranceType = 'Basic';
  //String vehicleAttributeLabel = 'Engine Type';
  String? selectedColor = 'Other';
  String? selectedSize = 'Any';
  String? selectedBrand = 'Any';
  String? selectedMaterial = 'Any';

  String? selectedSpecificAttribute;
  String? vehicleAttributeLabel = 'Vehicle Type First';
  List<String> specificAttributeOptions = [];

  Future<void> _addListing() async {
    String? mileageError;
    String? rentalPriceError;

    if (isMotorcycleSelected) {
      if (mileageController.text.isEmpty ||
          int.tryParse(mileageController.text) == null ||
          int.parse(mileageController.text) <= 0) {
        mileageError = "Mileage must be a positive integer.";
      }

      if (rentalPriceController.text.isEmpty ||
          double.tryParse(rentalPriceController.text) == null ||
          double.parse(rentalPriceController.text) <= 0) {
        rentalPriceError = "Rental price must be a positive number.";
      }
    } else {
      if (rentalPriceController.text.isEmpty ||
          double.tryParse(rentalPriceController.text) == null ||
          double.parse(rentalPriceController.text) <= 0) {
        rentalPriceError = "Rental price must be a positive number.";
      }
    }
    // If there's an error, show it and return early
    if (mileageError != null || rentalPriceError != null) {
      _showErrorDialog(mileageError ?? rentalPriceError!);
      return;
    }
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Fetch the garage ID based on the profile ID
      int garageId = await _listingService.fetchGarageId(widget.profileId);

      if (isMotorcycleSelected) {
        // Validate inputs
        String? vinError = Validators.validateVIN(vinController.text.trim());
        String? registrationError =
            Validators.validateRegistration(registrationController.text.trim());

        if (vinError != null || registrationError != null) {
          _showErrorDialog(vinError ?? registrationError!);
          return; // Exit if there are validation errors
        }
        // Prepare motorized vehicle data
        Map<String, dynamic> listingData = {
          "garage_id": garageId,
          "vehicle_type": selectedMotorcycleType,
          "vin": vinController.text,
          "registration": registrationController.text,
          "rental_price": double.parse(rentalPriceController.text),
          "color": selectedColor,
          "mileage": int.parse(mileageController.text),
          "insurance": selectedInsuranceType,
          "model": modelController.text,
          "specific_attribute": specificAttributeController.text,
        };

        // Add motorized vehicle listing
        final Map<String, dynamic> response =
            await _listingService.addListing(listingData);

        if (response.containsKey('error')) {
          Navigator.pop(context); // Close loading dialog
          _showErrorDialog(response['error']); // Show error message
          return;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Listing added successfully!')),
          );

          // Now that the VIN is valid, pass it to the MaintenanceRecordsPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MaintenanceRecordsPage(
                vin: vinController.text,
                profileId: widget.profileId,
                userData: widget.userData,
              ),
            ),
          );
        }
      } else {
        // Prepare gear data
        Map<String, dynamic> listingData = {
          "garage_id": garageId,
          "gear_name": gearNameController.text,
          "brand": selectedBrand,
          "material": selectedMaterial,
          "type": selectedGearType,
          "size": selectedSize,
          "rental_price": double.parse(rentalPriceController.text),
        };

        // Add gear listing
        final Map<String, dynamic> response =
            await _listingService.addGearListing(listingData);

        if (response.containsKey('error')) {
          Navigator.pop(context); // Close loading dialog
          _showErrorDialog(response['error']); // Show error message
          return;
        }
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing added successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding listing: $e')),
      );
      Navigator.pop(context);
    }
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
              constraints: const BoxConstraints(minHeight: 50, minWidth: 100),
              children: const [
                Text('Motorized Vehicle'),
                Text('Gear'),
              ],
            ),
            const SizedBox(height: 16),

            // Conditional form fields
            if (isMotorcycleSelected) ...[
              DropdownButtonFormField<String>(
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
                    /*vehicleAttributeLabel = value == 'Motorcycle'
                        ? 'Engine Type'
                        : value == 'Moped'
                            ? 'Cargo Rack'
                            : 'Terrain Type';*/

                    if (value == 'Motorcycle') {
                      vehicleAttributeLabel = 'Engine Type';
                      specificAttributeOptions = [
                        'Parallel-Twin',
                        'Single',
                        'Inline-Three',
                        'Inline-Four',
                        'V-Twin',
                        'L-Twin',
                        'V4',
                        'Flat-Twins'
                      ];
                    } else if (value == 'Moped') {
                      vehicleAttributeLabel = '# of Cargo Racks';
                      specificAttributeOptions = ['0', '1'];
                    } else if (value == 'Dirtbike') {
                      vehicleAttributeLabel = 'Dirtbike Type';
                      specificAttributeOptions = [
                        'Off-Road',
                        'Trail',
                        'Motocross',
                        'Enduro',
                        'Dual-Sport',
                        'Adventure',
                        'Hill-Climb'
                      ];
                    } else {
                      specificAttributeOptions = [];
                      vehicleAttributeLabel = null;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a valid option!'),
                        ),
                      );
                    }
                    selectedSpecificAttribute = null;
                  });
                },
              ),

              /* TextField(
                controller: specificAttributeController,
                decoration: InputDecoration(labelText: vehicleAttributeLabel),
              ),*/

              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedSpecificAttribute,
                decoration: InputDecoration(
                    labelText: 'Select ${vehicleAttributeLabel}'),
                items: specificAttributeOptions
                    .map((attribute) => DropdownMenuItem(
                          value: attribute,
                          child: Text(attribute),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSpecificAttribute = value;
                  });
                },
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
                decoration: const InputDecoration(labelText: 'Vehicle Name'),
              ),

              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedColor,
                decoration: const InputDecoration(labelText: 'Color'),
                items: const [
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                  DropdownMenuItem(value: 'Red', child: Text('Red')),
                  DropdownMenuItem(value: 'Orange', child: Text('Orange')),
                  DropdownMenuItem(value: 'Yellow', child: Text('Yellow')),
                  DropdownMenuItem(value: 'Green', child: Text('Green')),
                  DropdownMenuItem(value: 'Blue', child: Text('Blue')),
                  DropdownMenuItem(value: 'Purple', child: Text('Purple')),
                  DropdownMenuItem(value: 'Pink', child: Text('Pink')),
                  DropdownMenuItem(value: 'Black', child: Text('Black')),
                  DropdownMenuItem(value: 'White', child: Text('White')),
                  DropdownMenuItem(
                      value: 'Multicolor', child: Text('Multicolor')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedColor = value; // Update variable on selection
                    print(selectedColor);
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: mileageController,
                decoration: const InputDecoration(labelText: 'Mileage'),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedInsuranceType,
                decoration: const InputDecoration(labelText: 'Insurance Type'),
                items: const [
                  DropdownMenuItem(value: 'Basic', child: Text('Basic')),
                  DropdownMenuItem(value: 'Premium', child: Text('Premium')),
                  DropdownMenuItem(
                      value: 'Comprehensive', child: Text('Comprehensive')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedInsuranceType =
                        value; // Update variable on selection
                    print(selectedInsuranceType);
                  });
                },
              ),

              const SizedBox(height: 16),
              TextField(
                controller: rentalPriceController,
                decoration: const InputDecoration(labelText: 'Rental Price Per Day'),
                
                keyboardType: TextInputType.number,
              ),

            ] else ...[
              DropdownButtonFormField<String>(
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
                    // If Helmet or Boots are selected, set material to Kevlar and disable material selection
                    if (selectedGearType == 'Helmet' ||
                        selectedGearType == 'Boots') {
                      selectedMaterial = 'Kevlar';
                    } else {
                      selectedMaterial =
                          'Any'; // Reset to default material selection
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: gearNameController,
                decoration: const InputDecoration(labelText: 'Gear Name'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedBrand,
                decoration: const InputDecoration(labelText: 'Brand'),
                items: const [
                  DropdownMenuItem(value: 'Any', child: Text('Any')),
                  DropdownMenuItem(
                      value: 'Alpinestars', child: Text('Alpinestars')),
                  DropdownMenuItem(value: 'AGV', child: Text('AGV')),
                  DropdownMenuItem(value: 'Shoei', child: Text('Shoei')),
                  DropdownMenuItem(value: 'HJC', child: Text('HJC')),
                  DropdownMenuItem(value: 'Arai', child: Text('Arai')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedBrand = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedMaterial,
                decoration: const InputDecoration(labelText: 'Material'),
                items: const [
                  DropdownMenuItem(value: 'Any', child: Text('Any')),
                  DropdownMenuItem(value: 'Leather', child: Text('Leather')),
                  DropdownMenuItem(value: 'Plastic', child: Text('Plastic')),
                  DropdownMenuItem(value: 'Textile', child: Text('Textile')),
                  DropdownMenuItem(value: 'Kevlar', child: Text('Kevlar')),
                ],
                onChanged: (selectedGearType == 'Helmet' ||
                        selectedGearType == 'Boots')
                    ? null // Disable the dropdown if the gear is Helmet or Boots
                    : (value) {
                        setState(() {
                          selectedMaterial = value;
                        });
                      },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedSize,
                decoration: const InputDecoration(labelText: 'Gear Size'),
                items: const [
                  DropdownMenuItem(value: 'Any', child: Text('Any')),
                  DropdownMenuItem(value: 'XS', child: Text('XS')),
                  DropdownMenuItem(value: 'S', child: Text('S')),
                  DropdownMenuItem(value: 'M', child: Text('M')),
                  DropdownMenuItem(value: 'L', child: Text('L')),
                  DropdownMenuItem(value: 'XL', child: Text('XL')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedSize = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: rentalPriceController,
                decoration: const InputDecoration(labelText: 'Rental Price Per Day'),
                keyboardType: TextInputType.number,
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addListing,
              child: const Text('Add Listing'),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
