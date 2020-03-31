import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rp_mobile/layers/bloc/routes/bloc.dart';
import 'package:rp_mobile/layers/bloc/routes/routes_models.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

@immutable
abstract class RoutesState extends Equatable {}

class InitialRoutesState extends RoutesState {
  @override
  List<Object> get props => [];
}

class LoadingState extends RoutesState {
  @override
  List<Object> get props => [];
}

class LoadErrorState extends RoutesState {
  @override
  List<Object> get props => [];
}

class LoadedMapState extends RoutesState {
  final List<GeoObject> geoObjects;
  final List<Day> days;
  final String selectedDayRef;

  LoadedMapState({
    @required this.geoObjects,
    @required this.days,
    @required this.selectedDayRef,
  })  : assert(geoObjects != null),
        assert(days != null);

  @override
  List<Object> get props => [geoObjects, days, selectedDayRef];
}

class SearchState extends LoadedMapState {
  final List<SearchSuggestion> suggestions;

  SearchState({
    @required selectedDayRef,
    @required geoObjects,
    @required days,
    this.suggestions = const [],
  })  : assert(suggestions != null),
        super(
          geoObjects: geoObjects,
          days: days,
          selectedDayRef: selectedDayRef,
        );

  @override
  List<Object> get props => [geoObjects, days, suggestions, selectedDayRef];
}

class SearchLoadingSuggestionsState extends SearchState {
  SearchLoadingSuggestionsState({
    @required geoObjects,
    @required days,
    @required selectedDayRef,
  }) : super(
          geoObjects: geoObjects,
          days: days,
          selectedDayRef: selectedDayRef,
        );

  @override
  List<Object> get props => [geoObjects, days, selectedDayRef];
}

class SearchLoadSuggestionsErrorState extends SearchState {
  SearchLoadSuggestionsErrorState({
    @required geoObjects,
    @required days,
    @required selectedDayRef,
  }) : super(
          geoObjects: geoObjects,
          days: days,
          selectedDayRef: selectedDayRef,
        );

  @override
  List<Object> get props => [geoObjects, days, selectedDayRef];
}

class SelectGeoObjectLoadingState extends LoadedMapState {
  SelectGeoObjectLoadingState({
    @required geoObjects,
    @required days,
    @required selectedDayRef,
  }) : super(
          geoObjects: geoObjects,
          days: days,
          selectedDayRef: selectedDayRef,
        );

  @override
  List<Object> get props => [geoObjects, days, selectedDayRef];
}

class SelectedGeoObjectState extends LoadedMapState {
  final GeoObjectDetails details;

  SelectedGeoObjectState({
    @required geoObjects,
    @required days,
    @required selectedDayRef,
    @required this.details,
  })  : assert(details != null),
        super(
          geoObjects: geoObjects,
          days: days,
          selectedDayRef: selectedDayRef,
        );

  @override
  List<Object> get props => [geoObjects, days, details, selectedDayRef];
}

class RouteToGeoObjectState extends SelectedGeoObjectState {
  final RouteType currentRouteType;
  final RouteInfo info;
  final Map<RouteType, String> time;

  RouteToGeoObjectState({
    @required geoObjects,
    @required days,
    @required details,
    @required selectedDayRef,
    @required this.currentRouteType,
    @required this.time,
    this.info,
  }) : super(
          geoObjects: geoObjects,
          days: days,
          details: details,
          selectedDayRef: selectedDayRef,
        );

  @override
  List<Object> get props => [
        geoObjects,
        days,
        details,
        selectedDayRef,
        currentRouteType,
        time,
      ];
}

class BuildingRouteState extends SelectedGeoObjectState {
  BuildingRouteState({
    @required geoObjects,
    @required days,
    @required details,
    @required selectedDayRef,
  }) : super(
          geoObjects: geoObjects,
          days: days,
          details: details,
          selectedDayRef: selectedDayRef,
        );
}
