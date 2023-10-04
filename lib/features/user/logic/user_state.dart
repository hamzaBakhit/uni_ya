part of'user_bloc.dart';

class UserState extends Equatable{
  UserCredential? user;

  UserState({required this.user});
  @override
  List<Object> get props =>[];
}

class UserSignInState extends UserState{
  UserSignInState({required super.user});
}
class UserSignOutState extends UserState{
  UserSignOutState({required super.user});
}
class UserProcess extends UserState{
  UserProcess({required super.user});
}
