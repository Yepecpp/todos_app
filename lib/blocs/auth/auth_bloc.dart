// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:todos_app/models/login.m.dart';
import 'package:todos_app/models/auth.m.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial(auth: Auth(status: 0))) {
    on<AuthEvent>((event, emit) async {});
    on<AuthEventInitial>((event, emit) async {
      final login = ILogin(username: '', password: '');
      emit(AuthLoading(login: login));
      final auth = await login.getAuth();
      if (auth.status == 200) {
        emit(AuthLoggedIn(auth));
      } else {
        emit(AuthInitial(auth: auth));
      }
    });
    on<AuthEventLogIn>((event, emit) async {
      emit(AuthLoading(login: event.login));

      final auth = await event.login.login();
      if (auth.status == 200) {
        emit(AuthLoggedIn(auth));
      } else {
        emit(AuthInitial(auth: auth, login: event.login));
      }
    });
    on<AuthEventLogOut>((event, emit) async {
      await event.auth.logOut();
      emit(AuthInitial(auth: Auth(status: 0)));
    });
  }
}
