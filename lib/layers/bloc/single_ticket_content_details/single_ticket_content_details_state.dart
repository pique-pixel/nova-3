import 'package:equatable/equatable.dart';
import 'package:rp_mobile/layers/bloc/single_ticket_content_details/single_ticket_content_details_models.dart';

abstract class SingleTicketContentDetailsState extends Equatable {
  const SingleTicketContentDetailsState();
}

class InitialSingleTicketContentDetailsState extends SingleTicketContentDetailsState {
  @override
  List<Object> get props => [];
}

class LoadingState extends SingleTicketContentDetailsState {
  @override
  List<Object> get props => [];
}

class LoadingErrorState extends SingleTicketContentDetailsState {
  @override
  List<Object> get props => [];
}

class LoadedState extends SingleTicketContentDetailsState {
  final SingleTicketContentDetails details;

  LoadedState(this.details);

  @override
  List<Object> get props => [details];
}
