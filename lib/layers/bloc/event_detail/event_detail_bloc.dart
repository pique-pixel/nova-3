import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rp_mobile/layers/services/event_detail_service.dart';
import './bloc.dart';

class EventDetailBloc extends Bloc<
    EventDetailEvent, EventDetailState> {

  final EventDetailService _eventDetailService;
  EventDetailState _checkpoint;

  EventDetailBloc(this._eventDetailService);

  @override
  EventDetailState get initialState =>
      InitialEventDetailState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    add(OnUnhandledException());
  }

  @override
  Stream<EventDetailState> mapEventToState(
      EventDetailEvent event,
      ) async* {
    if (event is OnUnhandledException) {
      if (_checkpoint == null || _checkpoint is InitialEventDetailState) {
        yield EventLoadingErrorState();
      } else {
        yield _checkpoint;
      }

      _checkpoint = null;
    } else if (event is EventOnLoad) {
      _checkpoint = state;
      yield* _loadDetail(event);
    }
  }

  Stream<EventDetailState> _loadDetail(EventOnLoad event) async* {
    yield EventLoadingState();
    final detail = await _eventDetailService.getEventDetails(event.ref);
    yield EventLoadedState(detail);
  }
}