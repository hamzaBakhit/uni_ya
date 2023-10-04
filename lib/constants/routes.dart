

import 'package:flutter/material.dart';
import 'package:uni_ya/features/my_drawer/my_drawer_parent.dart';
import 'package:uni_ya/features/orders/view/bill.dart';
import 'package:uni_ya/features/user/view/log_in_screen/log_in_screen.dart';
import 'package:uni_ya/features/user/view/log_up_screen/log_up_screen.dart';
import 'package:uni_ya/ui/screens/home/home.dart';
import 'package:uni_ya/ui/screens/old_orders/old_orders.dart';

import '../features/app_intro/app_intro.dart';
import '../features/orders/view/order_asking_screen.dart';
import '../features/settings/view/settings_screen.dart';

class Routes{
  final Map<String,WidgetBuilder> routes={
   logIn:(context)=>const LogInScreen(),
   logUP:(context)=>const LogUPScreen(),
   // home:(context)=>const MainScreen(),
   main:(context)=>const MyDrawerParent(),
   appIntro:(context)=>const AppIntro(),
   settings:(context)=>const SettingsScreen(),
   history:(context)=>const OldOrdersScreen(),
   orderAsking:(context)=>const AskingOrderScreen(),
   bill:(context)=>const Bill(),


  };
  static const String initialRoute=appIntro;
  static const String logIn='/logIn';
  static const String appIntro='/appIntro';
  static const String logUP='/logUP';
  static const String main='/main';
  static const String bill ='/bill';

  static const String settings='/settings';
  static const String history='/history';
  static const String orderAsking='/order_asking';

}