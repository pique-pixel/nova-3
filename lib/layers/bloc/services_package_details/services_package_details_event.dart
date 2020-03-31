import 'package:equatable/equatable.dart';

abstract class ServicesPackageDetailsEvent extends Equatable {
  const ServicesPackageDetailsEvent();
}

class OnLoad extends ServicesPackageDetailsEvent {
  @override
  List<Object> get props => [];
}

class OnChangeCity extends ServicesPackageDetailsEvent {
  final String cityRef;

  OnChangeCity(this.cityRef);

  @override
  List<Object> get props => [];
}

class OnExpandActivities extends ServicesPackageDetailsEvent {
  OnExpandActivities();

  @override
  List<Object> get props => [];
}

class OnFilterActivities extends ServicesPackageDetailsEvent {
  final List<String> filters;

  OnFilterActivities(this.filters);

  @override
  List<Object> get props => filters;
}

class OnUnhandledException extends ServicesPackageDetailsEvent {
  @override
  List<Object> get props => [];
}
