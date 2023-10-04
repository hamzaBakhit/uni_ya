import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:uni_ya/constants/texts.dart';
import 'package:uni_ya/sevices/remote/notifications.dart';
import 'package:uuid/uuid.dart';

import '../../meals/models/addition.dart';
import '../../meals/models/meal.dart';

class Order extends Equatable {
  late DateTime orderDate, sendDate;
  String userName, userEmail, note, state, paymentMethod, token;
  double totalPrice;
  late String id;
  List<Map> meals, additions;

  Order({
    required this.additions,
    required this.meals,
    this.paymentMethod = PaymentMethod.cash,
    this.userName = '',
    this.userEmail = '',
    this.token = '',
    this.note = '',
    this.state = OrderState.unfinished,
    this.totalPrice = 0,
  }) {
    id = const Uuid().v4();
    orderDate = DateTime.now();
    sendDate = DateTime.now();
  }

  setUserName(value) => userName = value;

  setUserEmail(value) => userEmail = value;

  setNote(value) => note = value;

  setState(value) => state = value;

  setDate(value) => orderDate = value;

  setSendDate(value) => sendDate = value;

  setId(value) => id = value;

  setTotalPrice(value) => totalPrice = value;

  setPaymentMethod(value) => paymentMethod = value;

  static String showDate(DateTime date) {
    if (date.day == DateTime.now().day && date.month == DateTime.now().month) {
      return '${TextKeys.today.tr()}  --  ${DateFormat('h:mm aa').format(date)}';
    } else if (date.day == DateTime.now().day + 1 &&
        date.month == DateTime.now().month) {
      return '${TextKeys.tomorrow.tr()}  --  ${DateFormat('h:mm aa').format(date)}';
    } else if (date.day == DateTime.now().day - 1 &&
        date.month == DateTime.now().month) {
      return '${TextKeys.yesterday.tr()}  --  ${DateFormat('h:mm aa').format(date)}';
    } else {
      return DateFormat('dd/MM/yyyy  --  h:mm aa').format(date);
    }
  }

  static List<Map> getMeals(List<Meal> _meals) => _meals
      .map((e) => {
    'id': e.id,
    'title': e.title,
    'price': e.price,
    'count': e.count,
    "img": e.img
  })
      .toList();

  static List<Meal> setMeals(List<Map> _meals) => _meals
      .map((e) {
    Meal m= Meal(
        title: e['title'],
        price: e['price'],
        count: e['count'],
        img: e['img'],
        additions: [],
        groups: []);
    m.setId(e['id']);
    return m;
  })
      .toList();
  static List<Map> getAdditions(Map<String, List<Addition>> _addition) {
    List<Map> myAddition = [];
    _addition.forEach((key, value) {
      value.forEach((e) {
        myAddition.add({
          'meal': key,
          'id': e.id,
          'title': e.title,
          'price': e.price,
          'count': e.count,
          "img": e.img
        });
      });
    });
    return myAddition;
  }
  static List<Map<String,Addition>> setAdditions(List<Map> _additions) => _additions
      .map((e) {
    Addition a= Addition(
      title: e['title'],
      price: e['price'],
      count: e['count'],
      img: e['img'],
    );
    a.setId(e['id']);
    Map<String,Addition> m={e['meal']+'=='+a.id:a};
    return m ;

  })
      .toList();



  Order.fromMap({
    this.additions = const [],
    this.meals = const [],
    this.paymentMethod = PaymentMethod.cash,
    this.userName = '',
    this.userEmail = '',
    this.note = '',
    this.token = '',
    this.state = OrderState.unfinished,
    this.totalPrice = 0,
    required QueryDocumentSnapshot order,
  }) {
    meals = [];
    for (var m in order.get('meals')) {
      meals.add(m);
    }
    additions = [];
    for (var a in order.get('additions')) {
      additions.add(a);
    }
    Timestamp date = order.get('date');
    Timestamp send = order.get('sendDate');
    double price = double.parse(order.get('totalPrice'));

    userEmail = order.get('userEmail');
    userName = order.get('userName');
    state = order.get('state');
    note = order.get('note');
    token = order.get('token');
    paymentMethod = order.get('paymentMethod');
    totalPrice = price;
    orderDate = date.toDate();
    sendDate = send.toDate();
    id = order.get('id');
  }

  Map<String, dynamic> toMap() {
    return {
      'additions': additions,
      'meals': meals,
      'id': id,
      'userEmail': userEmail,
      'userName': userName,
      'paymentMethod': paymentMethod,
      'note': note,
      'token': MyNotifications.get.token,
      'state': state,
      'date': Timestamp.fromDate(orderDate),
      'sendDate': Timestamp.fromDate(sendDate),
      'totalPrice': totalPrice.toString(),
    };
  }

  @override
  List<Object> get props => [
    token,
    orderDate,
    sendDate,
    userName,
    userEmail,
    note,
    state,
    paymentMethod,
    totalPrice,
    id,
    meals,
    additions
  ];
}

class OrderState {
  static const String canceled = 'canceled';
  static const String completed = 'completed';
  static const String finished = 'finished';
  static const String unfinished = 'unfinished';
}

class PaymentMethod {
  static const String cash = 'cash';
  static const String visa = 'visa';
  static const String google = 'google';
  static const String apple = 'apple';
}
