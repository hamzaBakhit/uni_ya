import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uni_ya/sevices/local/local_service.dart';

import '../../constants/texts.dart';

class MyNotifications {
  static MyNotifications get = MyNotifications();
  var messaging = FirebaseMessaging.instance;

  setupNotifications() {
    AwesomeNotifications().initialize(
      null, //change to path of icon
      _getNotificationChannel(),
    );
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  List<NotificationChannel> _getNotificationChannel() {
    return [
      NotificationChannel(
        channelKey: 'admin_channel',
        channelName: 'Admin Channel',
        channelDescription: 'this channel for admin notifications',
      ),
    ];
  }

  createNormalNotification({required String title, required String body}) async{
    Map<String,dynamic> settings=await LocalService.get.getSettings();

    if(settings['isNotification']){
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 0,
          channelKey: _getNotificationChannel()[0].channelKey!,
          title: title,
          body: body,
          notificationLayout: NotificationLayout.BigText,
        ),
      );
    }

  }

  requestNotificationPermission() {
    AwesomeNotifications().isNotificationAllowed().then((isAllow) {
      if (isAllow) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
    print(receivedAction.id);

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    // MaterialPart.navigatorKey.currentState?.pushNamed('/');
  }

  Future<bool> sendMessageToAdmins(
      {required String orderId, required bool isAdd}) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "to": "/topics/admin",
      "notification": {
        "body": "Check The Orders, Please.",
        "title": isAdd ? "New Order" : "Order Canceled"
      },
      "data": {
        "type": "order",
        "id": orderId,
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAYzVUV2Q:APA91bFhYSuJ_lNkMjgCl8I-elSfrJz09-lBZANqow406NPCf18djLq0Dp-GF12ePBFov9yTnxfqhu6WEVNY1VY80RrXNGqruKtzkc7CyB6Ols1WsG8CNgr4hf9_vqj-7nVbBwkh8X_o'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(response.statusCode);
      // on failure do sth
      return false;
    }
  }

  getNotification() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      try {
        if (message.notification != null) {
          createNormalNotification(
              title: message.notification!.title!,
              body: message.notification!.body!);
        }
      } catch (e) {}
    });
  }

String token='';
  Future<String> getToken() async {
    String? token = await messaging.getToken();
    token ??= '';
    this.token=token;
    return token;
  }
}
