import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rp_mobile/layers/services/favorite_services.dart';
import './bloc.dart';

class SingleFavoriteMyContentDetailsBloc extends Bloc<
    SingleFavoriteMyContentDetailsEvent, SingleFavoriteMyContentDetailsState> {

  final FavoriteService _favoriteService;
  SingleFavoriteMyContentDetailsState _checkpoint;

  SingleFavoriteMyContentDetailsBloc(this._favoriteService);

  @override
  SingleFavoriteMyContentDetailsState get initialState =>
      InitialSingleFavoriteMyContentDetailsState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    add(OnUnhandledException());
  }

  @override
  Stream<SingleFavoriteMyContentDetailsState> mapEventToState(
    SingleFavoriteMyContentDetailsEvent event,
  ) async* {
    if (event is OnUnhandledException) {
      if (_checkpoint == null || _checkpoint is InitialSingleFavoriteMyContentDetailsState) {
        yield LoadingErrorState();
      } else {
        yield _checkpoint;
      }

      _checkpoint = null;
    } else if (event is OnLoad) {
      _checkpoint = state;
      yield* _loadDetails(event);
    }else if (event is OnDeleteList){
      _checkpoint = state;
      yield* _deleteList(event);
    }
    else {
      _checkpoint = state;
      throw UnsupportedError('Unsupported event: $event');
    }
  }

  Stream<SingleFavoriteMyContentDetailsState> _loadDetails(OnLoad event) async* {
    yield LoadingState();
    final _detail = await _favoriteService.getFavoritDetailById(event.id);
    yield LoadedState(_detail);
  }

  Stream<SingleFavoriteMyContentDetailsState> _deleteList(OnDeleteList event) async*{
    assert(state is LoadedState);
    await _favoriteService.deleteFavoriteList(event.id);
    yield ListDeletedState();
  }
}
