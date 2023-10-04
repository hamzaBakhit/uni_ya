import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uni_ya/sevices/remote/notifications.dart';
import 'firebase_options.dart';
import 'configs/blocs_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // await FirebaseMessaging.instance.subscribeToTopic("user");
  MyNotifications.get.setupNotifications();
  MyNotifications.get.requestNotificationPermission();
  FirebaseMessaging.onBackgroundMessage( getBackgroundNotification);
  MyNotifications.get.getNotification();
  runApp(const BlocsConfig());
}
@pragma('vm:entry-point')
Future<void> getBackgroundNotification(RemoteMessage message) async {
  try {
    if (message.notification != null) {
      MyNotifications.get.createNormalNotification(
          title: message.notification!.title!,
          body: message.notification!.body!);
    }
  } catch (e) {}
}