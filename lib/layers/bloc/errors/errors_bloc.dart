import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class ErrorsBloc extends Bloc<ErrorsEvent, ErrorsState> {
  @override
  ErrorsState get initialState => NoErrorsState();

  @override
  Stream<ErrorsState> mapEventToState(
    ErrorsEvent event,
  ) async* {
    if (event is OnError) {
      yield ErrorPresentedState(event.exception, event.stackTrace);
    } else if (event is OnCloseError) {
      yield NoErrorsState();
    } else {
      throw UnsupportedError('"$event" is not supported');
    }
  }
}
