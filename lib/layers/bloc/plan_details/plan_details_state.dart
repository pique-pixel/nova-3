import 'package:equatable/equatable.dart';
import 'package:rp_mobile/layers/bloc/plan_details/plan_details_bloc.dart';
import 'package:rp_mobile/layers/bloc/plan_details/plan_models.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

abstract class PlanDetailsState extends Equatable {
  const PlanDetailsState();
}

class InitialPlanDetailsState extends PlanDetailsState {
  @override
  List<Object> get props => [];
}

class InitialLoadingDetailsState extends PlanDetailsState {
  @override
  List<Object> get props => [];
}

class InitialLoadingErrorState extends PlanDetailsState {
  @override
  List<Object> get props => [];
}

class LoadedState extends PlanDetailsState {
  final PlanDetails details;

  LoadedState(this.details);

  @override
  List<Object> get props => [details];
}

class LoadingDetailsState extends LoadedState {
  LoadingDetailsState(PlanDetails details) : super(details);
}

class RouteAddToTripState extends PlanDetailsState {
  final String detailsRef;

  RouteAddToTripState(this.detailsRef);

  @override
  List<Object> get props => [detailsRef];
}

class RouteSpotDetails extends PlanDetailsState {
  final String ref;

  RouteSpotDetails(this.ref);

  @override
  List<Object> get props => [ref];
}

class SpotSelectedState extends LoadedState {
  final String ref;

  SpotSelectedState(PlanDetails details, this.ref) : super(details);

  @override
  List<Object> get props => [ref, details];
}

class DetailedSliderState extends LoadedState {
  final Spot data;
  final Point destPoint;

  DetailedSliderState(PlanDetails details, this.data, this.destPoint)
      : super(details);

  @override
  List<Object> get props => [data, details, destPoint];
}

class BuildingRouteState extends PlanDetailsState {
  @override
  List<Object> get props => null;
}

class RouteSelectSliderState extends LoadedState {
  final RouteTypes routeType;
  final RouteInfo routeInfo;
  final Map<RouteTypes, String> time;
  final Spot data;
  final Point destPoint;

  RouteSelectSliderState({
    PlanDetails details,
    this.routeType,
    this.routeInfo,
    this.time,
    this.data,
    this.destPoint,
  }) : super(details);

  @override
  List<Object> get props =>
      [
        data,
        details,
        destPoint,
        routeType,
        routeInfo,
        time,
      ];
}

class RouteToUpdatePlanNameState extends LoadedState {
  RouteToUpdatePlanNameState(PlanDetails details) : super(details);
}

class RouteToPlanListState extends PlanDetailsState {
  final bool isDeleted;

  RouteToPlanListState(this.isDeleted) : super();

  @override
  List<Object> get props => null;
}

class UpdatePlanNameState extends LoadedState {
  UpdatePlanNameState(PlanDetails details) : super(details);
}

class UpdatingPlanNameState extends LoadedState {
  UpdatingPlanNameState(PlanDetails details) : super(details);
}

class UpdatedPlanNameState extends LoadedState {
  UpdatedPlanNameState(PlanDetails details) : super(details);
}
