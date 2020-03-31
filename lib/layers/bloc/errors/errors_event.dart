import 'package:meta/meta.dart';

@immutable
abstract class ErrorsEvent {}

class OnError extends ErrorsEvent {
  final Object exception;
  final StackTrace stackTrace;

  OnError(this.exception, this.stackTrace);
}

class OnCloseError extends ErrorsEvent {
}
