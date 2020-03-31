import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class StartupState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialStartupState extends StartupState {}

class LoadingSession extends StartupState {}

class RouteTipsState extends StartupState {}

class RouteDashboardState extends StartupState {}

class RouteWelcomeState extends StartupState {}
