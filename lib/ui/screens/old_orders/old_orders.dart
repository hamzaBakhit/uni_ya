import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya/constants/texts.dart';
import 'package:uni_ya/features/orders/logic/orders_bloc.dart';
import 'package:uni_ya/features/user/logic/user_bloc.dart';

import '../../widgets/backgruond.dart';
import '../../widgets/empty.dart';
import '../../widgets/loading.dart';
import '../../widgets/order_item.dart';
import '../../widgets/sign_in_first.dart';

class OldOrdersScreen extends StatefulWidget {
  const OldOrdersScreen({Key? key}) : super(key: key);

  @override
  State<OldOrdersScreen> createState() => _OldOrdersScreenState();
}

class _OldOrdersScreenState extends State<OldOrdersScreen> {
  @override
  void initState() {
    if (context.read<UserBloc>().state is UserSignInState) {
      context.read<OrdersBloc>().add(GetOrder());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      isBlur: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(TextKeys.history.tr()),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          padding: EdgeInsets.all(8),
          child: BlocBuilder<OrdersBloc, OrdersState>(builder: (context, state) {
            if (context.read<UserBloc>().state is! UserSignInState) {
              return SignInFirst();
            }
            if (state is OrdersProcess) {
              return LoadingWidget();
            } else if (state is OrdersShow && state.order.isNotEmpty) {
              return ListView(
                children:
                    state.order.map((e) => OrderItem(order: e)).toList(),
              );
            } else {
              return EmptyScreen();
            }
          }),
        ),
      ),
    );
  }
}
