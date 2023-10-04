import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uni_ya/features/orders/model/order.dart' as o;
import 'package:uni_ya/sevices/remote/notifications.dart';

import '../../constants/routes.dart';
import '../../constants/texts.dart';
import '../../features/user/logic/user_bloc.dart';

class OrdersRemoteService {
  static OrdersRemoteService get() => OrdersRemoteService();

  CollectionReference orders = FirebaseFirestore.instance
      .collection('restaurants')
      .doc('chile')
      .collection('orders');

  Stream<QuerySnapshot<Object?>> getStreamOrders() {
    String email = '';
    if (UserBloc.myUser != null &&
        UserBloc.myUser!.user != null &&
        UserBloc.myUser!.user!.email != null) {
      email = UserBloc.myUser!.user!.email!;
    }
    return orders
        .where('userEmail', isEqualTo: email)
        .where('state',
            whereIn: [o.OrderState.finished, o.OrderState.unfinished])
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<List<o.Order>> getOldOrders(String email) async {
    List<o.Order> ordersList = [];
    try {
      final data = await orders
          .where('userEmail', isEqualTo: email)
          .orderBy('date', descending: true)
          .limit(10)
          .get();
      if (data.docs.isNotEmpty) {
        for (QueryDocumentSnapshot order in data.docs) {
          ordersList.add(o.Order.fromMap(order: order));
        }
      }
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
    }
    return ordersList;
  }

  Future<bool> addOrder(o.Order order) async {
    try {
      await orders.doc(order.id).set(order.toMap());
      print("go ot bill");
      final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      navigatorKey.currentState?.pushNamed(Routes.bill);
      print("go ot bil2l");
      return true;
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
      return false;
    }
  }

  Future<bool> updateOrder(o.Order order) async {
    try {
      await orders.doc(order.id).update(order.toMap());
      return true;
    } catch (e) {
      EasyLoading.showError(TextKeys.sorryError.tr());
      return false;
    }
  }
}
