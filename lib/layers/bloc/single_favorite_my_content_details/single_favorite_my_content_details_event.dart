import 'package:equatable/equatable.dart';

abstract class SingleFavoriteMyContentDetailsEvent extends Equatable {
  const SingleFavoriteMyContentDetailsEvent();
}

class OnLoad extends SingleFavoriteMyContentDetailsEvent {
  final String id;

  OnLoad(this.id);

  @override
  List<Object> get props => [id];
}

class OnDeleteList extends SingleFavoriteMyContentDetailsEvent{
  final String id;

  OnDeleteList(this.id);

  @override
  List<Object> get props => [id];
}

class OnUnhandledException extends SingleFavoriteMyContentDetailsEvent {
  @override
  List<Object> get props => [];
}
