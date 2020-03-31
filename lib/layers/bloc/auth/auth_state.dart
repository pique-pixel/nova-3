import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialAuthState extends AuthState {}

class RouteLoginState extends AuthState {}

class RouteRegistrationState extends AuthState {}

class RouteFAQState extends AuthState {}
