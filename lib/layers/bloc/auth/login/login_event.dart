import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class OnStart extends LoginEvent {
  @override
  List<Object> get props => [];
}

class OnLogin extends LoginEvent {
  final String email;
  final String password;

  OnLogin(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class OnUnhandledException extends LoginEvent {
  @override
  List<Object> get props => [];
}
