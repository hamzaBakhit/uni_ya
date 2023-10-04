import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/user_bloc.dart';

class SocialLogBar extends StatelessWidget {
  const SocialLogBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 2 / 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // GestureDetector(
          //   onTap: () {
          //     context.read<UserBloc>().add(SignInByFacebook());
          //   },
          //   child: CircleAvatar(
          //     backgroundColor: Colors.blue,
          //     backgroundImage:
          //         AssetImage('assets/images/Facebook_Logo.png'),
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              context.read<UserBloc>().add(SignInByGoogle());
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Image.asset('assets/images/Google-Logo.png'),
              ),
            ),
          ),
          if(Platform.isIOS)
            GestureDetector(
              onTap: () {
                context.read<UserBloc>().add(SignInByApple());
              },
              child: CircleAvatar(
                backgroundColor: Colors.black,
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Image.asset('assets/images/Google-Logo.png'),
                ),
              ),
            ),
          // CircleAvatar(
          //     backgroundColor: Colors.green,
          //     child: IconButton(
          //         onPressed: () {
          //         context.read<UserBloc>().add(SignInByPhone(phone: '', password: '', name: ''));},
          //         icon: Icon(Icons.phone, color: Colors.white))),

        ],
      ),
    );
  }
}
