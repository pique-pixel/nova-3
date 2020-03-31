import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent {}

class OnLoginButtonClick extends AuthEvent {}

class OnRegistrationButtonClick extends AuthEvent {}

class OnFAQButtonClick extends AuthEvent {}
