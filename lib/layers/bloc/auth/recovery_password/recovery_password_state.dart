import 'package:equatable/equatable.dart';

abstract class RecoveryPasswordState extends Equatable {
  const RecoveryPasswordState();
}

class InitialRecoveryPasswordState extends RecoveryPasswordState {
  @override
  List<Object> get props => [];
}
