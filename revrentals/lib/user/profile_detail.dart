import 'package:flutter/material.dart';
import 'package:revrentals/components/my_button.dart';
import 'package:revrentals/user/user_home.dart';
import 'package:revrentals/services/auth_service.dart';
import 'package:revrentals/regex/signup_regex.dart';

class ProfileDetailsPage extends StatefulWidget {
  final int profileId;
  const ProfileDetailsPage({Key? key, required this.profileId})
      : super(key: key);

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  // Service for authentication and profile management
  final AuthService _authService = AuthService();

  // Controllers for form fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final addressController = TextEditingController();
  bool isLoading = false;

  Future<void> saveProfileDetails(BuildContext context) async {
    // Trim all inputs before validation
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final licenseNumber = licenseNumberController.text.trim();
    final address = addressController.text.trim();

    // Validate all fields with trimmed values
    String? firstNameError = Validators.validateFirstName(firstName);
    String? lastNameError = Validators.validateLastName(lastName);
    String? licenseError = Validators.validateLicenseNumber(licenseNumber);
    String? postalCodeError = Validators.validatePostalCode(address);

    // Show appropriate error messages if validation fails
    if (firstNameError != null) {
      showError(firstNameError);
      return;
    }
    if (lastNameError != null) {
      showError(lastNameError);
      return;
    }
    if (licenseError != null) {
      showError(licenseError);
      return;
    }
    if (postalCodeError != null) {
      showError(postalCodeError);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await _authService.saveProfileDetails(widget.profileId, {
        "first_name": firstName,
        "last_name": lastName,
        "license_number": licenseNumber,
        "address": address,
      });

      setState(() {
        isLoading = false;
      });

      if (response["success"]) {
        // Navigate to home page if successful
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => UserHomePage(userData: response['user']),
          ),
          (route) => false,
        );
      } else {
        showError(response["error"] ?? "Failed to save profile details.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError("An error occurred: $e");
    }
  }

  // Error dialog display
  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align all children to start
            children: [
              // Logo and Title - These should still be centered
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'lib/images/rr_logo.png',
                      height: 300,
                    ),
                    const Text(
                      'Complete Profile Details',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // First Name Field
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 4), // Slight padding to align with input field
                child: const Text(
                  'First name must contain only letters.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 10),

              // Last Name Field
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: const Text(
                  'Last name must contain only letters.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 10),

              // License Number Field
              TextField(
                controller: licenseNumberController,
                decoration: const InputDecoration(
                  labelText: "License Number",
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: const Text(
                  'Enter your Alberta License Number in format: xxxxxx-xxx',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 10),

              // Postal Code Field
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "Postal Code",
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: const Text(
                  'Enter your Canadian postal code in format: A1A 1A1, A1A1A1, or A1A-1A1',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 20),

              // Save Button - This should be centered
              Center(
                child: MyButton(
                  onTap: () => saveProfileDetails(context),
                  label: isLoading ? 'Loading...' : 'Save Details',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers when widget is disposed
    firstNameController.dispose();
    lastNameController.dispose();
    licenseNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }
}

// Page for displaying and updating existing profile details
class DisplayProfileDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final int? profileId;

  const DisplayProfileDetailsPage({
    super.key,
    this.userData,
    this.profileId,
  });

  @override
  _DisplayProfileDetailsPageState createState() =>
      _DisplayProfileDetailsPageState();
}

class _DisplayProfileDetailsPageState extends State<DisplayProfileDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;
  Map<String, dynamic>? _currentUserData;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (widget.userData != null) {
      // If userData is provided directly, use it
      _populateFields(widget.userData!);
      _currentUserData = widget.userData;
    } else if (widget.profileId != null) {
      // If only profileId is provided, fetch the data
      try {
        setState(() {
          isLoading = true;
        });

        final response =
            await _authService.fetchProfileDetails(widget.profileId!);
        if (response['success']) {
          _populateFields(response['user']);
          _currentUserData = response['user'];
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading profile: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  void _populateFields(Map<String, dynamic> data) {
    _usernameController.text = data['username'] ?? '';
    _firstNameController.text = data['first_name'] ?? '';
    _lastNameController.text = data['last_name'] ?? '';
    _addressController.text = data['address'] ?? '';
    _emailController.text = data['email'] ?? '';
    _licenseController.text = data['license'] ?? '';
    _usernameController.text = data['username'] ?? '';
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final profileId = _currentUserData?['profile_id'] ?? widget.profileId;
        if (profileId == null) {
          throw Exception('Profile ID not available');
        }

        final response = await _authService.saveProfileDetails(
          profileId,
          {
            'first_name': _firstNameController.text.trim(),
            'last_name': _lastNameController.text.trim(),
            'license_number': _licenseController.text.trim(),
            'address': _addressController.text.trim(),
          },
        );

        if (response['success']) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
            Navigator.pop(context, response['user']);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating profile: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && _currentUserData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    Validators.validateFirstName(value?.trim() ?? ''),
              ),
              const SizedBox(height: 5),
              const Text(
                'First name must contain only letters.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    Validators.validateLastName(value?.trim() ?? ''),
              ),
              const SizedBox(height: 5),
              const Text(
                'Last name must contain only letters.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _licenseController,
                decoration: const InputDecoration(
                  labelText: 'License Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    Validators.validateLicenseNumber(value?.trim() ?? ''),
              ),
              const SizedBox(height: 5),
              const Text(
                'Enter your Alberta License Number in format: xxxxxx-xxx',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Postal Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    Validators.validatePostalCode(value?.trim() ?? ''),
              ),
              const SizedBox(height: 5),
              const Text(
                'Enter your Canadian postal code in format: A1A 1A1 or A1A-1A1',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _updateProfile,
                  child: Text(isLoading ? 'Updating...' : 'Update Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _licenseController.dispose();
    super.dispose();
  }
}
