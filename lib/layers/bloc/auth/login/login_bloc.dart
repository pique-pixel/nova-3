import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rp_mobile/layers/services/auth.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SessionService _sessionService;
  final AuthService authService;
  LoginState _checkpoint;

  LoginBloc(this._sessionService, this.authService);

  @override
  LoginState get initialState => InitialLoginState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    add(OnUnhandledException());
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is OnUnhandledException) {
      if (_checkpoint == null || _checkpoint is InitialLoginState) {
        yield RouteCloseLogin();
      } else {
        yield _checkpoint;
      }

      _checkpoint = null;
    } else if (event is OnStart) {
      _checkpoint = state;
      yield* _checkLockState();
    } else if (event is OnLogin) {
      _checkpoint = state;
      yield* _login(event);
    }
  }

  Stream<LoginState> _checkLockState() async* {
    yield LoadingFormState();
    final lockedResult = await _sessionService.isLoginLocked();

    if (lockedResult.isLocked) {
      yield LockedState(lockedResult.until);
    } else {
      yield LoginFormState();
    }
  }

  Stream<LoginState> _login(OnLogin event) async* {
    yield LoadingState();
    final lockedResult = await _sessionService.isLoginLocked();

    if (lockedResult.isLocked) {
      yield LockedState(lockedResult.until);
    } else {
      try {
        await authService.login(event.email, event.password);
        yield SuccessState();
      } on LockedAuthException catch (e) {
        yield LockedState(e.until);
      } on AuthException catch (e) {
        yield ErrorState(e.localizedMessage);
      }
    }
  }
}
