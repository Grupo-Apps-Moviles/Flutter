import 'package:waypass_app/features/auth/domain/user.dart';

sealed class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;
  LoginSuccess({required this.user});
}

class SignUpSuccess extends LoginState {
  final String message;
  SignUpSuccess({this.message = "Registro correcto"});
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure({required this.error});
}