import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rp_mobile/layers/services/packages_service.dart';
import 'package:rp_mobile/utils/collections.dart';
import 'package:rxdart/rxdart.dart';
import './bloc.dart';

class ServicesPackageDetailsBloc
    extends Bloc<ServicesPackageDetailsEvent, ServicesPackageDetailsState> {
  final String _ref;
  final PackagesService _packagesService;
  ServicesPackageDetailsState _checkpoint;

  ServicesPackageDetailsBloc(this._ref, this._packagesService);

  @override
  ServicesPackageDetailsState get initialState =>
      InitialServicesPackageDetailsState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    add(OnUnhandledException());
  }

  @override
  Stream<ServicesPackageDetailsState> transformEvents(
    Stream<ServicesPackageDetailsEvent> events,
    Stream<ServicesPackageDetailsState> Function(
            ServicesPackageDetailsEvent event)
        next,
  ) {
    // NOTE(Andrey): Prevent events spamming
    final filterEvents = (events as Stream<ServicesPackageDetailsEvent>)
        .where((event) => event is OnFilterActivities)
        .debounceTime(Duration(milliseconds: 300))
        .switchMap(next);

    final otherEvents = (events as Stream<ServicesPackageDetailsEvent>)
        .where((event) => event is! OnFilterActivities)
        .asyncExpand(next);

    return Rx.merge([filterEvents, otherEvents]);
  }

  @override
  Stream<ServicesPackageDetailsState> mapEventToState(
    ServicesPackageDetailsEvent event,
  ) async* {
    if (event is OnUnhandledException) {
      if (_checkpoint == null ||
          _checkpoint is InitialServicesPackageDetailsState) {
        yield LoadingErrorState();
      } else {
        yield _checkpoint;
      }

      _checkpoint = null;
    } else if (event is OnLoad) {
      _checkpoint = state;
      yield* _loadDetails();
    } else if (event is OnChangeCity) {
      _checkpoint = state;
      yield* _changeCity(event);
    } else if (event is OnExpandActivities) {
      _checkpoint = state;
      yield* _expandActivities();
    } else if (event is OnFilterActivities) {
      _checkpoint = state;
      yield* _filterActivities(event);
    } else {
      _checkpoint = state;
      throw UnsupportedError('Unsupported event: $event');
    }
  }

  Stream<ServicesPackageDetailsState> _loadDetails() async* {
    yield LoadingState();
    final data = await _packagesService.getPackageDetails(_ref);
    yield LoadedState(data);
  }

  Stream<ServicesPackageDetailsState> _changeCity(OnChangeCity event) async* {
    yield LoadingState();
    final data = await _packagesService.getPackageDetailsForCity(
      _ref,
      event.cityRef,
    );
    yield LoadedState(data);
  }

  Stream<ServicesPackageDetailsState> _expandActivities() async* {
    assert(state is LoadedState);
    final loadedState = state as LoadedState;

    yield LoadingAllActivitiesState(loadedState.sections);

    final ActivitiesSection activitiesSection =
        loadedState.sections.firstWhere((it) => it is ActivitiesSection);

    final filters = activitiesSection?.filters
        ?.where((it) => it.isActive)
        ?.map((it) => it.ref)
        ?.toList();

    final activities = await _packagesService.getAllPackageActivities(
      _ref,
      filters ?? [],
    );

    final sections = cloneListAndReplace(
      loadedState.sections,
      (it) => it is ActivitiesSection,
      activities,
    );

    yield LoadedState(sections);
  }

  Stream<ServicesPackageDetailsState> _filterActivities(
    OnFilterActivities event,
  ) async* {
    assert(state is LoadedState);
    final loadedState = state as LoadedState;

    final ActivitiesSection activitiesSection = loadedState.sections.firstWhere(
      (it) => it is ActivitiesSection,
    );

    if (activitiesSection != null) {
      final filters = cloneListAndReplaceMap<ActivityFilter>(
        activitiesSection.filters,
        (it) => event.filters.contains(it.ref),
        (it) => it.copyWith(isActive: true),
      );

      final sections = cloneListAndReplace(
        loadedState.sections,
        (it) => it is ActivitiesSection,
        activitiesSection.copyWith(filters: filters),
      );

      yield FilteringActivitiesState(sections);
    } else {
      yield FilteringActivitiesState(loadedState.sections);
    }

    final activities = await _packagesService.filterPackageActivities(
      _ref,
      event.filters,
      activitiesSection?.isLoadedAllItems ?? false,
    );

    final sections = cloneListAndReplace(
      loadedState.sections,
      (it) => it is ActivitiesSection,
      activities,
    );

    yield LoadedState(sections);
  }
}
