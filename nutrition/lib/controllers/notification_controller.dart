import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

class NotificationController {
  //firebase auth instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //creates the user collection refference
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  //-----save user deivce token in the user data
  Future<void> saveNotificationToken(String uid, String token) async {
    await users
        .doc(uid)
        .update(
          {
            "token": token,
          },
        )
        .then((value) => Logger().i("device token  updated"))
        .catchError((error) => Logger().e("Failed to update: $error"));
  }

  Future<void> scheduleNotification(DateTime dateTime, String description) async {
    // Initialize the plugin
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    // const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: iOSPlatformChannelSpecifics,
    );

    // Schedule the notification
    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Reminder',
      description,
      dateTime,
      platformChannelSpecifics,
    );
  }
}
