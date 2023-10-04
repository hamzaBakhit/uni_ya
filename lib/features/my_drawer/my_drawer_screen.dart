import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya/constants/routes.dart';
import 'package:uni_ya/constants/texts.dart';
import 'package:uni_ya/features/my_drawer/my_drawer_cubit.dart';
import 'package:uni_ya/sevices/connection.dart';

import '../user/logic/user_bloc.dart';

class MyDrawerScreen extends StatelessWidget {
  const MyDrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.1, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.15,
                backgroundImage: const AssetImage('assets/images/logo.jpg')),
          ),
          Text('Yallah',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color!,
                  fontWeight: FontWeight.bold,
                  fontSize: 32)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(),
          ),
          const Expanded(child: MyDrawerBody()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
                onPressed: () async{
                  if(await checkConnection(context)){
                    context.read<MyDrawerCubit>().toggle();
                    context.read<UserBloc>().add(SignOut());
                    Navigator.pushNamed(context, Routes.logIn);
                  }
                },
                child: Text(
                  (context.read<UserBloc>().state is UserSignInState)? TextKeys.logOut.tr():TextKeys.logIn.tr(),
                  style: TextStyle(color:Theme.of(context).textTheme.bodyLarge!.color!),
                ),
                style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Theme.of(context).textTheme.bodyLarge!.color!)))),
          ),
        ],
      ),
    );
  }
}

class MyDrawerBody extends StatelessWidget {
  const MyDrawerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [

        ListTile(
          title: Text(TextKeys.history.tr()),
          onTap: () {Navigator.pushNamed(context, Routes.history);},
          leading: Icon(Icons.history),
        ),
        ListTile(
          title: Text(TextKeys.settings.tr()),
          onTap: (){Navigator.pushNamed(context, Routes.settings);context.read<MyDrawerCubit>().toggle();},
          leading: Icon(Icons.settings),
        ),
      ],
    );
  }
}
