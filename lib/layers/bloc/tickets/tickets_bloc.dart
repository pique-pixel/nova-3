import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rp_mobile/containers/page.dart';
import 'package:rp_mobile/layers/bloc/tickets/tickets_models.dart';
import 'package:rp_mobile/layers/services/tickets_services.dart';
import 'package:rp_mobile/utils/bloc.dart';
import './bloc.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  final TicketsService _ticketsService;
  final _loadedItems = <TicketItemModel>[];
  Page _lastPage;

  TicketsState _checkpoint;

  TicketsBloc(this._ticketsService);

  @override
  TicketsState get initialState => InitialTicketsState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    add(OnUnhandledException());
  }

  @override
  Stream<TicketsState> mapEventToState(TicketsEvent event) async* {
    if (event is OnUnhandledException) {
      if (_checkpoint == null || _checkpoint is InitialTicketsState) {
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
    } else if (event is OnShowBottomSheet) {
      _checkpoint = state;
      yield* _showBottomSheet(event);
    } else if (event is OnCloseBottomSheet) {
      yield (state as CascadeState).prevState;
    } else if (event is OnRouteDetails) {
      _checkpoint = state;
      yield* _routeDetails(event);
    } else if (event is OnTriggerRoute) {
      yield* _routeTrigger();
    } else {
      _checkpoint = state;
      throw UnsupportedError('Unsupported event: $event');
    }
  }

  Stream<TicketsState> _loadList() async* {
    yield LoadingListState();
    final page = await _ticketsService.getTickets();

    _lastPage = page;
    _loadedItems.clear();
    _loadedItems.addAll(page.data);

    yield LoadedState(_loadedItems);
  }

  Stream<TicketsState> _loadNextPage() async* {
    if (_lastPage?.isLastPage ?? true) {
      return;
    }

    assert(state is LoadedState);

    yield LoadingPageState((state as LoadedState).items);
    final page = await _ticketsService.getTickets(_lastPage.nextPage);

    _lastPage = page;
    _loadedItems.addAll(page.data);

    yield LoadedState(_loadedItems);
  }

  Stream<TicketsState> _refreshList() async* {
    assert(state is LoadedState);
    yield RefreshingListState((state as LoadedState).items);
    final page = await _ticketsService.getTickets();

    _lastPage = page;
    _loadedItems.clear();
    _loadedItems.addAll(page.data);

    yield LoadedState(_loadedItems);
  }

  Stream<TicketsState> _showBottomSheet(OnShowBottomSheet event) async* {
    final info = await _ticketsService.getTicketInfo(event.ref);
    yield BottomSheetState(
      prevState: state,
      ticketInfo: info,
    );
  }

  Stream<TicketsState> _routeDetails(OnRouteDetails event) async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;
    final type = await _ticketsService.getTicketType(event.ref);

    switch (type) {
      case TicketType.package:
        yield RouteToPackageState(currentState.items, event.ref);
        break;

      case TicketType.transport:
        yield RouteToTransportState(currentState.items, event.ref);
        break;

      case TicketType.museum:
        yield RouteToMuseumState(currentState.items, event.ref);
        break;
    }
  }

  Stream<TicketsState> _routeTrigger() async* {
    assert(state is LoadedState);
    final currentState = state as LoadedState;
    yield LoadedState(currentState.items);
  }
}
