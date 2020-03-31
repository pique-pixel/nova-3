import 'package:rp_mobile/layers/services/event_detail_service.dart';
import 'package:rp_mobile/layers/drivers/api/gateway.dart';
import 'package:rp_mobile/layers/adapters/ui_models_factory.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'package:rp_mobile/layers/bloc/event_detail/event_detail_models.dart';


class EventDetailServiceImpl implements EventDetailService {
  final ApiGateway _apiGateway;
  final UiModelsFactory _uiModelsFactory;
  final SessionService _sessionService;


  EventDetailServiceImpl(
      this._apiGateway,
      this._uiModelsFactory,
      this._sessionService,);

  @override
  Future<EventDetail> getEventDetails(
      String ref,
      ) => _sessionService.refreshSessionOnUnauthorized(() async {
    final response = await _apiGateway.getEventDetails(ref);

    return _uiModelsFactory.createEventDetails(response);
  });
}