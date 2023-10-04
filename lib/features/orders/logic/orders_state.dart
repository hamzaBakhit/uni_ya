part of'orders_bloc.dart';

class OrdersState extends Equatable{
  List<Order> order;

  OrdersState({required this.order});

  @override
  List<Object?> get props => [order];
}


class OrdersProcess extends OrdersState{
  OrdersProcess({required super.order});
}
class OrdersShow extends OrdersState{
  OrdersShow({required super.order});
}