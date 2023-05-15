import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition/screen/auth/singin_screen.dart';

class menu extends StatefulWidget {
  const menu({
    super.key,
    required String userName,
    required String email,
    required String age,
    required String gender,
    required String phoneNumber,
  });

  @override
  State<menu> createState() => _menuState();
}

class _menuState extends State<menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Logout"),
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              print("Signed Out");
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
            });
          },
        ),
      ),
    );
  }
}
