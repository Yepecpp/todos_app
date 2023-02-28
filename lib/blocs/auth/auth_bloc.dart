// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos_app/models/login.m.dart';
import 'package:todos_app/models/auth.m.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {});
    on<AuthEventInitial>((event, emit) async {
      final login = ILogin(username: '', password: '');
      emit(AuthLoading(login: login));
      final auth = await login.getAuth();
      if (auth.status == 200) {
        emit(AuthLoggedIn(auth));
      } else {
        emit(AuthInitial());
      }
    });
    on<AuthEventLogIn>((event, emit) async {
      final auth = await event.login.login();
      if (auth.status == 200) {
        emit(AuthLoggedIn(auth));
      } else {
        emit(AuthInitial());
      }
    });
    on<AuthEventLogOut>((event, emit) async {
      await event.auth.logOut();
      emit(AuthInitial());
    });
  }
}
