import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:optional/optional.dart';
import 'package:rp_mobile/layers/bloc/plan_details/plan_models.dart';
import 'package:rp_mobile/layers/drivers/geo.dart';
import 'package:rp_mobile/layers/services/plans_service.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'bloc.dart';

enum RouteTypes {
  masstransit,
  bicycle,
  pedestrian,
  driving,
}

class PlanDetailsBloc extends Bloc<PlanDetailsEvent, PlanDetailsState> {
  final PlansService _plansService;
  String detailsRef;

  PlanDetailsState _checkpoint;

  PlanDetailsBloc(this._plansService);

  @override
  PlanDetailsState get initialState => InitialPlanDetailsState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    add(OnUnhandledException());
  }

  @override
  Stream<PlanDetailsState> mapEventToState(
    PlanDetailsEvent event,
  ) async* {
    if (event is OnUnhandledException) {
      if (_checkpoint == null || _checkpoint is InitialPlanDetailsState) {
        yield InitialLoadingErrorState();
      } else {
        yield _checkpoint;
      }

      _checkpoint = null;
    } else if (event is OnLoadDetails) {
      _checkpoint = state;
      yield* _loadDetails(event);
    } else if (event is OnSelectDate) {
      _checkpoint = state;
      yield* _selectDate(event);
    } else if (event is OnCloseDetailedSlider) {
      _checkpoint = state;
      yield* _closeDetailedSlider(event);
    } else if (event is OnCloseRouteSlider) {
      _checkpoint = state;
      yield* _closeRouteSlider(event);
    } else if (event is OnShowMyLocation) {
      _checkpoint = state;
      yield* _showMyLocation(event);
    } else if (event is OnSelectAllDates) {
      _checkpoint = state;
      yield* _selectAllDates(event);
    } else if (event is OnSelectSpot) {
      _checkpoint = state;
      yield* _selectSpot(event);
    } else if (event is OnSelectPlace) {
      _checkpoint = state;
      yield* _selectPlace(event);
    } else if (event is OnAddToTrip) {
      _checkpoint = state;
      yield* _onAddToTrip(event);
    } else if (event is OnYandexMapReady) {
      _checkpoint = state;
      yield* _setupMap(event);
    } else if (event is OnBuildRoute) {
      _checkpoint = state;
      yield* _buildRoute(event);
    } else if (event is OnClickUpdatePlanName) {
      _checkpoint = state;
      yield* _onRouteToUpdatePlanName(event);
    } else if (event is OnTriggerRoute) {
      yield* _routeTrigger();
    } else if (event is OnUpdatePlanNameSubmit) {
      _checkpoint = state;
      yield* _updatePlanNameSubmit(event);
    } else if (event is OnDeletePlan) {
      _checkpoint = state;
      yield* _deletePlan(event);
    } else if (event is OnDeleteActivity) {
      _checkpoint = state;
      yield* _deleteActivity(event);
    } else if (event is OnAssignActivityDate) {
      _checkpoint = state;
      yield* _assignActivityDate(event);
    } else {
      _checkpoint = state;
      throw UnsupportedError('Unsupported event: $event');
    }
  }

  Stream<PlanDetailsState> _loadDetails(OnLoadDetails event) async* {
    print('REF IS: ${event.ref}');
    yield InitialLoadingDetailsState();

    final details = await _plansService.getPlanDetails(
      event.ref,
      Optional.empty(),
    );
    await _plansService.showAllPoints();

    this.detailsRef = event.ref;
    yield LoadedState(details);
  }

  Stream<PlanDetailsState> _selectDate(OnSelectDate event) async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;

    final lastDetails = currentState.details;

    final nextDetails = lastDetails.copyWith(
      header: lastDetails.header.copyWith(
        selectedDateRef: Optional.of(event.ref),
      ),
    );

    yield LoadingDetailsState(nextDetails);

    try {
      final details = await _plansService.getPlanDetails(
        detailsRef,
        Optional.of(event.ref),
      );
      await _plansService.showAllPoints();

      yield LoadedState(details);
    } catch (e) {
      yield LoadedState(lastDetails);
      throw e;
    }
  }

  Stream<PlanDetailsState> _selectAllDates(OnSelectAllDates event) async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;

    final lastDetails = currentState.details;

    final nextDetails = lastDetails.copyWith(
      header: lastDetails.header.copyWith(
        selectedDateRef: Optional.empty(),
      ),
    );

    yield LoadingDetailsState(nextDetails);

    try {
      final details = await _plansService.getPlanDetails(
        detailsRef,
        Optional.empty(),
      );
      await _plansService.showAllPoints();

      yield LoadedState(details);
    } catch (e) {
      yield LoadedState(lastDetails);
      throw e;
    }
  }

  Stream<PlanDetailsState> _selectSpot(OnSelectSpot event) async* {
    yield RouteSpotDetails(event.ref);
  }

  Stream<PlanDetailsState> _buildRoute(OnBuildRoute event) async* {
    assert(state is DetailedSliderState || state is RouteSelectSliderState);
    Spot data;
    Point destPoint;
    PlanDetails details;
    if (state is DetailedSliderState) {
      data = (state as DetailedSliderState).data;
      destPoint = (state as DetailedSliderState).destPoint;
      details = (state as DetailedSliderState).details;
    } else if (state is RouteSelectSliderState) {
      data = (state as RouteSelectSliderState).data;
      destPoint = (state as RouteSelectSliderState).destPoint;
      details = (state as RouteSelectSliderState).details;
    }
    yield BuildingRouteState();
    RouteTypes routeType = event.routeType;

    final currentGeoLocation = await getCurrentGeoLocation();
    RouteInfo info;

    final Map<RouteTypes, String> time = await _plansService.estimateRoutes(
      srcPoint: currentGeoLocation,
      destPoint: destPoint,
    );

    switch (routeType) {
      case RouteTypes.masstransit:
        info = await _plansService.buildMasstransitRoute(
          currentGeoLocation,
          destPoint,
        );

        assert(info.points.length >= 2);

        info.points[0] = RoutePoint(
          name: 'Моё местоположение',
          color: 0xFFF6474F,
          zIndex: 0,
        );

        info.points[info.points.length - 1] = RoutePoint(
          name: data.title.key,
          color: 0xFF262626,
          zIndex: 0,
        );

        break;

      case RouteTypes.bicycle:
        await _plansService.buildBicycleRoute(
          currentGeoLocation,
          destPoint,
        );
        break;

      case RouteTypes.pedestrian:
        await _plansService.buildPedestrianRoute(
          currentGeoLocation,
          destPoint,
        );
        break;

      case RouteTypes.driving:
        await _plansService.buildDrivingRoute(
          currentGeoLocation,
          destPoint,
        );
        break;
    }

    yield RouteSelectSliderState(
      details: details,
      data: data,
      destPoint: destPoint,
      routeInfo: info,
      routeType: routeType,
      time: time,
    );
  }

  Stream<PlanDetailsState> _showMyLocation(OnShowMyLocation event) async* {
    await _plansService.showMyLocation();
  }

  Stream<PlanDetailsState> _selectPlace(OnSelectPlace event) async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;
    final Spot spot = currentState.details.body.spots.singleWhere(
          (t) => t.ref == event.spotRef,
      orElse: () =>
          currentState.details.body.spotsNoDate
              .singleWhere((t) => t.ref == event.spotRef),
    );
    final Point destPoint = _plansService.getPointByRef(event.spotRef);
    await _plansService.moveToPlace(spot);
    yield DetailedSliderState(currentState.details, spot, destPoint);
  }

  Stream<PlanDetailsState> _closeDetailedSlider(
      OnCloseDetailedSlider event) async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;
    await _plansService.showAllPoints();
    yield LoadedState(currentState.details);
  }

  Stream<PlanDetailsState> _deletePlan(OnDeletePlan event) async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;
    yield InitialLoadingDetailsState();
    bool isDeleted = await _plansService.deletePlan(currentState.details.ref);
    yield RouteToPlanListState(isDeleted);
  }

  Stream<PlanDetailsState> _deleteActivity(OnDeleteActivity event) async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;

    final lastDetails = currentState.details;

    yield LoadingDetailsState(currentState.details);
    var select = currentState.details.header.selectedDateRef;
    await _plansService.deleteActivity(
      currentState.details.ref,
      event.activityId,
      isLastInDay: (bool isLast) {
        if (isLast) {
          select = Optional.empty();
        }
      },
    );

    try {
      final details = await _plansService.getPlanDetails(
        detailsRef,
        select,
      );
      await _plansService.showAllPoints();

      yield LoadedState(details);
    } catch (e) {
      yield LoadedState(lastDetails);
      throw e;
    }
  }

  Stream<PlanDetailsState> _assignActivityDate(
      OnAssignActivityDate event) async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;

    final lastDetails = currentState.details;

    yield LoadingDetailsState(currentState.details);
    var select = Optional.of(_dateAdapter(event.dateTime));
    await _plansService.assignActivityDate(
      currentState.details.ref,
      event.spot.ref,
      _dateAdapter(event.dateTime),
      isLastInDay: (bool isLast) {
        if (isLast) {
          select = Optional.empty();
        }
      },
    );
    try {
      final details = await _plansService.getPlanDetails(
        currentState.details.ref,
        select,
      );
      await _plansService.showAllPoints();

      yield LoadedState(details);
    } catch (e) {
      yield LoadedState(lastDetails);
      throw e;
    }
  }

  String _dateAdapter(DateTime date) {
    if (date == null) {
      throw Exception('Date should not be null!');
    }
    String d = date.toString();
    return '${d.substring(8, 10)}.${d.substring(5, 7)}.${d.substring(0, 4)}';
  }

  Stream<PlanDetailsState> _closeRouteSlider(OnCloseRouteSlider event) async* {
    assert(state is RouteSelectSliderState);
    final currentState = state as RouteSelectSliderState;
    await _plansService.moveToPlace(currentState.data);
    await _plansService.clearRoutes();
    yield DetailedSliderState(
      currentState.details,
      currentState.data,
      currentState.destPoint,
    );
  }

  Stream<PlanDetailsState> _onAddToTrip(OnAddToTrip event) async* {
    yield RouteAddToTripState(detailsRef);
  }

  Stream<PlanDetailsState> _setupMap(OnYandexMapReady event) async* {
    await _plansService.setupMap(event.controller, event.onMarkTap);
  }

  Stream<PlanDetailsState> _onRouteToUpdatePlanName(
      OnClickUpdatePlanName event) async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;
    yield RouteToUpdatePlanNameState(currentState.details);
    yield UpdatePlanNameState(currentState.details);
  }

  Stream<PlanDetailsState> _routeTrigger() async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;
    yield LoadedState(currentState.details);
  }

  Stream<PlanDetailsState> _updatePlanNameSubmit(
      OnUpdatePlanNameSubmit event) async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;
    yield UpdatingPlanNameState(currentState.details);

    final newDetails =
    await _plansService.updatePlanDetailsName(detailsRef, event.name);
    yield UpdatedPlanNameState(newDetails);
  }
}
