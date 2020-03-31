import 'package:equatable/equatable.dart';

abstract class PlansEvent extends Equatable {
  const PlansEvent();
}

class OnLoad extends PlansEvent {
  @override
  List<Object> get props => [];
}

class OnNextPage extends PlansEvent {
  @override
  List<Object> get props => [];
}

class OnRefresh extends PlansEvent {
  @override
  List<Object> get props => [];
}

class OnUnhandledException extends PlansEvent {
  @override
  List<Object> get props => [];
}

class OnHideRecommendations extends PlansEvent {
  @override
  List<Object> get props => [];
}

class OnShowRecommendations extends PlansEvent {
  @override
  List<Object> get props => [];
}

class OnSelectItem extends PlansEvent {
  final String ref;

  OnSelectItem(this.ref);

  @override
  List<Object> get props => [ref];
}

class OnTriggerRoute extends PlansEvent {
  @override
  List<Object> get props => [];
}

class OnCreatePlanClick extends PlansEvent {
  @override
  List<Object> get props => [];
}

class OnCreatePlanSubmit extends PlansEvent {
  final String name;

  OnCreatePlanSubmit(this.name);

  @override
  List<Object> get props => [name];
}

class OnAddActivityToPlan extends PlansEvent {
  final String name;
  final String activityId;
  final String type;

  OnAddActivityToPlan(this.name, this.activityId, this.type);

  @override
  List<Object> get props => [name, activityId, type];
}
