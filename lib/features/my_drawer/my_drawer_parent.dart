
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:uni_ya/features/my_drawer/my_drawer_screen.dart';
import 'package:uni_ya/ui/screens/home/home.dart';

import 'my_drawer_cubit.dart';

class MyDrawerParent extends StatelessWidget {
  const MyDrawerParent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ZoomDrawer(
      controller: context.read<MyDrawerCubit>().controller,
      style: DrawerStyle.defaultStyle,
      menuScreen:const MyDrawerScreen(),
      mainScreen:const MainScreen(),
      androidCloseOnBackTap: true,
      mainScreenTapClose: true,
      menuScreenTapClose: true,
      overlayBlur: 0.75,
      borderRadius: 24.0,
      showShadow: true,
      angle: 0.0,
      drawerShadowsBackgroundColor: Colors.grey.shade300,
      slideWidth: MediaQuery.of(context).size.width*.65,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
    );
  }
}
