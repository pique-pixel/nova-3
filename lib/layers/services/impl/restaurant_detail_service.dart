import 'package:rp_mobile/layers/services/restaurant_detail_service.dart';
import 'package:rp_mobile/layers/drivers/api/gateway.dart';
import 'package:rp_mobile/layers/adapters/ui_models_factory.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'package:rp_mobile/layers/bloc/restaurant_detail/restaurant_detail_models.dart';


class RestaurantDetailServiceImpl implements RestaurantDetailService {
  final ApiGateway _apiGateway;
  final UiModelsFactory _uiModelsFactory;
  final SessionService _sessionService;


  RestaurantDetailServiceImpl(
      this._apiGateway,
      this._uiModelsFactory,
      this._sessionService,);

  @override
  Future<RestaurantDetail> getRestaurantDetails(
      String ref,
      ) => _sessionService.refreshSessionOnUnauthorized(() async {
    final response = await _apiGateway.getRestaurantDetails(ref);

    return _uiModelsFactory.createRestaurantDetails(response);
  });
}