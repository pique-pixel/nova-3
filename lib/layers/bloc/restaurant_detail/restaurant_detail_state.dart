import 'package:equatable/equatable.dart';
import 'package:rp_mobile/layers/bloc/restaurant_detail/restaurant_detail_models.dart';

abstract class RestaurantDetailState extends Equatable {
  const RestaurantDetailState();
}

class InitialRestaurantDetailState extends RestaurantDetailState {
  @override
  List<Object> get props => [];
}

class RestaurantLoadingState extends RestaurantDetailState {
  @override
  List<Object> get props => [];
}

class RestaurantLoadingErrorState extends RestaurantDetailState {
  @override
  List<Object> get props => [];
}

class RestaurantLoadedState extends RestaurantDetailState {
  final RestaurantDetail details;

  RestaurantLoadedState(this.details);

  @override
  List<Object> get props => [details];

  @override
  String toString() {
    return '$RestaurantLoadedState($details)';
  }
}