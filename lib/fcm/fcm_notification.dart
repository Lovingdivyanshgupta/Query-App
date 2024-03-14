import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'firebase_repo.dart';

class MyFcmNotification {
  static List<dynamic> _tokenAdd = [];

  static Future<void> getToken() async {
    String? token;
    if (Platform.isAndroid) {
      token = await FirebaseMessaging.instance.getToken();
    } else if (Platform.isIOS) {
      token = await FirebaseMessaging.instance.getAPNSToken();
    } else {
      // print('Not applicable to other platform.');
    }

    // print('The required token is $token');
    if (token == null) {
      return;
    }

    List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
        await FireBaseDataBaseRepo().getDocsList('deviceToken');
    Map<String, dynamic> idData = data[0].data();
    _tokenAdd = idData['token'];
    if (_tokenAdd.contains(token)) {
      return;
    }
    _tokenAdd.add(token);
    _tokenAdd.toSet();
    _tokenAdd.toList();
    // print('The token add id token is $_tokenAdd  ');
    await FirebaseFirestore.instance
        .collection('deviceToken').doc("hZzEME4tBoZMBfW0W8mN").update({'token': _tokenAdd});
  }

  static Future<void> postApiNotification(
      String senderNameQuery,
      String senderIdQuery,
      String addQuery,
      String id,
      BuildContext context) async {
    // print('The token add id token is $_tokenAdd  ');
    var registrationIds = await FirebaseFirestore.instance
        .collection('deviceToken')
        .doc('3W6FJ6Uz5OGtP54BTglF')
        .get();
    List data = registrationIds.get('token');
    try {
      Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      http.Response response = await http.post(url,
          headers: {
            "content-type": "application/json",
            "Authorization":
                "key=AAAAHOJXMLU:APA91bHTeENWHQJfLfD2CsnAu6i1qYQ9Ai1f_CaGyrqUKhSt1WXh8w1jbYRrOGEPorWzd3u1PNLwO1i2vuJTLCsx8zTT9RcTZ_Sqv3Mua9sH9vTCo8gZJXA6E8F8OSRV5jgJIT-1041Z"
          },
          body: jsonEncode({
            "registration_ids": data,
            "notification": {
              "body":
                  "New Question has been added by $senderNameQuery ($senderIdQuery)",
              "title": addQuery,
              "android_channel_id": "notification_app",
              "sound": true
            },
            "data": {"name": senderNameQuery, "code": senderIdQuery, "id": id}
          }));
      // print('FCM API Request body: ${response.body}');
      // print('FCM API Request status-code: ${response.statusCode}');
      // print('FCM API Request header : ${response.headers}');
      if (response.statusCode == 200) {
        flutterLocalNotificationsPlugin.show(
          0,
          'Hello User,',
          'Question has been submitted.',
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                color: Colors.amber,
                importance: Importance.high,
                icon: '@mipmap/app_launcher_icon',
                playSound: true),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
        );
      }
    } catch (e) {
      // print('Fcm Api cause some error : $e');
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Error Occurred : $e"),
            content: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK')),
          );
        },
      );
    }
  }
}
