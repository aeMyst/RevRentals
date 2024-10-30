import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/components/my_button.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final addressController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveProfileDetails() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        licenseNumberController.text.isEmpty ||
        addressController.text.isEmpty) {
      showError("All fields are required.");
      return;
    }

    if (_auth.currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'license_number': licenseNumberController.text,
          'address': addressController.text,
          'profile_complete': true, // Set profile_complete to true upon save
        });
        Navigator.pop(context); // Return to previous page after saving
      } catch (e) {
        showError("Failed to save profile details. Please try again.");
      }
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

  // Sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        // title: const Text("Complete Profile Details"),
        actions: [
          IconButton(
            onPressed: () => signUserOut(),
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
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
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(labelText: "First Name"),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: "Last Name"),
                ),
                TextField(
                  controller: licenseNumberController,
                  decoration:
                      const InputDecoration(labelText: "License Number"),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: "Address"),
                ),
                const SizedBox(height: 20),
                MyButton(onTap: saveProfileDetails, label: 'Save Details'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DisplayProfileDetailsPage extends StatefulWidget {
  @override
  _DisplayProfileDetailsPageState createState() =>
      _DisplayProfileDetailsPageState();
}

class _DisplayProfileDetailsPageState extends State<DisplayProfileDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _updateProfile(String uid) async {
    if (_formKey.currentState!.validate()) {
      try {
        // TODO: Fix issue with updating email in Firebase, this only updates it in the database
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'address': _addressController.text,
          'email': _emailController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile Details')),
        body: Center(
          child: Text('No user is currently logged in.',
              style: TextStyle(fontSize: 18)),
        ),
      );
    }

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(user.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Profile Details')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(title: Text('Profile Details')),
            body: Center(
              child: Text('User profile not found.',
                  style: TextStyle(fontSize: 18)),
            ),
          );
        }

        // Load data into controllers
        var userData = snapshot.data!.data() as Map<String, dynamic>;
        _firstNameController.text = userData['first_name'] ?? '';
        _lastNameController.text = userData['last_name'] ?? '';
        _addressController.text = userData['address'] ?? '';
        _emailController.text = userData['email'] ?? '';
        String license_number = userData['license_number'] ?? '';

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            title: Text('Profile Details',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blueGrey,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(labelText: 'First Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your first name' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(labelText: 'Last Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your last name' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your email' : null,
                  ),
                  // const SizedBox(height: 8),
                  // TextFormField(
                  //   controller: _addressController,
                  //   decoration: InputDecoration(labelText: 'Address'),
                  //   validator: (value) =>
                  //       value!.isEmpty ? 'Please enter your address' : null,
                  // ),
                  const SizedBox(height: 8),
                  Text('License Number: $license_number',
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  MyButton(
                      onTap: () => _updateProfile(user.uid),
                      label: 'Save Profile Details'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
