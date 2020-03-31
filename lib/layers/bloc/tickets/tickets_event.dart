import 'package:equatable/equatable.dart';

abstract class TicketsEvent extends Equatable {
  const TicketsEvent();
}

class OnLoad extends TicketsEvent {
  @override
  List<Object> get props => [];
}

class OnNextPage extends TicketsEvent {
  @override
  List<Object> get props => [];
}

class OnRefresh extends TicketsEvent {
  @override
  List<Object> get props => [];
}

class OnShowBottomSheet extends TicketsEvent {
  final String ref;

  OnShowBottomSheet(this.ref);

  @override
  List<Object> get props => [ref];
}

class OnRouteDetails extends TicketsEvent {
  final String ref;

  OnRouteDetails(this.ref);

  @override
  List<Object> get props => [ref];
}

class OnUnhandledException extends TicketsEvent {
  @override
  List<Object> get props => [];
}

class OnCloseBottomSheet extends TicketsEvent {
  @override
  List<Object> get props => [];
}

class OnTriggerRoute extends TicketsEvent {
  @override
  List<Object> get props => [];
}
