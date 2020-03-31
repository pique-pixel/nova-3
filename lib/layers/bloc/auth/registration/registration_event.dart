import 'package:equatable/equatable.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();
}

class OnStart extends RegistrationEvent {
  @override
  List<Object> get props => [];
}

class OnRegistration extends RegistrationEvent {
  final String email;
  final String password;
  final String matchingPassword;

  OnRegistration(this.email, this.password,this.matchingPassword,);

  @override
  List<Object> get props => [email, password,matchingPassword];
}

class OnUnhandledException extends RegistrationEvent {
  @override
  List<Object> get props => [];
}
