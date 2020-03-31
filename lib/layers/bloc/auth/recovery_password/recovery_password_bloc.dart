import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class RecoveryPasswordBloc extends Bloc<RecoveryPasswordEvent, RecoveryPasswordState> {
  @override
  RecoveryPasswordState get initialState => InitialRecoveryPasswordState();

  @override
  Stream<RecoveryPasswordState> mapEventToState(
    RecoveryPasswordEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
