import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rp_mobile/containers/page.dart';
import 'package:rp_mobile/layers/bloc/plans/plans_models.dart';
import 'package:rp_mobile/layers/services/plans_service.dart';
import './bloc.dart';

class PlansBloc extends Bloc<PlansEvent, PlansState> {
  final PlansService _plansService;

  final _loadedItems = <PlanItemModel>[];
  Page _lastPage;

  PlansState _checkpoint;

  PlansBloc(this._plansService);

  @override
  PlansState get initialState => InitialPlansState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    add(OnUnhandledException());
  }

  @override
  Stream<PlansState> mapEventToState(
    PlansEvent event,
  ) async* {
    if (event is OnUnhandledException) {
      if (_checkpoint == null || _checkpoint is InitialPlansState) {
        yield LoadingListErrorState();
      } else {
        yield _checkpoint;
      }

      _checkpoint = null;
    } else if (event is OnLoad) {
      _checkpoint = state;
      yield* _loadList();
    } else if (event is OnNextPage) {
      _checkpoint = state;
      yield* _loadNextPage();
    } else if (event is OnRefresh) {
      _checkpoint = state;
      yield* _refreshList();
    } else if (event is OnSelectItem) {
      _checkpoint = state;
      yield* _routeToDetails(event);
    } else if (event is OnTriggerRoute) {
      yield* _routeTrigger();
    } else if (event is OnCreatePlanClick) {
      yield* _routeToCreatePlanTrigger();
    } else if (event is OnCreatePlanSubmit) {
      _checkpoint = state;
      yield* _createPlanSubmit(event);
    } else if (event is OnAddActivityToPlan) {
      yield* _onAddActivityToPlan(event);
    } else {
      _checkpoint = state;
      throw UnsupportedError('Unsupported event: $event');
    }
  }

  Stream<PlansState> _loadList() async* {
    yield LoadingListState();

    final page = await _plansService.getPlans();
    final recommendations = await _plansService.getRecommendations();
    final isRecommendationHide = await _plansService.isRecommendationHide();

    _lastPage = page;
    _loadedItems.clear();
    _loadedItems.addAll(page.data);

    yield LoadedState(_loadedItems, recommendations, isRecommendationHide);
  }

  Stream<PlansState> _loadNextPage() async* {
    if (_lastPage?.isLastPage ?? true) {
      return;
    }

    assert(state is LoadedState);

    final currentState = state as LoadedState;

    yield LoadingPageState(
      currentState.items,
      currentState.recommendations,
      currentState.isRecommendationHide,
    );

    final page = await _plansService.getPlans(_lastPage.nextPage);
    final recommendations = await _plansService.getRecommendations();
    final isRecommendationHide = await _plansService.isRecommendationHide();

    _lastPage = page;
    _loadedItems.addAll(page.data);

    yield LoadedState(_loadedItems, recommendations, isRecommendationHide);
  }

  Stream<PlansState> _refreshList() async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;

    yield RefreshingListState(
      currentState.items,
      currentState.recommendations,
      currentState.isRecommendationHide,
    );

    final page = await _plansService.getPlans();
    final recommendations = await _plansService.getRecommendations();
    final isRecommendationHide = await _plansService.isRecommendationHide();

    _lastPage = page;
    _loadedItems.clear();
    _loadedItems.addAll(page.data);

    yield LoadedState(_loadedItems, recommendations, isRecommendationHide);
  }

  Stream<PlansState> _routeToDetails(OnSelectItem event) async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;

    yield RouteToDetailsState(
      event.ref,
      currentState.items,
      currentState.recommendations,
      currentState.isRecommendationHide,
    );
  }

  Stream<PlansState> _routeTrigger() async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;
    yield LoadedState(
      currentState.items,
      currentState.recommendations,
      currentState.isRecommendationHide,
    );
  }

  Stream<PlansState> _routeToCreatePlanTrigger() async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;
    yield RouteToCreatePlanState(
      currentState.items,
      currentState.recommendations,
      currentState.isRecommendationHide,
    );
    yield CreatePlanState(
      currentState.items,
      currentState.recommendations,
      currentState.isRecommendationHide,
    );
  }

  Stream<PlansState> _createPlanSubmit(OnCreatePlanSubmit event) async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;
    yield CreatingPlanState(
      currentState.items,
      currentState.recommendations,
      currentState.isRecommendationHide,
    );
    final newItem = await _plansService.createPlan(event.name);

    final page = await _plansService.getPlans();
    final recommendations = await _plansService.getRecommendations();
    final isRecommendationHide = await _plansService.isRecommendationHide();

    _lastPage = page;
    _loadedItems.clear();
    _loadedItems.addAll(page.data);

    yield CreatedPlanState(_loadedItems, recommendations, isRecommendationHide);
  }

  Stream<PlansState> _onAddActivityToPlan(OnAddActivityToPlan event) async* {
    try {
      bool isAdd = await _plansService.addActivityToPlan(event.name, event.activityId, event.type);
      yield ActivityToPlanState(isAdd);
    } catch (e) {
      yield LoadingListErrorState();
      throw e;
    }
  }
}
