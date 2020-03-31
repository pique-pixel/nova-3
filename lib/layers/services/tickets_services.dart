import 'package:rp_mobile/containers/page.dart';
import 'package:rp_mobile/exceptions.dart';
import 'package:rp_mobile/layers/bloc/single_ticket_content_details/single_ticket_content_details_models.dart';
import 'package:rp_mobile/layers/bloc/tickets/tickets_models.dart';
import 'package:rp_mobile/locale/localized_string.dart';

abstract class TicketsService {
  Future<Page<TicketItemModel>> getTickets([int page = 1]);

  Future<TicketInfoModel> getTicketInfo(String ref);

  Future<TicketType> getTicketType(String ref);

  Future<SingleTicketContentDetails> getSingleTicketContentDetails(String ref);
}

class TicketsException implements LocalizeMessageException {
  final LocalizedString localizedMessage;
  final String message;

  TicketsException(this.localizedMessage, this.message);
}
