import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'package:rp_mobile/utils/future.dart';
import './bloc.dart';

class StartupBloc extends Bloc<StartupEvent, StartupState> {
  final SessionService _sessionService;

  StartupBloc(this._sessionService);

  @override
  StartupState get initialState => InitialStartupState();

  @override
  Stream<StartupState> mapEventToState(StartupEvent event) async* {
    if (event is OnStart) {
      yield* _restoreSession();
    } else if (event is OnCloseTips) {
      yield* _mapToOnCloseTips();
    }
  }

  Stream<StartupState> _restoreSession() async* {
    await delay(1000);
    yield LoadingSession();
    final session = await _sessionService.loadSession();

    if (session.isPresent) {
      if (!session.value.hasExpired()) {
        await delay(1000);
        yield RouteDashboardState();
      } else {
        yield* _openUnauthorized();
      }
    } else {
      yield* _openUnauthorized();
    }
  }

  Stream<StartupState> _openUnauthorized() async* {
    await delay(1000);
    if (await _sessionService.shouldDisplayTips()) {
      yield RouteTipsState();
    } else {
      yield RouteWelcomeState();
    }
  }

  Stream<StartupState> _mapToOnCloseTips() async* {
    await _sessionService.setTipsAsRead();
    yield RouteWelcomeState();
  }
}
