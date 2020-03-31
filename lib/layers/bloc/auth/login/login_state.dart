import 'package:equatable/equatable.dart';
import 'package:rp_mobile/locale/localized_string.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class InitialLoginState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoadingFormState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginFormState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoadingState extends LoginState {
  @override
  List<Object> get props => [];
}

class ErrorState extends LoginFormState {
  final LocalizedString error;

  ErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class LockedState extends LoginState {
  final String until;

  LockedState(this.until);

  @override
  List<Object> get props => [until];
}

class SuccessState extends LoginState {
  @override
  List<Object> get props => [];
}

class RouteRecoveryPasswordState extends LoginState {
  @override
  List<Object> get props => [];
}

class RouteCloseLogin extends LoginState {
  @override
  List<Object> get props => [];
}
