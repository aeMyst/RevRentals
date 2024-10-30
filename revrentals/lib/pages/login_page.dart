import 'package:flutter/material.dart';
import 'package:revrentals/components/my_button.dart';
import 'package:revrentals/components/my_sliding_button.dart';
import 'package:revrentals/components/my_textfield.dart';

class LoginPage extends StatelessWidget {

  LoginPage({super.key,});

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  // SIGN USER IN METHOD
  void signUserIn() async {
      // TO-DO
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

            // logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/images/rr_logo.png',
                  height: 200,
                  )
                ]
              ),
          
              const SizedBox(height: 10),

              const Text(
                'Welcome to RevRentals',
                style: TextStyle (
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),


            // welcome
              Text(
                'Create an account or log in to access the app.',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16),
                ),
            
              
              const SizedBox(height: 25),

            // log in button
              MySlidingButton(),

              const SizedBox(height: 20),
            // username textfield
              MyTextField(
                controller: emailController,
                hintText: 'Username',
                obscureText: false,

              ),

              const SizedBox(height: 10),

            // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),


              // forgot password
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.grey[600])
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
         
          
            // sign in button
              MyButton(
                onTap: signUserIn
              ),            


            // continue with
          
          
            // apple
          
              const SizedBox(height: 50), 
            // not a member, register now
              /*Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                      Text('Not a member?', style: TextStyle(color: Colors.grey[700])),

                      const SizedBox(width: 4),

                      const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold)),
                ]
              ) */

          ],
          
          ),
        ),
      )
    );
  }

}