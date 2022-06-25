part of 'auth_bloc_bloc.dart';

@immutable
abstract class AuthBlocEvent {}

class AuthInitialEvent extends AuthBlocEvent{}

class LoginWithEmailEvent extends AuthBlocEvent{
  String email;
  String password;
  LoginWithEmailEvent({required this.email, required this.password});
}

class RegisterWithEmailEvent extends AuthBlocEvent{
  String email;
  String password;
  RegisterWithEmailEvent({required this.email, required this.password});
}

class LoginWithGoogleEvent extends AuthBlocEvent{}

class LogoutEvent extends AuthBlocEvent{}

class AuthListenerEvent extends AuthBlocEvent{
  User? user;
  AuthListenerEvent({this.user});
}

class GetUserEvent extends AuthBlocEvent{
  String email;
  GetUserEvent({required this.email});
}

class ChangePasswordEvent extends AuthBlocEvent{
  String email;
  String password;
  String nPassword;
  ChangePasswordEvent({required this.email,required this.password, required this.nPassword});
}

class ChangeEmailEvent extends AuthBlocEvent{
  UserModal user;
  String email;
  String password;
  String nemail;
  ChangeEmailEvent({required this.user, required this.email,required this.password, required this.nemail});
}





