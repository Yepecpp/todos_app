import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos_app/models/login.m.dart';
import '../models/auth.m.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {});
    on<AuthEventInitial>((event, emit) async {
      final auth = await ILogin(username: '', password: '').getAuth();
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
      emit(AuthInitial());
    });
  }
}
/* if (event is AuthEventInitial) {
        final auth = await ILogin(username: '', password: '').getAuth();
        if (auth.status == 200) {
          emit(AuthLoggedIn(auth));
        } else {
          emit(AuthInitial());
        }
      }
      if (event is AuthEventLogIn) {
        final auth = await event.login.login();
        if (auth.status == 200) {
          emit(AuthLoggedIn(auth));
        } else {
          emit(AuthInitial());
        }
      }
      if (event is AuthEventLogOut) {
        emit(AuthInitial());
      } */
