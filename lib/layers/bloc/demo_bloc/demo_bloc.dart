import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rp_mobile/layers/bloc/demo_bloc/bloc.dart';
import 'package:rp_mobile/layers/services/session.dart';

class DemoBloc extends Bloc<DemoEvent, DemoState> {
  final SessionService _sessionService;

  DemoBloc(this._sessionService);

  @override
  DemoState get initialState => InitialExplorerState();

  @override
  Stream<DemoState> mapEventToState(DemoEvent event) async* {
    if (event is OnLoad) {
      yield LoadingSession();
      await _sessionService.refreshSession();
      final session = await _sessionService.loadSession();
      yield LoadedSessionState(session);
    } else {
      throw UnsupportedError('"$event" is not supported');
    }
  }
}
