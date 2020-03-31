import 'package:bloc/bloc.dart';
import 'package:rp_mobile/layers/bloc/favorites/favorite_event.dart';
import 'package:rp_mobile/layers/bloc/favorites/favorite_models.dart';
import 'package:rp_mobile/layers/bloc/favorites/favorite_state.dart';
import 'package:rp_mobile/layers/services/favorite_services.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteService _favoriteService;
  FavoriteModel _loadedItems;

  FavoriteState _checkpoint;

  FavoriteBloc(this._favoriteService);

  @override
  FavoriteState get initialState => InitialFavoriteState();

  @override
  void onError(Object error, StackTrace stackTrace) {
    add(OnUnhandledException());
  }

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is OnUnhandledException) {
      if (_checkpoint == null || _checkpoint is InitialFavoriteState) {
        yield LoadingListErrorState();
      } else {
        yield _checkpoint;
      }

      _checkpoint = null;
    } else if (event is OnLoad) {
      _checkpoint = state;
      yield* _loadFavorite();
    } else if (event is OnFavoriteDetails) {
      _checkpoint = state;
      yield* _routeDetails(event);
    } else if (event is OnRouteTrigger) {
      yield* _routeTrigger();
    } else if (event is OnBottomSheetClose) {
      yield* _bottomSheetClose();
    } else if (event is OnBottomSheetShow) {
      _checkpoint = state;
      yield* _bottomSheetShow();
    } else if (event is OnCreateNewList) {
      _checkpoint = state;
      yield* _createNewList(event);
    } else if (event is OnLoadFavoriteForPlan) {
      _checkpoint = state;
      yield* _favoriteForPlanDetails(event);
    } else if (event is OnCreateNewPlan) {
      _checkpoint = state;
      yield* _onPlanCreate(event);
    } else {
      _checkpoint = state;
      throw UnsupportedError('Unsupported event: $event');
    }
  }

  Stream<FavoriteState> _loadFavorite() async* {
    yield LoadingState();
    final _data = await _favoriteService.getFavoriteList();

    _loadedItems = _data;
    yield LoadedState(_loadedItems);
  }

  Stream<FavoriteState> _routeDetails(OnFavoriteDetails event) async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;
    yield RouteToDetailState(currentState.items, event.id);
  }

  Stream<FavoriteState> _routeTrigger() async* {
    assert(state is RouteToDetailState);
    final currentState = state as RouteToDetailState;
    yield LoadedState(currentState.items);
  }

  Stream<FavoriteState> _bottomSheetClose() async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;
    yield LoadedState(currentState.items);
  }

  Stream<FavoriteState> _bottomSheetShow() async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;
    yield BottomSheetShowState(currentState.items);
  }

  Stream<FavoriteState> _createNewList(OnCreateNewList event) async* {
    assert(state is BottomSheetShowState);
    yield LoadingState();

    final _data = await _favoriteService.createNewFavoriteList(event.listName);

    yield LoadedState(_data);
  }

  Stream<FavoriteState> _favoriteForPlanDetails(
      OnLoadFavoriteForPlan event) async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;
    try {
      final _data = await _favoriteService.getFavoriteForPlanById(event.ref);
      yield LoadedFavoriteForPlanState(_data);
      yield LoadedState(currentState.items);
    } catch (e) {
      yield LoadedState(currentState.items);
      throw e;
    }
  }

  Stream<FavoriteState> _onPlanCreate(OnCreateNewPlan event) async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;
    try {
      final _data = await _favoriteService.createPlanFromFavorite(
          event.name, event.activities);
      yield FavoriteCreatePlanState();
      yield LoadedState(currentState.items);
    } catch (e) {
      yield LoadedState(currentState.items);
      throw e;
    }
  }
}
