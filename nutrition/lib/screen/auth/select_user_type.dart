import 'package:flutter/material.dart';
import 'package:nutrition/providers/auth/signup_provider.dart';
import 'package:nutrition/screen/auth/coach-signup.dart';
import 'package:nutrition/screen/auth/signup_screen.dart';
import 'package:provider/provider.dart';

class SelectUserType extends StatefulWidget {
  const SelectUserType({super.key});

  @override
  State<SelectUserType> createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends State<SelectUserType> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Image(
                image: const AssetImage('assets/images/fix.png'),
                height: size.height * 0.6,
              ),
              const Text(
                'Singup',
                style: TextStyle(
                  color: Color(0xff14c38e),
                  fontSize: 24,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<SignupProvider>(context, listen: false).setUserType("user");

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff14c38e),
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: Text(
                    'User'.toUpperCase(),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<SignupProvider>(context, listen: false).setUserType("coach");

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CSignup()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff14c38e),
                    shape: const RoundedRectangleBorder(),
                  ),
                  child: Text(
                    'coach'.toUpperCase(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
