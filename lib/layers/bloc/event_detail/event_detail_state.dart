import 'package:equatable/equatable.dart';
import 'package:rp_mobile/layers/bloc/event_detail/event_detail_models.dart';

abstract class EventDetailState extends Equatable {
  const EventDetailState();
}

class InitialEventDetailState extends EventDetailState {
  @override
  List<Object> get props => [];
}

class EventLoadingState extends EventDetailState {
  @override
  List<Object> get props => [];
}

class EventLoadingErrorState extends EventDetailState {
  @override
  List<Object> get props => [];
}

class EventLoadedState extends EventDetailState {
  final EventDetail details;

  EventLoadedState(this.details);

  @override
  List<Object> get props => [details];

  @override
  String toString() {
    return '$EventLoadedState($details)';
  }
}