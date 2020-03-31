import 'package:rp_mobile/exceptions.dart';
import 'package:rp_mobile/layers/drivers/api/session.dart';
import 'package:rp_mobile/locale/localized_string.dart';

import 'model/registerResponse.dart';
import 'models.dart';

abstract class ApiGateway {
  Future<void> updateSession(Session session);

  Future<void> clearSession();

  Future<RegisterResposne> createSession(RegisterRequest request);

  Future<TokenResponse> token(TokenRequest request);

  Future<void> createConfirmEmail(String token);

  Future<TicketsListResponse> getTicketsList([int page = 0]);

  Future<FavoriteResponse> getFavoriteList();

  Future<FavoriteMyDetailResponse> getFavoritDetailById(String id);

  Future<OfferResponse> getOfferById(String id);

  Future<List<PlanViewLiteResponse>> getMyActivePlansLite();

  //Future<PlanDetailedViewResponse> getPlanDetails(String ref);

  Future<PackageDetailResponse> getPackageDetails(String ref);

  Future<EventDetailResponse> getEventDetails(String ref);

  Future<FavoriteResponse> createNewFavoriteList(FavoriteListRequest request);

  Future<FavoriteForPlanResponse> getFavoriteForPlanById(String ref);

  Future createPlanFromFavorite(String name, List activities);

  Future<bool> addActivityToPlan(String name, String activityId, String type);

  Future deleteFavoriteList(String id);

  
  Future<RestaurantDetailResponse> getRestaurantDetails(String ref);

  Future<PlanDetailedViewResponseWithResponse> getPlanDetails(String ref);

  Future<CreatePlanResponse> createPlan(String name);

  Future<bool> deletePlan(String id);

  Future<bool> updatePlan(Map<String, dynamic> updatedData);

  Future<Map<String, dynamic>> getPlanJson(String plansId);
}

class PlanDetailedViewResponseWithResponse {
  final PlanDetailedViewResponse planDetailedViewResponse;
  final Map<String, dynamic> response;

  PlanDetailedViewResponseWithResponse({
    this.planDetailedViewResponse,
    this.response,
  });

}

class ApiException implements LocalizeMessageException {
  final LocalizedString localizedMessage;
  final String message;

  ApiException(this.localizedMessage, this.message);
}

class ApiUnauthorizedException extends ApiException {
  ApiUnauthorizedException()
      : super(
          LocalizedString.fromString('Unauthorized'),
          'Unauthorized',
        );
}
