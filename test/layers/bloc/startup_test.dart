import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:optional/optional.dart';
import 'package:rp_mobile/layers/bloc/startup/bloc.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'package:rp_mobile/layers/drivers/api/session.dart';

class MockSessionService extends Mock implements SessionService {}

class MockSession extends Mock implements Session {}

void main() {
  test('default initial state is correct', () async {
    final bloc = StartupBloc(MockSessionService());
    expect(bloc.initialState, InitialStartupState());
    bloc.close();
  });

  MockSessionService createSessionService({
    Session session,
    bool shouldDisplayTips,
  }) {
    assert(shouldDisplayTips != null);

    final sessionService = MockSessionService();

    when(sessionService.loadSession())
        .thenAnswer((_) => Future.value(Optional.ofNullable(session)));

    when(sessionService.shouldDisplayTips())
        .thenAnswer((_) => Future.value(shouldDisplayTips));

    return sessionService;
  }

  MockSession createSession({bool hasExpired}) {
    assert(hasExpired != null);

    final session = MockSession();

    when(session.hasExpired()).thenReturn(hasExpired);

    return session;
  }

  test(
    'if session isn\'t presentend and should display tips',
    () async {
      final sessionService = createSessionService(shouldDisplayTips: true);
      final bloc = StartupBloc(sessionService);

      bloc.add(OnStart());

      await expectLater(
        bloc,
        emitsInOrder([
          InitialStartupState(),
          LoadingSession(),
          RouteTipsState(),
        ]),
      );

      verify(sessionService.loadSession());
      verify(sessionService.shouldDisplayTips());
      verifyNoMoreInteractions(sessionService);

      bloc.close();
    },
  );

  test(
    'if session isn\'t presentend and shouldn\'t display tips',
    () async {
      final sessionService = createSessionService(shouldDisplayTips: false);
      final bloc = StartupBloc(sessionService);

      bloc.add(OnStart());

      await expectLater(
        bloc,
        emitsInOrder([
          InitialStartupState(),
          LoadingSession(),
          RouteWelcomeState(),
        ]),
      );

      verify(sessionService.loadSession());
      verify(sessionService.shouldDisplayTips());
      verifyNoMoreInteractions(sessionService);

      bloc.close();
    },
  );

  test(
    'if session is presentend and session hasn\'t expired and should display tips',
    () async {
      final session = createSession(hasExpired: false);
      final sessionService = createSessionService(
        session: session,
        shouldDisplayTips: true,
      );
      final bloc = StartupBloc(sessionService);

      bloc.add(OnStart());

      await expectLater(
        bloc,
        emitsInOrder([
          InitialStartupState(),
          LoadingSession(),
          RouteDashboardState(),
        ]),
      );

      verify(sessionService.loadSession());
      verifyNoMoreInteractions(sessionService);
      verify(session.hasExpired());
      verifyNoMoreInteractions(session);

      bloc.close();
    },
  );

  test(
    'if session is presentend and session has expired and should display tips',
    () async {
      final session = createSession(hasExpired: true);
      final sessionService = createSessionService(
        session: session,
        shouldDisplayTips: true,
      );
      final bloc = StartupBloc(sessionService);

      bloc.add(OnStart());

      await expectLater(
        bloc,
        emitsInOrder([
          InitialStartupState(),
          LoadingSession(),
          RouteTipsState(),
        ]),
      );

      verify(sessionService.loadSession());
      verify(sessionService.shouldDisplayTips());
      verifyNoMoreInteractions(sessionService);
      verify(session.hasExpired());
      verifyNoMoreInteractions(session);

      bloc.close();
    },
  );

  test(
    'if session is presentend and session hasn\'t expired and shouldn\'t display tips',
    () async {
      final session = createSession(hasExpired: false);
      final sessionService = createSessionService(
        session: session,
        shouldDisplayTips: false,
      );
      final bloc = StartupBloc(sessionService);

      bloc.add(OnStart());

      await expectLater(
        bloc,
        emitsInOrder([
          InitialStartupState(),
          LoadingSession(),
          RouteDashboardState(),
        ]),
      );

      verify(sessionService.loadSession());
      verifyNoMoreInteractions(sessionService);
      verify(session.hasExpired());
      verifyNoMoreInteractions(session);

      bloc.close();
    },
  );

  test(
    'if session is presentend and session has expired and shouldn\'t display tips',
    () async {
      final session = createSession(hasExpired: true);
      final sessionService = createSessionService(
        session: session,
        shouldDisplayTips: false,
      );
      final bloc = StartupBloc(sessionService);

      bloc.add(OnStart());

      await expectLater(
        bloc,
        emitsInOrder([
          InitialStartupState(),
          LoadingSession(),
          RouteWelcomeState(),
        ]),
      );

      verify(sessionService.loadSession());
      verify(sessionService.shouldDisplayTips());
      verifyNoMoreInteractions(sessionService);
      verify(session.hasExpired());
      verifyNoMoreInteractions(session);

      bloc.close();
    },
  );
}
