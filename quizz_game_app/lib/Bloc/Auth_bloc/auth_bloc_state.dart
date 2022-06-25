part of 'auth_bloc_bloc.dart';

@immutable
abstract class AuthBlocState {
  final User? user;
  AuthBlocState({this.user});
}

class AuthInitialState extends AuthBlocState {}

class AuthLoadingState extends AuthBlocState {}

class AuthLogoutState extends AuthBlocState {}

class AuthSuccessState extends AuthBlocState {
  String role;
  AuthSuccessState(User? user, this.role) : super(user: user);
}

class AuthErrorState extends AuthBlocState {
  String? errorMessage;
  AuthErrorState({this.errorMessage, User? user}) : super(user: user);
}

class GetUserState extends AuthBlocState{
  UserModal? mUser;
  GetUserState({this.mUser, User? user}) : super(user: user);
}

class NotGetUserState extends AuthBlocState{
  String? error;
  NotGetUserState({this.error});
}

class ChangePasswordSuccessState extends AuthBlocState{
  User user;
  ChangePasswordSuccessState(this.user);
}

class ChangeEmailSuccessState extends AuthBlocState{
  User user;
  ChangeEmailSuccessState(this.user);
}
