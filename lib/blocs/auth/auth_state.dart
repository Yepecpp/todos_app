part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {
  final Auth auth = Auth(status: 0);
  AuthInitial();
}

class AuthLoading extends AuthState {
  final ILogin login;
  AuthLoading({
    required this.login,
  });
}

class AuthLoggedIn extends AuthState {
  final Auth auth;
  AuthLoggedIn(this.auth);
}
