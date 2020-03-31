import 'package:equatable/equatable.dart';

abstract class RestaurantDetailEvent extends Equatable {
  const RestaurantDetailEvent();
}

class RestaurantOnLoad extends RestaurantDetailEvent {
  final String ref;

  RestaurantOnLoad(this.ref);

  @override
  List<Object> get props => [ref];
}

class OnUnhandledException extends RestaurantDetailEvent {
  @override
  List<Object> get props => [];
}