import 'package:equatable/equatable.dart';
import 'package:rp_mobile/layers/bloc/favorites/favorite_models.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();
}

class InitialFavoriteState extends FavoriteState {
  @override
  List<Object> get props => [];
}

class LoadingState extends FavoriteState {
  @override
  List<Object> get props => [];
}

class LoadedState extends FavoriteState {
  final FavoriteModel items;

  LoadedState(this.items);

  @override
  List<Object> get props => [items];
}

class RouteToDetailState extends LoadedState {
  final String id;

  RouteToDetailState(FavoriteModel items, this.id) : super(items);

  List<Object> get props => [id];
}

class BottomSheetShowState extends LoadedState {
  BottomSheetShowState(FavoriteModel items) : super(items);
  @override
  List<Object> get props => [];
}

class CreateNewFavoriteState extends FavoriteState {
  @override
  List<Object> get props => [];
}

class LoadedFavoriteForPlanState extends FavoriteState {
  final FavoriteForPlan details;

  LoadedFavoriteForPlanState(this.details);

  @override
  List<Object> get props => [details];

  @override
  String toString() {
    return '$LoadedFavoriteForPlanState($details)';
  }
}

class FavoriteCreatePlanState extends FavoriteState {
  @override
  List<Object> get props => [];
}

class LoadingListErrorState extends FavoriteState {
  @override
  List<Object> get props => [];
}

