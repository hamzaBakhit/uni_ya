import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/settings/logic/settings_bloc.dart';

class BackgroundWidget extends StatelessWidget {
   BackgroundWidget({required this.child,this.isBlur=false,Key? key}) : super(key: key);
   Widget child;
   bool isBlur;

  @override
  Widget build(BuildContext context) {
    return Container(
       
        child:!isBlur?child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
    child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
    child: Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    borderRadius: BorderRadius.circular(25),
    ),
    child: child,))));
  }
}
