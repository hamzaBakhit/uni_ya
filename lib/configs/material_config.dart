import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uni_ya/features/meals/logic/meals_bloc.dart';
import 'package:uni_ya/features/settings/logic/settings_bloc.dart';
import 'package:uni_ya/features/user/logic/user_bloc.dart';

import '../constants/routes.dart';
import '../sevices/remote/notifications.dart';

class MaterialConfig extends StatefulWidget {
  const MaterialConfig({Key? key}) : super(key: key);

  @override
  State<MaterialConfig> createState() => _MaterialConfigState();
}

class _MaterialConfigState extends State<MaterialConfig> {
  @override
  void initState() {
    context.read<UserBloc>().remember();
    context.read<MealsCubit>().getMeals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      theme:context.watch<SettingsBloc>().state.isLight? ThemeData.light(useMaterial3: true):ThemeData.dark(useMaterial3: true),
      title: 'Yalah',
      initialRoute:(context.read<SettingsBloc>().state.isIntroFinished)? Routes.main:Routes.appIntro,
      routes: Routes().routes,
      builder: EasyLoading.init(),
    );
  }
}
