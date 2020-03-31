import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rp_mobile/layers/services/auth.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'bloc.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final SessionService _sessionService;
  final AuthService authService;
  RegistrationState _checkpoint;

  RegistrationBloc(this._sessionService, this.authService);

  @override
  RegistrationState get initialState => InitialRegistrationState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    add(OnUnhandledException());
  }

  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    if (event is OnUnhandledException) {
      if (_checkpoint == null || _checkpoint is InitialRegistrationState) {
        yield RouteCloseRegistration();
      } else {
        yield _checkpoint;
      }

      _checkpoint = null;
    } else if (event is OnStart) {
      _checkpoint = state;
      yield* _checkLockState();
    } else if (event is OnRegistration) {
      _checkpoint = state;
      yield* _registration(event);
    }
  }

  Stream<RegistrationState> _checkLockState() async* {
    yield LoadingFormState();
    final lockedResult = await _sessionService.isLoginLocked();

    if (lockedResult.isLocked) {
      yield LockedState(lockedResult.until);
    } else {
      yield RegistrationFormState();
    }
  }

  Stream<RegistrationState> _registration(OnRegistration event) async* {
    yield LoadingState();
    final lockedResult = await _sessionService.isLoginLocked();

    if (lockedResult.isLocked) {
      yield LockedState(lockedResult.until);
    } else {
      try {
        await authService.register(event.email, event.password, event.matchingPassword, '', '');
        yield SuccessState();
      } on LockedAuthException catch (e) {
        yield LockedState(e.until);
      } on AuthException catch (e) {
        yield ErrorState(e.localizedMessage);
      }
    }
  }
}
