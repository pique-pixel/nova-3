import 'package:rp_mobile/containers/page.dart';
import 'package:rp_mobile/layers/adapters/ui_models_factory.dart';
import 'package:rp_mobile/layers/bloc/single_ticket_content_details/single_ticket_content_details_models.dart';
import 'package:rp_mobile/layers/bloc/tickets/tickets_models.dart';
import 'package:rp_mobile/layers/drivers/api/gateway.dart';
import 'package:rp_mobile/layers/drivers/api/models.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'package:rp_mobile/layers/services/tickets_services.dart';
import 'package:rp_mobile/locale/localized_string.dart';

class TicketsServiceImpl implements TicketsService {
  final ApiGateway _apiGateway;
  final UiModelsFactory _uiModelsFactory;
  final SessionService _sessionService;

  final contents = <String, TicketsListContentResponse>{};
  final items = <String, TicketsListContentItemResponse>{};

  TicketsServiceImpl(
    this._apiGateway,
    this._uiModelsFactory,
    this._sessionService,
  );

  @override
  Future<Page<TicketItemModel>> getTickets([int page = 1]) =>
      _sessionService.refreshSessionOnUnauthorized(() async {
        final response = await _apiGateway.getTicketsList(page - 1);

        if (page == 1) {
          contents.clear();
          items.clear();
        }

        for (final content in response.content) {
          for (final item in content.items) {
            if (!item.item.offerContent.isPresent) {
              continue;
            }

            final offerContent = item.item.offerContent.value;
            contents[offerContent.id.toString()] = content;
            items[offerContent.id.toString()] = item;
          }
        }

        return _uiModelsFactory.createTicketsPage(response);
      });

  @override
  Future<TicketInfoModel> getTicketInfo(String ref) async {
    if (!contents.containsKey(ref) || !items.containsKey(ref)) {
      throw TicketsException(
        LocalizedString.fromString('Ticket information hasn\'t found'),
        'Ticket information hasn\'t found',
      );
    }

    return _uiModelsFactory.createTicketInfo(
      contents[ref],
      items[ref],
    );
  }

  @override
  Future<TicketType> getTicketType(String ref) async {
    return TicketType.museum;
  }

  @override
  Future<SingleTicketContentDetails> getSingleTicketContentDetails(
    String ref,
  ) => _sessionService.refreshSessionOnUnauthorized(() async {
    final response = await _apiGateway.getOfferById(ref);
    return _uiModelsFactory.createSingleTicketContentDetails(response);
  });
}
