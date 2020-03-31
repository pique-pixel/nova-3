import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rp_mobile/layers/drivers/api/session.dart';
import 'package:optional/optional.dart';

@immutable
abstract class ExplorerState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialExplorerState extends ExplorerState {}

class LoadingSession extends ExplorerState {}

class LoadedSessionState extends ExplorerState {
  Optional<Session> session;

  LoadedSessionState(this.session);

  List<Object> get props => [session];
}
