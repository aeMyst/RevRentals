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
