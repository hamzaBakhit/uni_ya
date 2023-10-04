part of 'orders_bloc.dart';

class OrdersEvent {}

class ChangeOrder extends OrdersEvent {
  Order order;

  ChangeOrder(this.order);
}

class GetOrder extends OrdersEvent {
}

class AddOrder extends OrdersEvent {
  Order order;

  AddOrder(this.order);
}
