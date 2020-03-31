import 'package:optional/optional.dart';
import 'package:rp_mobile/containers/page.dart';
import 'package:rp_mobile/layers/bloc/plan_details/plan_models.dart';
import 'package:rp_mobile/layers/bloc/plans/plans_models.dart';
import 'package:rp_mobile/layers/bloc/single_favorite_my_content_details/single_favorite_my_content_details_models.dart';
import 'package:rp_mobile/layers/bloc/single_ticket_content_details/single_ticket_content_details_models.dart';
import 'package:rp_mobile/layers/bloc/tickets/tickets_models.dart';
import 'package:rp_mobile/layers/bloc/favorites/favorite_models.dart';
import 'package:rp_mobile/layers/bloc/services_package_details/services_package_details_models.dart';
import 'package:rp_mobile/layers/bloc/event_detail/event_detail_models.dart';
import 'package:rp_mobile/layers/bloc/restaurant_detail/restaurant_detail_models.dart';
import 'package:rp_mobile/layers/drivers/api/models.dart';

abstract class UiModelsFactory {
  Page<TicketItemModel> createTicketsPage(
    TicketsListResponse response,
  );

  TicketItemModel createTicket(
    TicketsListContentResponse content,
    TicketsListContentItemResponse response,
  );

  TicketInfoModel createTicketInfo(
    TicketsListContentResponse content,
    TicketsListContentItemResponse response,
  );

  SingleTicketContentDetails createSingleTicketContentDetails(
    OfferResponse response,
  );

  Page<PlanItemModel> createPlansPage(List<PlanViewLiteResponse> response);

  PlanItemModel createPlanItemModel(PlanViewLiteResponse response);

  PlanDetails createPlanDetails(PlanDetailedViewResponse response, Optional<String> selectedDateRef);

  FavoriteModel createFavorite(
    FavoriteResponse response,
  );

  FavoriteMyItemModel createFavoriteMy(
    FavoriteMyResponse item,
  );

  FavoriteMyDetailModel createFavoriteDetailById(
    FavoriteMyDetailResponse response,
  );

  FavoriteForPlan createFavoriteForPlanById(
      FavoriteForPlanResponse response,
      );

  PackageDetail createPackageDetails(PackageDetailResponse response);

  EventDetail createEventDetails(EventDetailResponse response);

  RestaurantDetail createRestaurantDetails(RestaurantDetailResponse response);

}
