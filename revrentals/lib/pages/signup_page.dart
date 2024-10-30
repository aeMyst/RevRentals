import 'package:flutter/material.dart';
import 'package:revrentals/components/my_button.dart';
import 'package:revrentals/components/my_sliding_button.dart';
import 'package:revrentals/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:revrentals/components/signup_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // final user = FirebaseAuth.instance.currentUser!;

  // SIGN USER IN METHOD
  void signUpUser(BuildContext context) async {
    if (passwordController.text != confirmPasswordController.text) {
      errorMessage("Passwords do not match");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      String message;
      if (e.code == 'email-already-in-use') {
        message = 'Email is already in use.';
        errorMessage(message);
      } else if (e.code == 'weak-password') {
        message = 'Weak password.';
        errorMessage(message);
      } else {
        message = 'An error occurred. Please try again.';
        errorMessage(message);
      }
    }
  }

  void errorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Signup Failed"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset(
                    'lib/images/rr_logo.png',
                    height: 200,
                  )
                ]),

                const SizedBox(height: 10),

                const Text(
                  'Welcome to RevRentals',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // welcome
                Text(
                  'Create an account or log in to access the app.',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),

                const SizedBox(height: 25),

                const SizedBox(height: 20),
                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),


                const SizedBox(height: 25),

                SignupButton(onTap: () => signUpUser(context),
                ),

                const SizedBox(height: 50),


              ],
            ),
          )),
        ));
  }

    // throw UnimplementedError();
  
}
