import 'package:equatable/equatable.dart';

abstract class SingleTicketContentDetailsEvent extends Equatable {
  const SingleTicketContentDetailsEvent();
}

class OnLoad extends SingleTicketContentDetailsEvent {
  final String ref;

  OnLoad(this.ref);

  @override
  List<Object> get props => [ref];
}

class OnUnhandledException extends SingleTicketContentDetailsEvent {
  @override
  List<Object> get props => [];
}
