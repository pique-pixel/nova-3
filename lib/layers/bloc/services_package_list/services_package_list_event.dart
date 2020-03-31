import 'package:equatable/equatable.dart';

abstract class ServicesPackageListEvent extends Equatable {
  const ServicesPackageListEvent();
}

class OnLoad extends ServicesPackageListEvent {
  @override
  List<Object> get props => [];
}

class OnNextPage extends ServicesPackageListEvent {
  @override
  List<Object> get props => [];
}

class OnRefresh extends ServicesPackageListEvent {
  @override
  List<Object> get props => [];
}

class OnUnhandledException extends ServicesPackageListEvent {
  @override
  List<Object> get props => [];
}
