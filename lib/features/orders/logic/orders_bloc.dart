import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya/features/user/logic/user_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart'as fb;

import '../../../sevices/remote/orders_service.dart';
import '../model/order.dart';

part 'orders_event.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {

  OrdersBloc() : super(OrdersProcess(order:[])) {

    on<GetOrder>(_getOrders);
    on<ChangeOrder>(_change);
    on<AddOrder>(_add);
  }
  static Stream<fb.QuerySnapshot<Object?>> data (){
   return OrdersRemoteService.get().getStreamOrders(
    );
  }


  _getOrders(GetOrder event, Emitter<OrdersState> emit) async{
    emit(OrdersProcess(order: state.order));
    List<Order> orders=[];
    orders=state.order;
    if(UserBloc.myUser!=null&&UserBloc.myUser!.user!=null&&UserBloc.myUser!.user!.email!=null){
      orders=await OrdersRemoteService.get().getOldOrders(UserBloc.myUser!.user!.email!);
    }
    if(orders.isEmpty){
      emit(OrdersShow(order: state.order));

    }else{
      emit(OrdersShow(order: orders));
    }
  }

  _change(ChangeOrder event, Emitter<OrdersState> emit) async {
    emit(OrdersProcess(order: state.order));
    List<Order> orders=[];
    orders=state.order;
    bool isDone=await OrdersRemoteService.get().updateOrder(event.order);
    if(isDone){
      orders.removeWhere((e)=>e.id==event.order.id);
      orders.add(event.order);
      emit(OrdersShow(order: state.order));
    }else{
      emit(OrdersShow(order: orders));
    }
  }

  _add(AddOrder event, Emitter<OrdersState> emit) async {
    emit(OrdersProcess(order: state.order));
    List<Order> orders=[];
    orders=state.order;
    bool isDone=await OrdersRemoteService.get().addOrder(event.order);
    if(isDone){
      orders.add(event.order);
      emit(OrdersShow(order: state.order));

    }else{
      emit(OrdersShow(order: orders));

    }
  }



}
