import 'package:cloud_firestore/cloud_firestore.dart' as fb;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya/constants/routes.dart';
import 'package:uni_ya/features/orders/logic/orders_bloc.dart';

import '../../../ui/widgets/empty.dart';
import '../../../ui/widgets/loading.dart';
import '../../../ui/widgets/order_item.dart';
import '../../../ui/widgets/sign_in_first.dart';
import '../../user/logic/user_bloc.dart';
import '../model/order.dart';

class Bill extends StatefulWidget {
  const Bill({super.key});

  @override
  State<Bill> createState() => _BillState();
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}

class _BillState extends State<Bill> {
  String? id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F0EA),
        body: Container(
          child: (context.read<UserBloc>().state is! UserSignInState)
              ? SignInFirst()
              : StreamBuilder<fb.QuerySnapshot<Object?>>(
                  stream: OrdersBloc.data(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.docs.isNotEmpty) {
                      // for(int i=0; i>0; i++){
                      //   if(snapshot.data!.docs[i]["status"] == "unfinished"){
                      //     setState(() {
                      //       id = snapshot.data!.docs[i]["id"];
                      //     });
                      //   }
                      // }

                      // return Center(child: Text(id??"no"));
                      return Stack(
                        children: [
                          ListView(
                            children: [
                              snapshot.data!.docs
                                  .where((e) => e.get('state') == 'unfinished')
                                  .where((e) => e.get('state') != 'completed')
                                  .where((e) => e.get('state') != 'finished')
                                  .where((e) => e.get('state') != 'canceled')
                                  .map((e) => Order.fromMap(order: e))
                                  .map(
                                    (e) => Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      // SizedBox(height: 120,),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/ticket.png",
                                            height: 800,
                                          ),

                                          Column(
                                            children: [
                                              Text(
                                                e.id.lastChars(2),
                                                style: TextStyle(
                                                    fontSize: 48,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Hora de retiro: ${DateFormat('kk:mm').format(e.orderDate)}",
                                                    style:  const TextStyle(
                                                      fontSize: 14,

                                                    ),
                                                  ),
                                                  SizedBox(height: 30,),
                                                  const  Text(
                                                    "Muchas Gracias por ",
                                                    style:  TextStyle(
                                                      fontSize: 14,

                                                    ),
                                                  ),
                                                  const  Text(
                                                    "tu comparo!",
                                                    style:  TextStyle(
                                                      fontSize: 14,

                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 120,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                                  .toList()
                                  .first
                            ],
                          ),
                          Positioned(
                            bottom: 50,
                            left: 150,
                            right: 150,
                            child: ElevatedButton(onPressed: (){
                              Navigator.pushNamed(context, Routes.main);
                            }, child: Text("Exit")),
                          )
                        ],
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return LoadingWidget();
                    } else {
                      return EmptyScreen();
                    }
                  }),
        ));
  }
}
