import 'package:flutter/material.dart';
import 'package:nutrition/screen/login.dart';

class userRegis extends StatefulWidget {
  const userRegis({super.key});

  @override
  State<userRegis> createState() => _userRegisState();
}

class _userRegisState extends State<userRegis> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Text(
                'User Registration Form',
                style: TextStyle(
                  color: Color(0xff14c38e),
                  fontSize: 28,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w700,
                ),
              ),
              Form(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'First Name', hintText: 'First Name', border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Last Name', hintText: 'Last Name', border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'E-mail', hintText: 'E-mail', border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Create Password', hintText: 'Create password*', border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Mobile Number', hintText: 'Mobile Number', border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Age', hintText: 'Age', border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Gender', hintText: 'Gender', border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff14c38e),
                            shape: const RoundedRectangleBorder(),
                          ),
                          child: Text(
                            'Register'.toUpperCase(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const loginuser()),
                          );
                        },
                        child: Text.rich(TextSpan(text: "Already have an Account?", style: Theme.of(context).textTheme.bodySmall, children: const [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ])),
                      ),
                    ],
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
