import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:nutrition/controllers/local_notification_controller.dart';
import 'package:nutrition/controllers/notification_controller.dart';
import 'package:nutrition/model/user_model.dart';
import 'package:nutrition/providers/auth/auth_provider.dart';
import 'package:nutrition/providers/home/coach_provider.dart';
import 'package:provider/provider.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationController _notificationController = NotificationController();

  //----initialize notifications and get the device token

  Future<void> initNotifications(BuildContext context) async {
    //--first get the user uid from user model
    UserModel? userModel = Provider.of<AuthProvider>(context, listen: false).userModel;

    // Logger().w(userModel!.toMap());

    // Get the token each time the application loads
    await FirebaseMessaging.instance.getToken().then(
      (value) {
        Logger().wtf(value);
        startSaveToken(context, value!, userModel!.uid);
      },
    );
  }

  //---save notification token in db
  Future<void> startSaveToken(BuildContext context, String token, String uid) async {
    try {
      await _notificationController.saveNotificationToken(uid, token).then(
        (value) {
          //---updating the token fields with device token
          Provider.of<AuthProvider>(context, listen: false).setDeviceToken(token);
        },
      );
    } catch (e) {
      Logger().e(e);
    }
  }

  void onReceiveMessage(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      Logger().w({"foreground message recieved": message.toMap()});

      LocalNotificationController().showAndroidNotifications(message);
      Provider.of<CoachProvider>(context, listen: false).startGetPaidUsers(context);
    });
  }

  //---handle foreground notitification
  void foregroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Logger().w('Got a message whilst in the foreground!');
      Logger().w('Message data: ${message.data}');

      if (message.notification != null) {
        Logger().wtf('Message also contained a notification: ${message.notification!.toMap()}');
      }
    });
  }

  //----handle when click on the notification and open the app
  void onClickedOpenedApp(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Logger().w('///////----------clicked notification to open the app');
      Logger().w('Message data: ${message.data}');

      if (message.notification != null) {
        // Logger().wtf('Message also contained a notification: ${message.notification!.toMap()}');
      }
    });
  }

  // Send a push notification using FCM
  Future<void> sendCoachNotification({
    required String receiverToken,
    required UserModel userModel,
  }) async {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAArCnh49M:APA91bGObgHBR7sSfSI1l7MnQx63c0ZKWctljILkJmFa48RSIKZYvrLV5rH7BjLpFmSfLIxMz59lNyQStb4eM2lODn2Z6u0y9hBaYOwd8BFbzgtypahAkUFjWpu9Vjqz_mEWKVLnH0Tk',
      },
      body: json.encode({
        'to': receiverToken,
        'notification': {
          'title': "New Payment Alert",
          'body': "${userModel.name} has been added you !",
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
        'data': {
          'title': "New Payment Alert",
          'body': "${userModel.name} has been added you !",
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
      }),
    );
    Logger().w(response.body);
  }
}
