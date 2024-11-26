import 'package:firebase_auth/firebase_auth.dart';

class ButtonUtils {

  static void signUserOut() {
    FirebaseAuth.instance.signOut();
  }


  //   // Sign out function
  // static Future<void> signOut(BuildContext context) async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //     Navigator.of(context).pushReplacementNamed('/login'); // Navigate to login page after sign-out
  //   } catch (e) {
  //     // Handle sign out error
  //     _showError(context, "Failed to sign out. Please try again.");
  //   }
  // }

  // // Optional: Error dialog utility
  // static void _showError(BuildContext context, String message) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text("Error"),
  //       content: Text(message),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: const Text("OK"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

}