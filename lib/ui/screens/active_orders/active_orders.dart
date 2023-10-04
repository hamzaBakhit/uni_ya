import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya/features/user/logic/user_bloc.dart';
import 'package:uni_ya/sevices/remote/notifications.dart';
import 'package:uni_ya/ui/widgets/empty.dart';
import 'package:uni_ya/ui/widgets/loading.dart';
import 'package:uni_ya/ui/widgets/sign_in_first.dart';

import '../../../features/orders/logic/orders_bloc.dart';
import '../../../features/orders/model/order.dart';
import '../../widgets/order_item.dart';

class ActiveOrders extends StatelessWidget {
  const ActiveOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (context.read<UserBloc>().state is ! UserSignInState)
          ? SignInFirst()
          : StreamBuilder<fb.QuerySnapshot<Object?>>(
              stream: OrdersBloc.data(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null&& snapshot.data!.docs.isNotEmpty) {
                  return ListView(
                      children: snapshot.data!.docs
                          .map((e) => Order.fromMap(order: e))
                          .map(
                            (e) => OrderItem(order: e),
                          )
                          .toList());
                }  else if(snapshot.connectionState==ConnectionState.waiting){
                  return LoadingWidget();
                }else{
                  return EmptyScreen();
                }
              }),
    );
  }
}
