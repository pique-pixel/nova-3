import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rp_mobile/layers/bloc/explorer/bloc.dart';
import 'package:rp_mobile/layers/services/session.dart';

class ExplorerBloc extends Bloc<ExplorerEvent, ExplorerState> {
  final SessionService _sessionService;

  ExplorerBloc(this._sessionService);

  @override
  ExplorerState get initialState => InitialExplorerState();

  @override
  Stream<ExplorerState> mapEventToState(ExplorerEvent event) async* {
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
