// import 'package:flutter/material.dart';
// import 'package:revrentals/components/my_button.dart';
// import 'package:revrentals/components/my_sliding_button.dart';
// import 'package:revrentals/components/my_textfield.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:revrentals/components/signup_button.dart';
// import 'package:revrentals/pages/signup_page.dart';
// class LoginPage extends StatefulWidget {
//   const LoginPage({
//     super.key,
//   });

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   // text editing controllers
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   final signupEmailController = TextEditingController();
//   // final user = FirebaseAuth.instance.currentUser!;

//   // SIGN USER IN METHOD
//   void signUserIn(BuildContext context) async {
//     // Show loading circle
//     showDialog(
//         context: context,
//         builder: (context) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         });
//     // try to sign in
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: emailController.text, password: passwordController.text);
//       Navigator.pop(context);
//     } on FirebaseAuthException catch (e) {
//       Navigator.pop(context);

//       String message;
//       if (e.code == 'user-not-found') {
//         message = 'No user found for that email.';
//         errorMessage(message);
//       } else if (e.code == 'wrong-password') {
//         message = 'Incorrect password.';
//         errorMessage(message);
//       } else {
//         message = 'An error occurred. Please try again.';
//         errorMessage(message);
//       }
//     }
//   }

//   void errorMessage(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Login Failed"),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }
//   void navigateToSignUp(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const SignUpPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: Center(
//               child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 50),

//                 // logo
//                 Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                   Image.asset(
//                     'lib/images/rr_logo.png',
//                     height: 200,
//                   )
//                 ]),

//                 const SizedBox(height: 10),

//                 const Text(
//                   'Welcome to RevRentals',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 // welcome
//                 Text(
//                   'Create an account or log in to access the app.',
//                   style: TextStyle(color: Colors.grey[700], fontSize: 16),
//                 ),

//                 const SizedBox(height: 25),

//                 MySlidingButton(
//                   onSignUp: () => navigateToSignUp(context),
//                 ),

//                 const SizedBox(height: 20),
//                 // username textfield
//                 MyTextField(
//                   controller: emailController,
//                   hintText: 'Email',
//                   obscureText: false,
//                 ),

//                 const SizedBox(height: 10),

//                 // password textfield
//                 MyTextField(
//                   controller: passwordController,
//                   hintText: 'Password',
//                   obscureText: true,
//                 ),

//                 // forgot password
//                 const SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text('Forgot password?',
//                           style: TextStyle(color: Colors.grey[600])),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 25),

//                 // sign in button
//                 MyButton(
//                   onTap: () => signUserIn(context),
//                 ),

//                 // continue with

//                 // apple

//                 const SizedBox(height: 50),

//                 // SignupButton(
//                 //   onTap: () => signUserUp(context),
//                 // ),
//                 // not a member, register now
//                 /*Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                       Text('Not a member?', style: TextStyle(color: Colors.grey[700])),

//                       const SizedBox(width: 4),

//                       const Text(
//                         'Register now',
//                         style: TextStyle(
//                           color: Colors.blueGrey,
//                           fontWeight: FontWeight.bold)),
//                 ]
//               ) */
//               ],
//             ),
//           )),
//         ));
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/admin/admin_login.dart';
import 'package:revrentals/components/my_button.dart';
import 'package:revrentals/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailOrUsernameController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final adminEmailController = TextEditingController(); // Added for admin email

  bool isSignUpMode = false;
  int? _selectedRole = 0; // 0 for "Renter", 1 for "Seller"

  void toggleAuthMode(bool isSignUp) {
    setState(() {
      isSignUpMode = isSignUp;
    });
  }

  void onRoleSelected(int? newRole) {
    setState(() {
      _selectedRole = newRole;
    });
  }

  Future<void> authenticateUser(BuildContext context) async {
    if (isSignUpMode) {
      await signUpUser(context);
    } else {
      await signInUser(context);
    }
  }

  Future<void> signInUser(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    String input = emailOrUsernameController.text;
    String email;

    try {
      if (_isEmail(input)) {
        email = input;
      } else {
        email = await _getEmailFromUsername(input);
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showError(e.message ?? 'Failed to log in');
    } catch (e) {
      Navigator.pop(context);
      showError('Username not found');
    }
  }

  Future<String> _getEmailFromUsername(String username) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('Username not found');
    }
    return querySnapshot.docs.first['email'];
  }

  bool _isEmail(String input) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(input);
  }

  Future<void> signUpUser(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    if (passwordController.text.isEmpty ||
        emailOrUsernameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Navigator.pop(context);
      showError("All fields are required.");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      showError("Passwords do not match.");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailOrUsernameController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'username': usernameController.text,
        'email': emailOrUsernameController.text,
      });

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showError(e.message ?? 'Failed to sign up');
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

  Future<void> resetPassword(BuildContext context) async {
    if (emailOrUsernameController.text.isEmpty) {
      showError("Please enter your email or username.");
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    String email;

    try {
      if (_isEmail(emailOrUsernameController.text)) {
        email = emailOrUsernameController.text;
      } else {
        email = await _getEmailFromUsername(emailOrUsernameController.text);
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.pop(context);
      showError("Password reset email sent. Check your inbox.");
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showError(e.message ?? 'Failed to send password reset email');
    } catch (e) {
      Navigator.pop(context);
      showError("Username not found");
    }
  }

  void getAdminPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminLoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                // const SizedBox(height: 10),
                const Text(
                  'Welcome to RevRentals',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Create an account or log in to access the app.',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(height: 25),
                CupertinoSlidingSegmentedControl<int>(
                  children: const {
                    0: Text('Log In', style: TextStyle(fontSize: 16)),
                    1: Text('Sign Up', style: TextStyle(fontSize: 16)),
                  },
                  groupValue: isSignUpMode ? 1 : 0,
                  onValueChanged: (int? newValue) {
                    toggleAuthMode(newValue == 1);
                  },
                ),
                const SizedBox(height: 20),
                if (isSignUpMode) 
                  // CupertinoSlidingSegmentedControl<int>(
                  //   children: const {
                  //     0: Text('Renter'),
                  //     1: Text('Seller'),
                  //   },
                  //   groupValue: _selectedRole,
                  //   onValueChanged: onRoleSelected,
                  // ),

                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: emailOrUsernameController,
                  hintText: isSignUpMode ? 'Email' : 'Email or Username',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                if (isSignUpMode) ...[
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  ... [
                  const SizedBox(height: 10),
                  const Text(
                    'Choose "Renter" if you are looking to rent items, '
                    'or "Seller" if you plan to offer items for rent.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  CupertinoSlidingSegmentedControl<int>(
                    children: const {
                      0: Text('Renter'),
                      1: Text('Seller'),
                    },
                    groupValue: _selectedRole,
                    onValueChanged: onRoleSelected,
                  ),
                ],
                ],
                const SizedBox(height: 15),
                MyButton(
                  onTap: () => authenticateUser(context),
                  label: isSignUpMode ? 'Sign Up' : 'Log In',
                ),
                const SizedBox(height: 20),
                // Forgot Password Section
                if (!isSignUpMode) ...[
                  TextButton(
                    onPressed: () => resetPassword(context),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                // const SizedBox(height: 50),

                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => getAdminPage(context),
                  child: const Text(
                    'Sign in as Admin',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
