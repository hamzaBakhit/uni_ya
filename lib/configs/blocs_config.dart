import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya/features/bottom_navigation_bar/bottom_nav_bar_cubit.dart';
import 'package:uni_ya/features/make_order/make_order_bloc.dart';
import 'package:uni_ya/features/my_drawer/my_drawer_cubit.dart';
import 'package:uni_ya/features/orders/logic/orders_bloc.dart';
import 'package:uni_ya/features/user/logic/user_bloc.dart';

import '../features/meals/logic/meals_bloc.dart';
import '../features/settings/logic/settings_bloc.dart';
import 'localization_config.dart';

class BlocsConfig extends StatelessWidget {
  const BlocsConfig({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MyDrawerCubit()),
        BlocProvider(create: (context) => SettingsBloc()),
        BlocProvider(create: (context) => BottomNavBarCubit()),
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(create: (context) => MealsCubit()),
        BlocProvider(create: (context) => OrdersBloc()),
        BlocProvider(create: (context) => MakeOrderBloc()),
      ],
      child: const LocalizationConfig(),
    );
  }
}
