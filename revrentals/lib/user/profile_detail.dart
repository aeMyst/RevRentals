
import 'package:flutter/material.dart';
import 'package:revrentals/components/my_button.dart';
import 'package:revrentals/user/user_home.dart';
import 'package:revrentals/services/auth_service.dart';

class ProfileDetailsPage extends StatefulWidget {
  final int profileId; // Accept profileId as a parameter
  const ProfileDetailsPage({Key? key, required this.profileId}) : super(key: key);

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  final AuthService _authService = AuthService(); // AuthService for backend calls
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final addressController = TextEditingController();
  bool isLoading = false; // Loading state

  Future<void> saveProfileDetails(BuildContext context) async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        licenseNumberController.text.isEmpty ||
        addressController.text.isEmpty) {
      showError("All fields are required.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await _authService.saveProfileDetails(widget.profileId, {
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "license_number": licenseNumberController.text,
        "address": addressController.text,
      });

      setState(() {
        isLoading = false;
      });

      if (response["success"]) {
        // Pass the user data directly to UserHomePage
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => UserHomePage(userData: response['user']),
          ),
          (route) => false,  // Remove all previous routes
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/images/rr_logo.png',
                      height: 300,
                    ),
                  ],
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
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(labelText: "First Name"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: "Last Name"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: licenseNumberController,
                  decoration:
                      const InputDecoration(labelText: "License Number"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: "Address"),
                ),
                const SizedBox(height: 20),
                MyButton(onTap: () =>
                      saveProfileDetails(context), label: isLoading
                      ? 'Loading...' : 'Save Details'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DisplayProfileDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const DisplayProfileDetailsPage({super.key, this.userData});

  @override
  _DisplayProfileDetailsPageState createState() => _DisplayProfileDetailsPageState();
}

class _DisplayProfileDetailsPageState extends State<DisplayProfileDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.userData != null) {
      _firstNameController.text = widget.userData!['first_name'] ?? '';
      _lastNameController.text = widget.userData!['last_name'] ?? '';
      _addressController.text = widget.userData!['address'] ?? '';
      _emailController.text = widget.userData!['email'] ?? '';
      _licenseController.text = widget.userData!['license'] ?? '';
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final response = await _authService.saveProfileDetails(
          widget.userData!['profile_id'],
          {
            'first_name': _firstNameController.text,
            'last_name': _lastNameController.text,
            'license_number': _licenseController.text,
            'address': _addressController.text,
          },
        );

        if (response['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) => value!.isEmpty ? 'Please enter your first name' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) => value!.isEmpty ? 'Please enter your last name' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                enabled: false,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _licenseController,
                decoration: const InputDecoration(labelText: 'License Number'),
                validator: (value) => value!.isEmpty ? 'Please enter your license number' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty ? 'Please enter your address' : null,
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