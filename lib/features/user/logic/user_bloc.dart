import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uni_ya/sevices/remote/notifications.dart';
import 'package:uni_ya/sevices/remote/user_service.dart';

import '../../../sevices/local/local_service.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserSignOutState(user: null)) {
    on<SignInByEmail>(_SignInEmail);
    on<SignInByPhone>(_SignInPhone);
    on<SignInByApple>(_SignInApple);
    on<SignInByFacebook>(_SignInFacebook);
    on<SignInByGoogle>(_SignInGoogle);
    on<SignUpByEmail>(_SignUP);
    on<SignOut>(_SignOut);
    on<ResetPassword>(_reset);
    remember();
  }

  static UserCredential? myUser;

  remember() async {
    late List<String> userParameter;
    userParameter = await LocalService.get.rememberUser();
    String? logInMethod = await LocalService.get.getLocalData('log_in_method');
    print(logInMethod);
    if (logInMethod == LogInMethod.email) {
      if (userParameter[0].isNotEmpty && userParameter[1].isNotEmpty) {
        add(SignInByEmail(
            email: userParameter[0],
            password: userParameter[1],
            remember: true));
      }
    } else if (logInMethod == LogInMethod.google) {
      String? accessToken = await LocalService.get.getLocalData('access_token');
      if (accessToken != null && accessToken.isNotEmpty) {
        add(SignInByGoogle(token: accessToken));
      }
    }
  }
  _SignInEmail(SignInByEmail event, Emitter<UserState> emit) async {
    emit(UserProcess(user: state.user));
    UserCredential? user = await UserService.get
        .SignInByEmail(email: event.email, password: event.password);
    if (user == null) {
      emit(UserSignOutState(user: user));
    } else {
      if (event.remember) {
        LocalService.get.setLocalData({
          "log_in_method": LogInMethod.email,
          'userEmail': event.email,
          'userPassword': event.password
        });
      }
      myUser=user;
      MyNotifications.get.getToken();
      emit(UserSignInState(user: user));
    }
  }

  _reset(ResetPassword event, Emitter<UserState> emit) async {
    emit(UserProcess(user: state.user));
    await UserService.get.resetPassword(email: event.email);
    emit(UserSignOutState(user: null));
  }

  _SignOut(SignOut event, Emitter<UserState> emit) async {
    emit(UserProcess(user: state.user));
    bool isDone = await UserService.get.SignOut();
    if (isDone) {
      LocalService.get
          .deleteLocalData(['log_in_method', 'userEmail', 'userPassword','access_token']);
      emit(UserSignOutState(user: null));
    } else {
      emit(UserSignInState(user: state.user));
    }
  }

  _SignUP(SignUpByEmail event, Emitter<UserState> emit) async {
    emit(UserProcess(user: state.user));
    await UserService.get.createUserByEmail(email: event.email, password: event.password, name: event.name);
    emit(UserSignOutState(user: null));
  }

  _SignInGoogle(SignInByGoogle event, Emitter<UserState> emit) async {
    emit(UserProcess(user: state.user));
    UserCredential? user =
    await UserService.get.signInWithGoogle(token: event.token);
    if (user == null) {
      emit(UserSignOutState(user: user));
    } else {
      myUser=user;
      MyNotifications.get.getToken();
      LocalService.get.setLocalData({
        "log_in_method": LogInMethod.google,
        'access_token': user.credential!.accessToken,
      });
      emit(UserSignInState(user: user));

    }
  }

  _SignInPhone(SignInByPhone event, Emitter<UserState> emit) async {
    emit(UserProcess(user: state.user));

    UserCredential? user = await UserService.get.signInWithPhone(event.phone);
    if (user == null) {
      emit(UserSignOutState(user: user));
    } else {
      emit(UserSignInState(user: user));
    }
  }



  _SignInFacebook(SignInByFacebook event, Emitter<UserState> emit) async {
    emit(UserProcess(user: state.user));
    UserCredential? user = await UserService.get.signInWithFacebook();
    if (user == null) {
      emit(UserSignOutState(user: user));
    } else {
      emit(UserSignInState(user: user));
    }
  }

  _SignInApple(SignInByApple event, Emitter<UserState> emit) async {
    emit(UserProcess(user: state.user));
    UserCredential? user = await UserService.get.signInWithApple();
    if (user == null) {
      emit(UserSignOutState(user: user));
    } else {
      emit(UserSignInState(user: user));
    }
  }



}

class LogInMethod {
  static const String email = 'email';
  static const String google = 'google';
  static const String phone = 'phone';
}
