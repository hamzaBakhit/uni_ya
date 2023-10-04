import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../ui/widgets/delete_alert.dart';
import '../../features/orders/model/order.dart';
import 'older_details.dart';

class OrderItem extends StatelessWidget {
  OrderItem({required this.order,Key? key}) : super(key: key);
  Order order ;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          Order.showDate(order.orderDate),
          style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
              decoration: TextDecoration.underline),
        ),
         Container(
            margin: EdgeInsets.all(8),
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.30),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(width: 2, color: Colors.white30)),
                  child: ListTile(
                    onTap: () {Navigator.push(context,MaterialPageRoute(builder: (context)=>ControlOrderDetails(order: order)));},
                    leading:(order.state==OrderState.unfinished)? Icon(Icons.circle_outlined):(order.state==OrderState.finished)? Icon(Icons.check_circle,color: Colors.green,)
                   :null,
                    title: Text(order.userName),
                    trailing: Text('\$${order.totalPrice.toStringAsFixed(2)}'),
                    subtitle: Text('Id: ${order.id}'),
                  ),
                ),
              ),
            ),
          ),

      ],
    );
  }


}
