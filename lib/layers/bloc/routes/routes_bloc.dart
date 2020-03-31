import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rp_mobile/layers/bloc/routes/bloc.dart';
import 'package:rp_mobile/layers/services/geo_objects.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

enum RouteType {
  masstransit,
  bicycle,
  pedestrian,
  driving,
}

class RoutesBloc extends Bloc<RoutesEvent, RoutesState> {
  final GeoObjectsService _geoObjectsService;
  RoutesState _checkpoint;

  RoutesBloc(this._geoObjectsService) {
    _geoObjectsService.setOnPlaceMarkTap((ref) {
      add(OnSelectGeoObject(ref));
    });
  }

  @override
  RoutesState get initialState => InitialRoutesState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    add(OnUnhandledException());
  }

  @override
  Stream<RoutesState> transformEvents(
    Stream<RoutesEvent> events,
    Stream<RoutesState> Function(RoutesEvent event) next,
  ) {
    // TODO(Andrey): Create helper for such an use case
    // NOTE(Andrey): Prevent events spamming
    final searchEvents = (events as Stream<RoutesEvent>)
        .where((event) => event is OnSearch)
        .debounceTime(Duration(milliseconds: 300))
        .switchMap(next);

    final otherEvents = (events as Stream<RoutesEvent>)
        .where((event) => event is! OnSearch)
        .asyncExpand(next);

    return Rx.merge([searchEvents, otherEvents]);
  }

  @override
  Stream<RoutesState> mapEventToState(RoutesEvent event) async* {
    if (event is OnUnhandledException) {
      if (_checkpoint == null || _checkpoint is InitialRoutesState) {
        yield LoadErrorState();
      } else {
        yield _checkpoint;
      }

      _checkpoint = null;
    } else if (event is OnYandexMapReady) {
      _checkpoint = state;
      yield* _onMapReady(event);
    } else if (event is OnLoad) {
      _checkpoint = state;
      yield* _loadGeoObjects();
    } else if (event is OnLoadPlace) {
      _checkpoint = state;
      yield* _loadGeoObjectPlace(event);
    } else if (event is OnSelectDay) {
      _checkpoint = state;
      yield* _selectDay(event);
    } else if (event is OnSearchFocus) {
      _checkpoint = state;
      yield* _searchFocus();
    } else if (event is OnSearch) {
      _checkpoint = state;
      yield* _search(event);
    } else if (event is OnCancel) {
      _checkpoint = state;
      yield* _cancel();
    } else if (event is OnSelectGeoObject) {
      _checkpoint = state;
      yield* _selectGeoObject(event);
    } else if (event is OnBuildRoute) {
      _checkpoint = state;
      yield* _buildRoute(RouteType.masstransit);
    } else if (event is OnBuildBicycleRoute) {
      _checkpoint = state;
      yield* _buildRoute(RouteType.bicycle);
    } else if (event is OnBuildPedestrianRoute) {
      _checkpoint = state;
      yield* _buildRoute(RouteType.pedestrian);
    } else if (event is OnBuildDrivingRoute) {
      _checkpoint = state;
      yield* _buildRoute(RouteType.driving);
    } else {
      _checkpoint = state;
      throw UnsupportedError('Event is not supported : $event');
    }
  }

  Stream<RoutesState> _loadGeoObjects() async* {
    yield LoadingState();

    final geoObjects = await _geoObjectsService.getMapGeoObjects();
    final days = await _geoObjectsService.getDays();

    assert(days.length > 0);

    yield LoadedMapState(
      geoObjects: geoObjects,
      days: days,
      selectedDayRef: days.first.ref,
    );
  }

  Stream<RoutesState> _selectDay(OnSelectDay event) async* {
    yield LoadingState();

    final geoObjects = await _geoObjectsService.getMapGeoObjects(event.ref);
    final days = await _geoObjectsService.getDays();

    assert(days.length > 0);

    yield LoadedMapState(
      geoObjects: geoObjects,
      days: days,
      selectedDayRef: event.ref,
    );
  }

  Stream<RoutesState> _loadGeoObjectPlace(OnLoadPlace event) async* {
    yield LoadingState();

    final geoObjects = await _geoObjectsService.getMapGeoObjects('impl:' + event.ref);
    final days = await _geoObjectsService.getDays();

    yield SelectGeoObjectLoadingState(
      selectedDayRef: '1',
      geoObjects: geoObjects,
      days: days,
    );

    final details = await _geoObjectsService.getGeoObjectsDetails('impl:' + event.ref);

    yield SelectedGeoObjectState(
      selectedDayRef: '1',
      geoObjects: geoObjects,
      days: days,
      details: details,
    );
  }

  Stream<RoutesState> _searchFocus() async* {
    assert(state is LoadedMapState);
    final currentState = state as LoadedMapState;

    yield SearchState(
      selectedDayRef: currentState.selectedDayRef,
      geoObjects: currentState.geoObjects,
      days: currentState.days,
      suggestions: await _geoObjectsService.searchGeoObjects(''),
    );
  }

  Stream<RoutesState> _search(OnSearch event) async* {
    assert(state is LoadedMapState);
    final currentState = state as LoadedMapState;

    yield SearchLoadingSuggestionsState(
      selectedDayRef: currentState.selectedDayRef,
      geoObjects: currentState.geoObjects,
      days: currentState.days,
    );

    try {
      final suggestions = await _geoObjectsService.searchGeoObjects(event.key);
      if (state is SearchState) {
        yield SearchState(
          selectedDayRef: currentState.selectedDayRef,
          geoObjects: currentState.geoObjects,
          days: currentState.days,
          suggestions: suggestions,
        );
      }
    } on Exception catch (_) {
      yield SearchLoadSuggestionsErrorState(
        selectedDayRef: currentState.selectedDayRef,
        geoObjects: currentState.geoObjects,
        days: currentState.days,
      );
    }
  }

  Stream<RoutesState> _cancel() async* {
    assert(state is LoadedMapState);
    final currentState = state as LoadedMapState;

    await _geoObjectsService.clearRoutes();
    await _geoObjectsService.moveCameraToBoundary(
      currentState.geoObjects,
      true,
    );

    yield LoadedMapState(
      selectedDayRef: currentState.selectedDayRef,
      geoObjects: currentState.geoObjects,
      days: currentState.days,
    );
  }

  Stream<RoutesState> _selectGeoObject(OnSelectGeoObject event) async* {
    assert(state is LoadedMapState);
    final currentState = state as LoadedMapState;

    yield SelectGeoObjectLoadingState(
      selectedDayRef: currentState.selectedDayRef,
      geoObjects: currentState.geoObjects,
      days: currentState.days,
    );

    final details = await _geoObjectsService.getGeoObjectsDetails(event.ref);

    yield SelectedGeoObjectState(
      selectedDayRef: currentState.selectedDayRef,
      geoObjects: currentState.geoObjects,
      days: currentState.days,
      details: details,
    );
  }

  Stream<RoutesState> _buildRoute(RouteType routeType) async* {
    assert(state is SelectedGeoObjectState);
    final currentState = state as SelectedGeoObjectState;

    yield BuildingRouteState(
      selectedDayRef: currentState.selectedDayRef,
      geoObjects: currentState.geoObjects,
      days: currentState.days,
      details: currentState.details,
    );

    final currentGeoLocation = await _geoObjectsService.getCurrentGeoLocation();
    RouteInfo info;

    switch (routeType) {
      case RouteType.masstransit:
        info = await _geoObjectsService.buildMasstransitRoute(
          currentGeoLocation,
          currentState.details.point,
        );

        assert(info.points.length >= 2);

        info.points[0] = RoutePoint(
          name: 'Моё местоположение',
          color: 0xFFF6474F,
          zIndex: 0,
        );

        info.points[info.points.length - 1] = RoutePoint(
          name: currentState.details.title,
          color: 0xFF262626,
          zIndex: 0,
        );

        break;

      case RouteType.bicycle:
        await _geoObjectsService.buildBicycleRoute(
          currentGeoLocation,
          currentState.details.point,
        );
        break;

      case RouteType.pedestrian:
        await _geoObjectsService.buildPedestrianRoute(
          currentGeoLocation,
          currentState.details.point,
        );
        break;

      case RouteType.driving:
        await _geoObjectsService.buildDrivingRoute(
          currentGeoLocation,
          currentState.details.point,
        );
        break;
    }

    final time = await _geoObjectsService.estimateRoutes(
      currentGeoLocation,
      currentState.details.point,
    );

    yield RouteToGeoObjectState(
      selectedDayRef: currentState.selectedDayRef,
      geoObjects: currentState.geoObjects,
      days: currentState.days,
      details: currentState.details,
      currentRouteType: routeType,
      time: time,
      info: info,
    );
  }

  Stream<RoutesState> _onMapReady(OnYandexMapReady event) async* {
    assert(state is LoadedMapState);
    final currentState = state as LoadedMapState;

    await _geoObjectsService.setYandexMapController(event.controller);
    await _geoObjectsService.moveCameraToBoundary(
      currentState.geoObjects,
      false,
    );
  }
}
