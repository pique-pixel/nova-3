import 'package:meta/meta.dart';

@immutable
abstract class ErrorsState {}

class ErrorPresentedState extends ErrorsState {
  final Object exception;
  final StackTrace stackTrace;

  ErrorPresentedState(this.exception, this.stackTrace);
}

class NoErrorsState extends ErrorsState {}
