import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rp_mobile/layers/bloc/auth/login/bloc.dart';
import 'package:rp_mobile/layers/services/auth.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'package:rp_mobile/locale/localized_string.dart';

class MockSessionService extends Mock implements SessionService {}

class MockAuthService extends Mock implements AuthService {}

void main() {
  test('default initial state is correct', () async {
    final bloc = LoginBloc(MockSessionService(), MockAuthService());
    expect(bloc.initialState, InitialLoginState());
    bloc.close();
  });

  MockSessionService createSessionService({
    bool isLocked = false,
    bool isLockedThrowError = false,
  }) {
    assert(isLocked != null);
    assert(isLockedThrowError != null);

    final sessionService = MockSessionService();

    if (!isLockedThrowError) {
      when(sessionService.isLoginLocked()).thenAnswer(
        (_) => Future.value(
          LockedResult(
            isLocked: isLocked,
            until: '15:00',
          ),
        ),
      );
    } else {
      when(sessionService.isLoginLocked()).thenThrow(AssertionError());
    }

    return sessionService;
  }

  MockAuthService createAuthService({Object error}) {
    final authService = MockAuthService();

    if (error == null) {
      when(authService.login(any, any)).thenAnswer((_) => Future.value());
    } else {
      when(authService.login(any, any)).thenThrow(error);
    }

    return authService;
  }

  test('load login form', () async {
    final sessionService = createSessionService(isLocked: false);
    final authService = createAuthService();
    final bloc = LoginBloc(sessionService, authService);

    bloc.add(OnStart());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialLoginState(),
        LoadingFormState(),
        LoginFormState(),
      ]),
    );

    verify(sessionService.isLoginLocked());
    verifyNoMoreInteractions(sessionService);

    bloc.close();
  });

  test('load login form failed - lock login', () async {
    final sessionService = createSessionService(isLocked: true);
    final authService = createAuthService();
    final bloc = LoginBloc(sessionService, authService);

    bloc.add(OnStart());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialLoginState(),
        LoadingFormState(),
        LockedState('15:00'),
      ]),
    );

    verify(sessionService.isLoginLocked());
    verifyNoMoreInteractions(sessionService);

    bloc.close();
  });

  test('load login form failed - unhandled exception', () async {
    final sessionService = createSessionService(isLockedThrowError: true);
    final authService = createAuthService();
    final bloc = LoginBloc(sessionService, authService);

    bloc.add(OnStart());

    await expectLater(
      bloc,
      emitsInOrder([
        InitialLoginState(),
        LoadingFormState(),
        RouteCloseLogin(),
      ]),
    );

    verify(sessionService.isLoginLocked());
    verifyNoMoreInteractions(sessionService);

    bloc.close();
  });

  test('login failed - auth exception', () async {
    final sessionService = createSessionService(isLocked: false);
    final authService = createAuthService(
      error: AuthException(
        LocalizedString.fromString('Unexpected error'),
        'Unexpected error',
      ),
    );
    final bloc = LoginBloc(sessionService, authService);

    bloc.add(OnStart());
    bloc.add(OnLogin('foo@bar.ru', '123321'));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialLoginState(),
        LoadingFormState(),
        LoginFormState(),
        LoadingState(),
        ErrorState(LocalizedString.fromString('Unexpected error')),
      ]),
    );

    verify(sessionService.isLoginLocked());
    verifyNoMoreInteractions(sessionService);
    verify(authService.login('foo@bar.ru', '123321'));
    verifyNoMoreInteractions(authService);

    bloc.close();
  });

  test('login failed - locked exception', () async {
    final sessionService = createSessionService(isLocked: false);
    final authService = createAuthService(
      error: LockedAuthException('20:00'),
    );
    final bloc = LoginBloc(sessionService, authService);

    bloc.add(OnStart());
    bloc.add(OnLogin('foo@bar.ru', '123321'));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialLoginState(),
        LoadingFormState(),
        LoginFormState(),
        LoadingState(),
        LockedState('20:00'),
      ]),
    );

    verify(sessionService.isLoginLocked());
    verifyNoMoreInteractions(sessionService);
    verify(authService.login('foo@bar.ru', '123321'));
    verifyNoMoreInteractions(authService);

    bloc.close();
  });

  test('login failed - unhandled exception', () async {
    final sessionService = createSessionService(
      isLocked: false,
    );
    final authService = createAuthService(
      error: AssertionError(),
    );
    final bloc = LoginBloc(sessionService, authService);

    bloc.add(OnStart());
    bloc.add(OnLogin('foo@bar.ru', '123321'));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialLoginState(),
        LoadingFormState(),
        LoginFormState(),
        LoadingState(),
        LoginFormState(),
      ]),
    );

    verify(sessionService.isLoginLocked());
    verifyNoMoreInteractions(sessionService);
    verify(authService.login('foo@bar.ru', '123321'));
    verifyNoMoreInteractions(authService);

    bloc.close();
  });

  test('login success', () async {
    final sessionService = createSessionService(
      isLocked: false,
    );
    final authService = createAuthService();
    final bloc = LoginBloc(sessionService, authService);

    bloc.add(OnStart());
    bloc.add(OnLogin('foo@bar.ru', '123321'));

    await expectLater(
      bloc,
      emitsInOrder([
        InitialLoginState(),
        LoadingFormState(),
        LoginFormState(),
        LoadingState(),
        SuccessState(),
      ]),
    );

    verify(sessionService.isLoginLocked());
    verifyNoMoreInteractions(sessionService);
    verify(authService.login('foo@bar.ru', '123321'));
    verifyNoMoreInteractions(authService);

    bloc.close();
  });
}
