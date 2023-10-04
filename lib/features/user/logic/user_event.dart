part of 'user_bloc.dart';

class UserEvent {}

class SignInByEmail extends UserEvent {
  String email, password;
  bool remember;

  SignInByEmail({required this.email, required this.password,required this.remember});
}

class SignInByGoogle extends UserEvent {
  String? token;
  SignInByGoogle({this.token});
}

class SignInByFacebook extends UserEvent {}

class SignInByApple extends UserEvent {}

class SignUpByEmail extends UserEvent {
  String email, password,name;

  SignUpByEmail({required this.email, required this.password,required this.name});
}
class SignInByPhone extends UserEvent {
  String phone, password,name;

  SignInByPhone({required this.phone, required this.password,required this.name});
}

class ResetPassword extends UserEvent {
  String email;

  ResetPassword(this.email);
}

class SignOut extends UserEvent {}
