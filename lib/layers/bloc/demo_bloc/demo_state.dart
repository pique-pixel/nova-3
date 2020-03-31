import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rp_mobile/layers/drivers/api/session.dart';
import 'package:optional/optional.dart';

@immutable
abstract class DemoState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialExplorerState extends DemoState {}

class LoadingSession extends DemoState {}

class LoadedSessionState extends DemoState {
  Optional<Session> session;

  LoadedSessionState(this.session);

  List<Object> get props => [session];
}
