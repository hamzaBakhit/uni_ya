import 'dart:ui';
import 'dart:io' show Platform;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uni_ya/constants/routes.dart';
import 'package:uni_ya/constants/texts.dart';
import 'package:uni_ya/features/user/view/social_log_bar.dart';

import '../../logic/user_bloc.dart';

class LogUPScreen extends StatefulWidget {
  const LogUPScreen({Key? key}) : super(key: key);

  @override
  State<LogUPScreen> createState() => _LogUPScreenState();
}

class _LogUPScreenState extends State<LogUPScreen> {
  bool isPasswordShow = false;
  TextEditingController emailController = TextEditingController(),
      nameController = TextEditingController(),
      conformController = TextEditingController(),
      passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/log_in_background.jpg'),
              fit: BoxFit.fill),
        ),
        child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
          EasyLoading.instance
            ..displayDuration = const Duration(milliseconds: 2000)
            ..indicatorType = EasyLoadingIndicatorType.wave
            ..loadingStyle = EasyLoadingStyle.dark
            ..indicatorSize = 45.0
            ..radius = 10.0
            ..progressColor = Colors.yellow
            ..backgroundColor = Colors.green
            ..indicatorColor = Colors.yellow
            ..textColor = Colors.yellow
            ..maskColor = Colors.blue.withOpacity(0.5)
            ..userInteractions = true
            ..dismissOnTap = false;

          if (state is UserProcess) {
            EasyLoading.show();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 3 / 4,
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
                            border:
                                Border.all(width: 2, color: Colors.white30)),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    TextKeys.logUp.tr(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    TextKeys.welcomeInLogUp.tr(),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return TextKeys.emptyEmail.tr();
                                      } else if (!value.contains('@')) {
                                        return TextKeys.wrongEmail.tr();
                                      }
                                    },
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text(
                                        TextKeys.userEmail.tr(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      suffixIcon: Icon(Icons.email,
                                          color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return TextKeys.emptyName.tr();
                                      }
                                    },
                                    controller: nameController,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text(
                                        TextKeys.userName.tr(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      suffixIcon: Icon(Icons.person,
                                          color: Colors.black),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return TextKeys.emptyPassword.tr();
                                      } else if (conformController.value.text !=
                                          value) {
                                        return TextKeys.notIdenticalPassword
                                            .tr();
                                      }
                                    },
                                    controller: passwordController,
                                    obscureText: !isPasswordShow,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text(
                                        TextKeys.password.tr(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      suffixIcon: IconButton(
                                          onPressed: () => setState(() {
                                                isPasswordShow =
                                                    !isPasswordShow;
                                              }),
                                          icon: Icon(
                                              isPasswordShow
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.black)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return TextKeys.emptyPassword.tr();
                                      } else if (passwordController
                                              .value.text !=
                                          value) {
                                        return TextKeys.notIdenticalPassword
                                            .tr();
                                      }
                                    },
                                    controller: conformController,
                                    obscureText: !isPasswordShow,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      label: Text(
                                        TextKeys.passwordConform.tr(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      suffixIcon: IconButton(
                                          onPressed: () => setState(() {
                                                isPasswordShow =
                                                    !isPasswordShow;
                                              }),
                                          icon: Icon(
                                              isPasswordShow
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.black)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {}
                                      context
                                          .read<UserBloc>()
                                          .add(SignUpByEmail(
                                            email: emailController.value.text
                                                .trim(),
                                            password: passwordController
                                                .value.text
                                                .trim(),
                                            name: nameController.value.text
                                                .trim(),
                                          ));
                                    },
                                    child: Text(TextKeys.logUp.tr()),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              Colors.black),
                                      foregroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              Colors.white),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        TextKeys.haveAccount.tr(),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pushNamed(
                                            context, Routes.logIn),
                                        child: Text(
                                          TextKeys.logIn,
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
              ),
              SizedBox(height: 24),
              SocialLogBar(),
            ],
          );
        }),
      ),
    );
  }
}
