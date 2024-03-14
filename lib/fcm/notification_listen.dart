import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:query_app/screens/login_screen.dart';
import 'package:query_app/screens/query_answer.dart';

import '../../databaseManager/my_shared_preferences.dart';
import '../../main.dart';

class MyNotificationListen {
  void getNotificationListenData(BuildContext context) {
    //1. When app is in foreground and you get a notification .
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        // print('A new onMessage event was published!');
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        // AppleNotification? apple = message.notification?.apple;

        if (notification != null && android != null) {
          // print("onMessage message.data :  ${message.data}");
          // print("onMessage message.data :  ${message.notification?.title}");
          // print("onMessage message.data :  ${message.notification?.body}");
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    color: Colors.blue,
                    icon: '@mipmap/app_launcher_icon',
                    playSound: true),
                iOS: const DarwinNotificationDetails(
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true,
                )),
          );
          initializeSettings(context, message);
        }
      },
    );

    //2. When app is in background not terminated and you get a notification .
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        // print('A new onMessageOpenedApp event was published!');
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        // AppleNotification? apple = message.notification?.apple;

        if (notification != null && android != null) {
          // print("onMessageOpenedApp message.data :  ${message.data}");
          // print("onMessageOpenedApp message.data :  ${message.notification?.title}");
          // print("onMessageOpenedApp message.data :  ${message.notification?.body}");
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  channelDescription: channel.description,
                  color: Colors.red,
                  icon: '@mipmap/app_launcher_icon',
                  playSound: true),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
          );
          initializeSettings(context, message);
        }
      },
    );

    //3. When app is terminated and you get a notification .
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        // print('A new getInitialMessage event was published!');
        RemoteNotification? notification = message?.notification;
        AndroidNotification? android = message?.notification?.android;
        // AppleNotification? apple = message?.notification?.apple;

        if (notification != null && android != null) {
          // print("getInitialMessage message.data :  ${message?.data}");
          // print("getInitialMessage message.data :  ${message?.notification?.title}");
          // print("getInitialMessage message.data :  ${message?.notification?.body}");
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  channelDescription: channel.description,
                  color: Colors.red,
                  icon: '@mipmap/app_launcher_icon',
                  playSound: true),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
          );
          initializeSettings(context, message!);
        }
      },
    );
  }

  Future<void> initializeSettings(
      BuildContext context, RemoteMessage message) async {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/app_launcher_icon');
    var iosInitialize = const DarwinInitializationSettings();

    var initialSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    await flutterLocalNotificationsPlugin.initialize(
      initialSettings,
      onDidReceiveNotificationResponse: (payload) async {
        // print('payload id : ${payload.id}');
        // print('payload payload : ${payload.payload}');
        // print('payload input : ${payload.input}');
        // print('message data has show up : ${message.data["id"]}');
        try {
          bool isLogin =
              (await MySharedPreferences.getUserDefault('userLogin'))!;
          if (isLogin) {
            var setData =
                await FirebaseFirestore.instance.collection('q&a').get();
            for (var element in setData.docs) {
              //print(element.id);
              if (element.id == message.data["id"]) {
                QueryDocumentSnapshot<Object?> result = element;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QueryAnswer(queryQuestionData: result),
                  ),
                );
              }
            }
          } else {
            Navigator.pushNamed(context, LoginPage.id);
          }
        } catch (e) {
          // print('error occurred : $e');
        }
      },
    );
  }

}
