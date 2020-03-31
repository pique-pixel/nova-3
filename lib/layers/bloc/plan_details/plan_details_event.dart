import 'package:equatable/equatable.dart';
import 'package:rp_mobile/layers/bloc/plan_details/plan_details_bloc.dart';
import 'package:rp_mobile/layers/bloc/plan_details/plan_models.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

abstract class PlanDetailsEvent extends Equatable {
  const PlanDetailsEvent();
}

class OnLoadDetails extends PlanDetailsEvent {
  final String ref;

  OnLoadDetails(this.ref);

  @override
  List<Object> get props => [ref];
}

class OnSelectDate extends PlanDetailsEvent {
  final String ref;

  OnSelectDate(this.ref);

  @override
  List<Object> get props => [ref];
}

class OnSelectAllDates extends PlanDetailsEvent {
  @override
  List<Object> get props => [];
}

class OnSelectSpot extends PlanDetailsEvent {
  final String ref;

  OnSelectSpot(this.ref);

  @override
  List<Object> get props => [ref];
}

class OnSelectPlace extends PlanDetailsEvent {
  final String spotRef;

  OnSelectPlace(this.spotRef);

  @override
  List<Object> get props => [spotRef];
}

class OnBuildRoute extends PlanDetailsEvent {
  final RouteTypes routeType;

  OnBuildRoute({this.routeType = RouteTypes.masstransit});

  @override
  List<Object> get props => [routeType];
}

class OnAddToTrip extends PlanDetailsEvent {
  OnAddToTrip();

  @override
  List<Object> get props => [];
}

class OnUnhandledException extends PlanDetailsEvent {
  @override
  List<Object> get props => [];
}

class OnYandexMapReady extends PlanDetailsEvent {
  final YandexMapController controller;
  final void Function(String spotRef) onMarkTap;

  OnYandexMapReady(this.controller,
      this.onMarkTap,);

  @override
  List<Object> get props => [controller];
}

class OnClickUpdatePlanName extends PlanDetailsEvent {
  @override
  List<Object> get props => [];
}

class OnUpdatePlanNameSubmit extends PlanDetailsEvent {
  final String name;

  OnUpdatePlanNameSubmit(this.name);

  @override
  List<Object> get props => [name];
}

class OnDeletePlan extends PlanDetailsEvent {
  @override
  List<Object> get props => [];
}

class OnDeleteActivity extends PlanDetailsEvent {
  final String activityId;

  OnDeleteActivity(this.activityId);

  @override
  List<Object> get props => [activityId];
}

class OnAssignActivityDate extends PlanDetailsEvent {
  final Spot spot;
  final DateTime dateTime;

  OnAssignActivityDate(this.spot, this.dateTime);

  @override
  List<Object> get props => [spot, dateTime];
}

class OnTriggerRoute extends PlanDetailsEvent {
  @override
  List<Object> get props => [];
}

class OnCloseDetailedSlider extends PlanDetailsEvent {
  @override
  List<Object> get props => [];
}

class OnCloseRouteSlider extends PlanDetailsEvent {
  @override
  List<Object> get props => [];
}

class OnShowMyLocation extends PlanDetailsEvent {
  @override
  List<Object> get props => [];
}
