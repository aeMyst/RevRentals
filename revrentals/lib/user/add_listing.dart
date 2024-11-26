import 'package:flutter/material.dart';

class AddListingPage extends StatefulWidget {
  const AddListingPage({super.key});

  @override
  _AddListingPageState createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  bool isMotorcycleSelected = true; // Initial selection for motorcycle

  // Controllers for text fields
  final TextEditingController modelController = TextEditingController();
  final TextEditingController colorControler = TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController insuranceController = TextEditingController();
  final TextEditingController vinController = TextEditingController();
  final TextEditingController registrationController = TextEditingController();
  final TextEditingController vehicleAttributeController =
      TextEditingController();

  final TextEditingController gearSizeController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController materialController = TextEditingController();

  final TextEditingController rentalPriceController = TextEditingController();
  final TextEditingController imagePathController = TextEditingController();

  // Dropdown field
  String? selectedMotorcycleType = 'Motorcycle'; // Default selected value
  String? selectedGearType = 'Helmet';
  String vehicleAttributeLabel = '';

  @override
  void dispose() {
    modelController.dispose();
    rentalPriceController.dispose();
    imagePathController.dispose();
    gearSizeController.dispose();
    vehicleAttributeController.dispose();
    super.dispose();
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

  void _showSavedListing(String model, String rentalPrice, String imagePath) {
    // Display a dialog with the saved listing information
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Listing Saved"),
          content: Text('Model: $model\n'
              'Motorcycle Type: $selectedMotorcycleType\n'
              'Rental Price: $rentalPrice\n'
              'Image Path: $imagePath\n'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: const Text("Add Listing"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Wrap everything in SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Toggle buttons for selecting between Gear and Motorcycle
            Center(
              // Center the ToggleButtons widget within the available space
              child: ToggleButtons(
                isSelected: [isMotorcycleSelected, !isMotorcycleSelected],
                onPressed: (int index) {
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
                constraints: const BoxConstraints(minHeight: 50),
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
            ),
            const SizedBox(height: 16),

            // Conditional form based on selected toggle
            if (isMotorcycleSelected) ...[
              const SizedBox(height: 16),
              // Dropdown for motorcycle type
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: selectedMotorcycleType,
                decoration: const InputDecoration(
                  labelText: 'Motorcycle Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Motorcycle',
                    child: Text('Motorcycle'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Moped',
                    child: Text('Moped'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Dirtbike',
                    child: Text('Dirtbike'),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMotorcycleType = newValue;

                    // Update attribute based on type selected
                    if (newValue == 'Motorcycle') {
                      vehicleAttributeLabel = 'Engine Type';
                      vehicleAttributeController.text =
                          'Enter the engine type';
                    } else if (newValue == 'Moped') {
                      vehicleAttributeLabel = 'Cargo Rack';
                      vehicleAttributeController.text =
                          'Enter the cargo rack type';
                    } else if (newValue == 'Dirtbike') {
                      vehicleAttributeLabel = 'Terrain Type';
                      vehicleAttributeController.text =
                          'Enter the terrain type';
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              // Extra attribute field
              TextField(
                controller: vehicleAttributeController,
                decoration: InputDecoration(
                    labelText: vehicleAttributeLabel,
                    hintText: vehicleAttributeController.text.isEmpty
                        ? 'Select a motorcycle type to see details'
                        : vehicleAttributeController.text,
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 3, color: Colors.blueGrey))),
              ),
              const SizedBox(height: 16),

              // VIN form fields
              TextField(
                controller: vinController,
                decoration: const InputDecoration(
                  labelText: 'VIN',
                  hintText: 'Enter VIN',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Motorcycle form fields
              TextField(
                controller: modelController,
                decoration: const InputDecoration(
                  labelText: 'Model',
                  hintText: 'Enter motorcycle model (Year, Brand, Name)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Color form field
              TextField(
                controller: colorControler,
                decoration: const InputDecoration(
                  labelText: 'Color',
                  hintText: 'Enter color',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Rental price form field
              TextField(
                controller: rentalPriceController,
                decoration: const InputDecoration(
                  labelText: 'Rental Price',
                  hintText: 'Enter rental price per day',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              // Mileage form field
              TextField(
                controller: mileageController,
                decoration: const InputDecoration(
                  labelText: 'Mileage',
                  hintText: 'Enter mileage',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Insurance form field
              TextField(
                controller: insuranceController,
                decoration: const InputDecoration(
                  labelText: 'Insurance',
                  hintText: 'Enter insurance provider',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Insurance form field
              TextField(
                controller: registrationController,
                decoration: const InputDecoration(
                  labelText: 'Registration',
                  hintText: 'Enter registration number',
                  border: OutlineInputBorder(),
                ),
              ),

              // // Image path form field
              // TextField(
              //   controller: imagePathController,
              //   decoration: const InputDecoration(
              //     labelText: 'Image Path',
              //     hintText: 'Enter image path or URL',
              //     border: OutlineInputBorder(),
              //   ),
              // ),
            ] else ...[
              const SizedBox(height: 16),
              // Dropdown for gear type
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: selectedGearType,
                decoration: const InputDecoration(
                  labelText: 'Gear Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Helmet',
                    child: Text('Helmet'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Gloves',
                    child: Text('Gloves'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Jacket',
                    child: Text('Jacket'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Boots',
                    child: Text('Boots'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Pants',
                    child: Text('Pants'),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGearType = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Gear size form field
              TextField(
                controller: gearSizeController,
                decoration: const InputDecoration(
                  labelText: 'Gear Size',
                  hintText: 'Enter gear size',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Gear size form field
              TextField(
                controller: brandController,
                decoration: const InputDecoration(
                  labelText: 'Brand',
                  hintText: 'Enter brand',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Gear size form field
              TextField(
                controller: brandController,
                decoration: const InputDecoration(
                  labelText: 'Material',
                  hintText: 'Enter material',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Rental price form field
              TextField(
                controller: rentalPriceController,
                decoration: const InputDecoration(
                  labelText: 'Rental Price',
                  hintText: 'Enter rental price per day',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              // const SizedBox(height: 16),
              // // Image path form field
              // TextField(
              //   controller: imagePathController,
              //   decoration: const InputDecoration(
              //     labelText: 'Image Path',
              //     hintText: 'Enter image path or URL',
              //     border: OutlineInputBorder(),
              //   ),
              // ),
            ],

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Collect values from the text fields
                String model = modelController.text;
                String rentalPrice = rentalPriceController.text;
                String imagePath = imagePathController.text;
                String gearType = gearSizeController.text;

                // Check if fields are filled out for either motorcycle or gear
                if (isMotorcycleSelected) {
                  // Validate motorcycle fields
                  if (model.isEmpty ||
                      rentalPrice.isEmpty ||
                      imagePath.isEmpty ||
                      colorControler.text.isEmpty ||
                      vinController.text.isEmpty ||
                      mileageController.text.isEmpty ||
                      insuranceController.text.isEmpty ||
                      registrationController.text.isEmpty) {
                    // Show an error message if any required fields are empty
                    _showErrorDialog(
                        'Please fill out all fields for the motorcycle.');
                    return;
                  }
                } else {
                  // Validate gear fields
                  if (gearType.isEmpty ||
                      rentalPrice.isEmpty ||
                      imagePath.isEmpty ||
                      gearSizeController.text.isEmpty ||
                      brandController.text.isEmpty ||
                      materialController.text.isEmpty) {
                    // Show an error message if any required fields are empty
                    _showErrorDialog(
                        'Please fill out all fields for the gear.');
                    return;
                  }
                }

                // If all fields are filled, save the listing
                if (isMotorcycleSelected) {
                  _showSavedListing(model, rentalPrice, imagePath);
                } else {
                  print('Gear type added: $selectedGearType');
                }

                print('Model: $model');
                print('Rental Price: $rentalPrice');
                print('Image Path: $imagePath');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 163, 196, 212),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Listing'),
            ),
          ],
        ),
      ),
    );
  }
}
