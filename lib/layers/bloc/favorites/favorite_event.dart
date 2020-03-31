import 'package:equatable/equatable.dart';
import 'package:rp_mobile/layers/bloc/favorites/bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
}

class OnLoad extends FavoriteEvent {
  @override
  List<Object> get props => [];
}

class OnFavoriteDetails extends FavoriteEvent {
  final String id;

  OnFavoriteDetails(this.id);

  @override
  List<Object> get props => [id];
}

class OnRouteTrigger extends FavoriteEvent {
  @override
  List<Object> get props => [];
}

class OnBottomSheetClose extends FavoriteEvent {
  @override
  List<Object> get props => [];
}

class OnBottomSheetShow extends FavoriteEvent {
  @override
  List<Object> get props => [];
}

class OnCreateNewList extends FavoriteEvent {
  final String listName;

  OnCreateNewList(this.listName);

  @override
  List<Object> get props => [listName];
}


class OnLoadFavoriteForPlan extends FavoriteEvent {
  final String ref;

  OnLoadFavoriteForPlan(this.ref);

  @override
  List<Object> get props => [ref];
}
class OnCreateNewPlan extends FavoriteEvent {
  final String name;
  final List activities;

  OnCreateNewPlan(this.name, this.activities);

  @override
  List<Object> get props => [name, activities];
}

class OnDeleteList extends FavoriteEvent{
  final String id;

  OnDeleteList(this.id);

  @override
  List<Object> get props => [id];
}


class OnUnhandledException extends FavoriteEvent {
  @override
  List<Object> get props => [];
}
