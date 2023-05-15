import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:nutrition/providers/auth/auth_provider.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 2),
      () {
        Provider.of<AuthProvider>(context, listen: false).initializUser(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              child: Image.asset(
                'assets/images/welcome.png',
                height: height,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
