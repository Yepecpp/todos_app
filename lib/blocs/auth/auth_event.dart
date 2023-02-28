part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthEventInitial extends AuthEvent {
  AuthEventInitial();
}

class AuthEventLogIn extends AuthEvent {
  final ILogin login;
  AuthEventLogIn({required this.login});
}

class AuthEventLogOut extends AuthEvent {
  final Auth auth;
  AuthEventLogOut({
    required this.auth,
  });
}
