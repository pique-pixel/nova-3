import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rp_mobile/layers/services/restaurant_detail_service.dart';
import './bloc.dart';

class RestaurantDetailBloc extends Bloc<
    RestaurantDetailEvent, RestaurantDetailState> {

  final RestaurantDetailService _restaurantDetailService;
  RestaurantDetailState _checkpoint;

  RestaurantDetailBloc(this._restaurantDetailService);

  @override
  RestaurantDetailState get initialState =>
      InitialRestaurantDetailState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    add(OnUnhandledException());
  }

  @override
  Stream<RestaurantDetailState> mapEventToState(
      RestaurantDetailEvent event,
      ) async* {
    if (event is OnUnhandledException) {
      if (_checkpoint == null || _checkpoint is InitialRestaurantDetailState) {
        yield RestaurantLoadingErrorState();
      } else {
        yield _checkpoint;
      }

      _checkpoint = null;
    } else if (event is RestaurantOnLoad) {
      _checkpoint = state;
      yield* _loadDetail(event);
    }
  }

  Stream<RestaurantDetailState> _loadDetail(RestaurantOnLoad event) async* {
    yield RestaurantLoadingState();
    final detail = await _restaurantDetailService.getRestaurantDetails(event.ref);
    yield RestaurantLoadedState(detail);
  }
}