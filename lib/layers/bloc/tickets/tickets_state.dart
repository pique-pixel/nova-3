import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rp_mobile/layers/bloc/tickets/tickets_models.dart';
import 'package:rp_mobile/utils/bloc.dart';

abstract class TicketsState extends Equatable {
  const TicketsState();
}

class InitialTicketsState extends TicketsState {
  @override
  List<Object> get props => [];
}

class LoadingListState extends TicketsState {
  @override
  List<Object> get props => [];
}

class LoadingListErrorState extends TicketsState {
  @override
  List<Object> get props => [];
}

class LoadedState extends TicketsState {
  final List<TicketItemModel> items;

  LoadedState(this.items);

  @override
  List<Object> get props => items;
}

class LoadingPageState extends LoadedState {
  LoadingPageState(List<TicketItemModel> items) : super(items);
}

class RefreshingListState extends LoadedState {
  RefreshingListState(List<TicketItemModel> items) : super(items);
}

class RouteToPackageState extends LoadedState {
  final String ref;

  RouteToPackageState(List<TicketItemModel> items, this.ref) : super(items);

  List<Object> get props => [items, ref];
}

class RouteToTransportState extends LoadedState {
  final String ref;

  RouteToTransportState(List<TicketItemModel> items, this.ref) : super(items);

  List<Object> get props => [items, ref];
}

class RouteToMuseumState extends LoadedState {
  final String ref;

  RouteToMuseumState(List<TicketItemModel> items, this.ref) : super(items);

  List<Object> get props => [items, ref];
}

class BottomSheetState extends TicketsState implements CascadeState {
  final TicketsState prevState;
  final TicketInfoModel ticketInfo;
  final bool hasTriggeredRoute;

  BottomSheetState({
    @required this.prevState,
    @required this.ticketInfo,
    this.hasTriggeredRoute = false,
  })  : assert(prevState != null),
        assert(ticketInfo != null),
        assert(hasTriggeredRoute != null),
        super();

  @override
  List<Object> get props => [prevState, ticketInfo, hasTriggeredRoute];
}
