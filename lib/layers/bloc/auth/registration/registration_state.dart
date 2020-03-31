import 'package:equatable/equatable.dart';
import 'package:rp_mobile/locale/localized_string.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();
}

class InitialRegistrationState extends RegistrationState {
  @override
  List<Object> get props => [];
}

class LoadingFormState extends RegistrationState {
  @override
  List<Object> get props => [];
}

class RegistrationFormState extends RegistrationState {
  @override
  List<Object> get props => [];
}

class LoadingState extends RegistrationState {
  @override
  List<Object> get props => [];
}

class ErrorState extends RegistrationFormState {
  final LocalizedString error;

  ErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class LockedState extends RegistrationState {
  final String until;

  LockedState(this.until);

  @override
  List<Object> get props => [until];
}

class SuccessState extends RegistrationState {
  @override
  List<Object> get props => [];
}

class RouteRecoveryPasswordState extends RegistrationState {
  @override
  List<Object> get props => [];
}

class RouteCloseRegistration extends RegistrationState {
  @override
  List<Object> get props => [];
}
