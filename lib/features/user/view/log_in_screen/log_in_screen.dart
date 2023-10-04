import 'dart:ui';
import 'dart:io' show Platform;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uni_ya/constants/routes.dart';
import 'package:uni_ya/constants/texts.dart';
import 'package:uni_ya/features/user/logic/user_bloc.dart';
import 'package:uni_ya/features/user/view/social_log_bar.dart';
import 'package:uni_ya/ui/widgets/loading.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool isPasswordShow = false, isRememberMe = true;
  TextEditingController emailController = TextEditingController(),
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
          if (state is UserSignInState && state.user!.user != null) {
            EasyLoading.showSuccess('Hi, ${state.user!.user!.displayName}',
                    duration: const Duration(seconds: 1))
                .then((value) {
              if (Navigator.canPop(context))
                Navigator.pushReplacementNamed(context, Routes.main);
            });
          }
          return Stack(
            children: [
              Positioned.fill(
                child: Column(
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
                                  border: Border.all(
                                      width: 2, color: Colors.white30)),
                              child: Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          TextKeys.logIn.tr(),
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
                                          TextKeys.welcomeInLogIn.tr(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return TextKeys.emptyEmail.tr();
                                            } else if (!value.contains('@')) {
                                              return TextKeys.wrongEmail.tr();
                                            }
                                          },
                                          controller: emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            label: Text(
                                              TextKeys.userEmail.tr(),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            suffixIcon: Icon(Icons.person,
                                                color: Colors.black),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return TextKeys.emptyPassword
                                                  .tr();
                                            }
                                          },
                                          controller: passwordController,
                                          obscureText: !isPasswordShow,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            label: Text(
                                              TextKeys.password.tr(),
                                              style: TextStyle(
                                                  color: Colors.black),
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
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Checkbox(
                                                activeColor: Colors.black,
                                                value: isRememberMe,
                                                onChanged: (value) =>
                                                    setState(() {
                                                      isRememberMe = value!;
                                                    })),
                                            Text(TextKeys.rememberMe.tr()),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {}
                                            context.read<UserBloc>().add(
                                                SignInByEmail(
                                                    email: emailController
                                                        .value.text
                                                        .trim(),
                                                    password: passwordController
                                                        .value.text
                                                        .trim(),
                                                    remember: isRememberMe));
                                          },
                                          child: Text(TextKeys.logIn.tr()),
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
                                        child: TextButton(
                                            onPressed: () {
                                              context.read<UserBloc>().add(
                                                  ResetPassword(emailController
                                                      .value.text
                                                      .trim()));
                                            },
                                            child: Text(
                                              TextKeys.forgetPassword.tr(),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Text(
                                              TextKeys.doNotHaveAccount.tr(),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pushNamed(
                                                      context, Routes.logUP),
                                              child: Text(
                                                TextKeys.logUp,
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FontStyle.italic),
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
                ),
              ),
              if (state is UserProcess) LoadingWidget(),
            ],
          );
        }),
      ),
    );
  }
}
