import 'package:flutter/material.dart';
import 'package:nutrition/screen/auth/select_user_type.dart';
import 'package:nutrition/screen/auth/singin_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: const Color(0xffe3fcbf),
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(image: const AssetImage('assets/images/welcome.png'), height: height * 0.6),
            const Text(
              "Welcome to FitBody App",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xff14c38e),
                      shape: const RoundedRectangleBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text("Signin".toUpperCase()),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SelectUserType()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xff14c38e),
                      shape: const RoundedRectangleBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text("SignUp".toUpperCase()),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
