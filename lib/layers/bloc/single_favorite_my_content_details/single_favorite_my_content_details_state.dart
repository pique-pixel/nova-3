import 'package:equatable/equatable.dart';
import 'package:rp_mobile/layers/bloc/single_favorite_my_content_details/single_favorite_my_content_details_models.dart';

abstract class SingleFavoriteMyContentDetailsState extends Equatable {
  const SingleFavoriteMyContentDetailsState();
}

class InitialSingleFavoriteMyContentDetailsState extends SingleFavoriteMyContentDetailsState {
  @override
  List<Object> get props => [];
}

class LoadingState extends SingleFavoriteMyContentDetailsState {
  @override
  List<Object> get props => [];
}

class LoadingErrorState extends SingleFavoriteMyContentDetailsState {
  @override
  List<Object> get props => [];
}

class LoadedState extends SingleFavoriteMyContentDetailsState {
  final FavoriteMyDetailModel details;

  LoadedState(this.details);

  @override
  List<Object> get props => [details];
}

class ListDeletedState extends SingleFavoriteMyContentDetailsState {
  @override
  List<Object> get props => [];
}
