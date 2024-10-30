import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // Sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
        ]),
        body: Center(
          child: Text("LOGGED INTO HOME PAGE AS: " + user.email!),
        ));
  }
}
