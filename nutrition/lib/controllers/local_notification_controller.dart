import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationController {
  //LocalNotificationController a singleton object
  static final LocalNotificationController _notificationService = LocalNotificationController._internal();

//---factory constructor
  factory LocalNotificationController() {
    return _notificationService;
  }

  //--real class named constructor
  LocalNotificationController._internal();

  // static const channelId = '123';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: selectNotificationIos,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS, macOS: null);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: selectNotification);
  }

  final AndroidNotificationDetails _androidNotificationDetails = const AndroidNotificationDetails(
    'default_notification_channel_id', 'default_notification_channel_id channel',
    // 'channel description',
    playSound: true,
    fullScreenIntent: true,
    enableLights: true,
    enableVibration: true,
    visibility: NotificationVisibility.public,
    priority: Priority.high,
    importance: Importance.max,
    timeoutAfter: 500,
    color: Colors.green,
  );

  //ios notiification details
  final DarwinNotificationDetails _iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
    presentAlert: true, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    presentBadge:
        true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    presentSound: true, // Play a sound when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
  );

//----show android notification
  Future<void> showAndroidNotifications(RemoteMessage payload) async {
    await flutterLocalNotificationsPlugin.show(
      payload.hashCode,
      payload.notification!.title,
      payload.notification!.body,
      NotificationDetails(android: _androidNotificationDetails),
      payload: jsonEncode(payload.toMap()),
    );
  }

//--show ios notification
  Future<void> showIosNotifications(RemoteMessage payload) async {
    await flutterLocalNotificationsPlugin.show(
      payload.hashCode,
      payload.notification!.title,
      payload.notification!.body,
      NotificationDetails(iOS: _iOSPlatformChannelSpecifics),
      payload: jsonEncode(payload.toMap()),
    );
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

Future selectNotification(NotificationResponse? val) async {
  //handle your logic here
  // Logger().w(jsonDecode(val!.payload!)['data']['convid']);
}

void selectNotificationIos(int id, String? title, String? body, String? payload) async {
  //handle your logic here
  Logger().d('notification clicked');
  // UtilFunctions.navigateTo(GlobalData.navState.currentContext!, MainScreen());
}
