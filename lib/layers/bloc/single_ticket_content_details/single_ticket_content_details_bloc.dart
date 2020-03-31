import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rp_mobile/layers/services/tickets_services.dart';
import './bloc.dart';

class SingleTicketContentDetailsBloc extends Bloc<
    SingleTicketContentDetailsEvent, SingleTicketContentDetailsState> {

  final TicketsService _ticketsService;
  SingleTicketContentDetailsState _checkpoint;

  SingleTicketContentDetailsBloc(this._ticketsService);

  @override
  SingleTicketContentDetailsState get initialState =>
      InitialSingleTicketContentDetailsState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    add(OnUnhandledException());
  }

  @override
  Stream<SingleTicketContentDetailsState> mapEventToState(
    SingleTicketContentDetailsEvent event,
  ) async* {
    if (event is OnUnhandledException) {
      if (_checkpoint == null || _checkpoint is InitialSingleTicketContentDetailsState) {
        yield LoadingErrorState();
      } else {
        yield _checkpoint;
      }

      _checkpoint = null;
    } else if (event is OnLoad) {
      _checkpoint = state;
      yield* _loadDetails(event);
    }
  }

  Stream<SingleTicketContentDetailsState> _loadDetails(OnLoad event) async* {
    yield LoadingState();
    final detail = await _ticketsService.getSingleTicketContentDetails(event.ref);
    yield LoadedState(detail);
  }
}
