import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

@immutable
abstract class RoutesEvent extends Equatable {}

class OnLoad extends RoutesEvent {
  @override
  List<Object> get props => [];
}

class OnLoadPlace extends RoutesEvent {
  final String ref;

  OnLoadPlace(this.ref);

  @override
  List<Object> get props => [ref];
}

class OnSelectDay extends RoutesEvent {
  final String ref;

  OnSelectDay(this.ref);

  @override
  List<Object> get props => [ref];
}

class OnSelectGeoObject extends RoutesEvent {
  final String ref;

  OnSelectGeoObject(this.ref);

  @override
  List<Object> get props => [ref];
}

class OnSearchFocus extends RoutesEvent {
  OnSearchFocus();

  @override
  List<Object> get props => [];
}

class OnSearch extends RoutesEvent {
  final String key;

  OnSearch([this.key = '']);

  @override
  List<Object> get props => [key];
}

class OnCancel extends RoutesEvent {
  @override
  List<Object> get props => [];
}

class OnBuildRoute extends RoutesEvent {
  OnBuildRoute();

  @override
  List<Object> get props => [];
}

class OnBuildBicycleRoute extends RoutesEvent {
  OnBuildBicycleRoute();

  @override
  List<Object> get props => [];
}

class OnBuildPedestrianRoute extends RoutesEvent {
  OnBuildPedestrianRoute();

  @override
  List<Object> get props => [];
}

class OnBuildDrivingRoute extends RoutesEvent {
  OnBuildDrivingRoute();

  @override
  List<Object> get props => [];
}

class OnUnhandledException extends RoutesEvent {
  OnUnhandledException();

  @override
  List<Object> get props => [];
}

class OnYandexMapReady extends RoutesEvent {
  final YandexMapController controller;

  OnYandexMapReady(this.controller);

  @override
  List<Object> get props => [controller];
}
