import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is OnLoginButtonClick) {
      yield RouteLoginState();
    } else if (event is OnRegistrationButtonClick) {
      yield RouteRegistrationState();
    } else if (event is OnFAQButtonClick) {
      yield RouteFAQState();
    } else {
      throw UnsupportedError('Unsupported event $event');
    }
  }
}
