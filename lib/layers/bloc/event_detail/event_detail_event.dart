import 'package:equatable/equatable.dart';

abstract class EventDetailEvent extends Equatable {
  const EventDetailEvent();
}

class EventOnLoad extends EventDetailEvent {
  final String ref;

  EventOnLoad(this.ref);

  @override
  List<Object> get props => [ref];
}

class OnUnhandledException extends EventDetailEvent {
  @override
  List<Object> get props => [];
}