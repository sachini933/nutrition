import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../reusable_widgets/reusable_widget.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email Address", Icons.person_outline, false, _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Reset Password", () {
                  FirebaseAuth.instance.sendPasswordResetEmail(email: _emailTextController.text).then((value) => Navigator.of(context).pop());
                })
              ],
            ),
          ))),
    );
  }
}
