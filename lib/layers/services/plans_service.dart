import 'package:flutter/cupertino.dart';
import 'package:optional/optional.dart';
import 'package:rp_mobile/containers/page.dart';
import 'package:rp_mobile/layers/bloc/plan_details/bloc.dart';
import 'package:rp_mobile/layers/bloc/plan_details/plan_models.dart';
import 'package:rp_mobile/layers/bloc/plans/plans_models.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

abstract class PlansService {
  Future<PlanDetails> getPlanDetails(String ref, Optional<String> dateRef);

  Future<PlanDetails> updatePlanDetailsName(String ref, String name);

  Future<void> setupMap(YandexMapController controller,
      void Function(String) onTapOnMark,);

  Future<Page<PlanItemModel>> getPlans([int page = 1]);

  Future<List<PlanItemModel>> getRecommendations();

  Future<bool> isRecommendationHide();

  Future<PlanItemModel> createPlan(String name);

  Future<bool> deletePlan(String id);

  Future<bool> deleteActivity(String planId,
      String activityId, {
        void Function(bool b) isLastInDay,
      });

  Future<bool> assignActivityDate(String planId,
      String activityId,
      String date, {
        void Function(bool b) isLastInDay,
      });

  Future<void> moveToPlace(Spot ref);

  Future<void> showAllPoints();

  Future<void> showMyLocation();

  Point getPointByRef(String ref);

  Future<Map<RouteTypes, String>> estimateRoutes({
    @required Point srcPoint,
    @required Point destPoint,
  });

  Future<RouteInfo> buildMasstransitRoute(Point srcPoint, Point destPoint);

  Future<void> buildPedestrianRoute(Point srcPoint, Point destPoint);

  Future<void> buildBicycleRoute(Point srcPoint, Point destPoint);

  Future<void> buildDrivingRoute(Point srcPoint, Point destPoint);

  Future<void> clearRoutes();

  Future<bool> addActivityToPlan(String name, String activityId, String type);
}
