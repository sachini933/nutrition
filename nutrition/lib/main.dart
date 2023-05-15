import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nutrition/controllers/local_notification_controller.dart';
import 'package:nutrition/firebase_options.dart';
import 'package:nutrition/providers/auth/auth_provider.dart';
import 'package:nutrition/providers/auth/signup_provider.dart';
import 'package:nutrition/providers/home/coach_provider.dart';
import 'package:nutrition/providers/home/user_provider.dart';
import 'package:nutrition/providers/notifications/notification_provider.dart';
import 'package:nutrition/providers/payments/payment_provider.dart';
import 'package:nutrition/screen/splash/splash.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //-----load our .env file that contains required keys
  await dotenv.load(fileName: "assets/.env");

  //---assign publishable key to flutter stripe package
  Stripe.publishableKey = dotenv.env['PUBLISHABLE_KEY']!;

//-----initializing firebase messaging
  LocalNotificationController().init();

  runApp(
    //--initializing providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => SignupProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CoachProvider()),
        ChangeNotifierProvider(create: (context) => PaymentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const Splash(),
    );
  }
}
