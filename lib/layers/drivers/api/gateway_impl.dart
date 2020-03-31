import 'package:dio/dio.dart';
import 'package:optional/optional.dart';
import 'package:rp_mobile/config.dart';
import 'package:rp_mobile/layers/drivers/api/gateway.dart';
import 'package:rp_mobile/layers/drivers/api/models.dart';
import 'package:rp_mobile/layers/drivers/api/session.dart';
import 'package:rp_mobile/layers/drivers/dio_client.dart';
import 'package:rp_mobile/utils/json.dart';

import 'model/registerResponse.dart';

class ApiGatewayImpl implements ApiGateway {
  Optional<Session> _session = const Optional.empty();
  final DioClient _client;
  final Config _config;

  ApiGatewayImpl(this._client, this._config);

  @override
  Future<void> updateSession(Session session) async {
    assert(session != null);
    _session = Optional.of(session);
  }

  @override
  Future<void> clearSession() async {
    _session = Optional.empty();
  }

  @override
  Future<void> createConfirmEmail(String token) async {
    await _client.get(
      '/user/users/confirm/create?token=$token',
      session: _session,
    );
  }

  @override
  Future<TokenResponse> token(TokenRequest request) async {
    assert(request != null);
    final response = await _client.post(
      '/sso/oauth/token?${request.toWWWFormUrlencoded()}',
      options: Options(
        headers: {'Authorization': 'Basic ${_config.apiBaseAuthToken}'},
      ),
    );
    return TokenResponse.fromJson(_client.getJsonBody(response));
  }

  @override
  Future<TicketsListResponse> getTicketsList([int page = 0]) async {
    final response = await _client.get(
      '/content/b/user/order/list?active=true&size=10&page=$page',
      session: _session,
    );
    return TicketsListResponse.fromJson(_client.getJsonBody(response));
  }

  @override
  Future<FavoriteResponse> getFavoriteList([int page = 0]) async {
    final response = await _client.get(
      '/content/favorite/lite',
      session: _session,
    );
    return FavoriteResponse.fromJson(_client.getJsonBody(response));
  }

  @override
  Future<FavoriteMyDetailResponse> getFavoritDetailById(String id) async {
    final response = await _client.get(
      '/content/favorite/detail/$id',
      session: _session,
    );
    return FavoriteMyDetailResponse.fromJson(_client.getJsonBody(response));
  }

  @override
  Future<OfferResponse> getOfferById(String id) async {
    final response = await _client.get(
      '/content/offer/$id',
      session: _session,
    );
    return OfferResponse.fromJson(_client.getJsonBody(response));
  }

  @override
  Future<RegisterResposne> createSession(RegisterRequest request)async {
    final response = await _client.post(
      '/user/users',
      data: request.toJson(),
    );
    return RegisterResposne.fromJson(_client.getJsonBody(response));
  }

  @override
  Future<List<PlanViewLiteResponse>> getMyActivePlansLite() async {
    final response = await _client.get(
      '/content/plan/active/lite',
      session: _session,
    );
    return transformJsonList(
      _client.getJsonBodyList(response),
      (it) => PlanViewLiteResponse.fromJson(it),
    );
  }

  @override
  Future<PlanDetailedViewResponseWithResponse> getPlanDetails(
      String ref) async {
    final response = await _client.get(
      '/content/plan/$ref',
      session: _session,
    );
    return PlanDetailedViewResponseWithResponse(
      planDetailedViewResponse:
      PlanDetailedViewResponse.fromJson(_client.getJsonBody(response)),
      response: response.data,
    );
  }

  @override
  Future<CreatePlanResponse> createPlan(String name) async {
    final response = await _client.post(
      '/content/plan',
      session: _session,
      data: {
        'plans': [
          {'name': '$name', 'level': '', 'activities': []}
        ]
      },
    );
    return transformJsonList(_client.getJsonBodyList(response),
            (it) => CreatePlanResponse.fromJson(it)).first;
  }

  @override
  Future<bool> deletePlan(String id) async {
    final response = await _client.delete(
      '/content/plan/$id',
      session: _session,
    );
    return response.statusCode == 204;
  }

  @override
  Future<bool> updatePlan(Map<String, dynamic> updatedData) async {
    final response = await _client.post(
      '/content/plan',
      data: updatedData,
      session: _session,
    );
    print('${response.statusCode} ${response.data}');
    return response != null ? response.statusCode == 200 : false;
  }

  @override
  Future<Map<String, dynamic>> getPlanJson(String plansId) async {
    final response = await _client.get(
      '/content/plan/$plansId',
      session: _session,
    );
    print(response.statusCode);
    print(response.data);

    return null;
  }

  @override
  Future<bool> addActivityToPlan(String name, String activityId, String type) async {
    final request = {
      "plans": [
        {
          "name": "$name",
          "activities": [
            {"id":"$activityId","type":"$type"}
          ]
        }
      ]
    };

    final response = await _client.post(
      '/content/plan',
      data: request,
      session: _session,
    );

    return response != null ? response.statusCode == 200 : false;
  }

  @override
  Future<PackageDetailResponse> getPackageDetails(String ref) async {
    //TODO как передать язык?
    final response = await _client.get(
      '/cmsapi/route?language=ru&id=$ref',
      session: _session,
    );

    return PackageDetailResponse.fromJson(_client.getJsonBody(response));
  }

  @override
  Future<EventDetailResponse> getEventDetails(String ref) async {
    //TODO как передать язык?
    final response = await _client.get(
      '/cmsapi/event?language=ru&id=$ref',
      session: _session,
    );

    return EventDetailResponse.fromJson(_client.getJsonBody(response));
  }

  @override
  Future<FavoriteResponse> createNewFavoriteList(
      FavoriteListRequest request) async {
    final response = await _client.post(
      '/content/favorite',
      data: request.createRequestBody(),
      session: _session,
    );
    return FavoriteResponse.fromJson(_client.getJsonBody(response));
  }

  @override
  Future<FavoriteForPlanResponse> getFavoriteForPlanById(String ref) async {
    final response = await _client.get(
      '/content/favorite/detail/$ref',
      session: _session,
    );
    return FavoriteForPlanResponse.fromJson(_client.getJsonBody(response));
  }

  @override
  Future createPlanFromFavorite(String name, List activities) async {
    final request = {
      "plans": [
        {
          "name": "$name",
          "level": "",
          "airlineTickets": [{}],
          "railwayTickets": [{}],
          "hotels": [{}],
          "days": [],
          "activities": activities.map((it) {
            return {
              "id": it.id,
              "type": it.type,
            };
          }).toList()
        }
      ]
    };

    final response = await _client.post(
      '/content/plan',
      data: request,
      session: _session,
    );
  }

  @override
  Future deleteFavoriteList(String id) async {
    final response = await _client.delete(
      '/content/favorite/my/$id',
      session: _session,
    );
  }

  Future<RestaurantDetailResponse> getRestaurantDetails(String ref) async {
    //TODO как передать язык?
    final response = await _client.get(
      '/cmsapi/restaurant?language=ru&id=$ref',
      session: _session,
    );

    return RestaurantDetailResponse.fromJson(_client.getJsonBody(response));
  }
}
