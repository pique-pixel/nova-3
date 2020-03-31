import 'package:equatable/equatable.dart';
import 'package:rp_mobile/layers/bloc/plans/plans_models.dart';

abstract class PlansState extends Equatable {
  const PlansState();
}

class InitialPlansState extends PlansState {
  @override
  List<Object> get props => [];
}

class LoadingListState extends PlansState {
  @override
  List<Object> get props => [];
}

class LoadingListErrorState extends PlansState {
  @override
  List<Object> get props => [];
}

class LoadedState extends PlansState {
  final List<PlanItemModel> items;
  final List<PlanItemModel> recommendations;
  final bool isRecommendationHide;

  LoadedState(this.items, this.recommendations, this.isRecommendationHide);

  @override
  List<Object> get props => [items, recommendations, isRecommendationHide];
}

class RefreshingListState extends LoadedState {
  RefreshingListState(
    List<PlanItemModel> items,
    List<PlanItemModel> recommendations,
    bool isRecommendationHide,
  ) : super(items, recommendations, isRecommendationHide);
}

class LoadingPageState extends LoadedState {
  LoadingPageState(
    List<PlanItemModel> items,
    List<PlanItemModel> recommendations,
    bool isRecommendationHide,
  ) : super(items, recommendations, isRecommendationHide);
}

class CreatePlanPopupState extends LoadedState {
  CreatePlanPopupState(
    List<PlanItemModel> items,
    List<PlanItemModel> recommendations,
    bool isRecommendationHide,
  ) : super(items, recommendations, isRecommendationHide);
}

class RouteToDetailsState extends LoadedState {
  final String ref;

  RouteToDetailsState(
    this.ref,
    List<PlanItemModel> items,
    List<PlanItemModel> recommendations,
    bool isRecommendationHide,
  ) : super(items, recommendations, isRecommendationHide);

  @override
  List<Object> get props => [
        ref,
        items,
        recommendations,
        isRecommendationHide,
      ];
}

class RouteToCreatePlanState extends LoadedState {
  RouteToCreatePlanState(
    List<PlanItemModel> items,
    List<PlanItemModel> recommendations,
    bool isRecommendationHide,
  ) : super(
          items,
          recommendations,
          isRecommendationHide,
        );

  @override
  List<Object> get props => [
        items,
        recommendations,
        isRecommendationHide,
      ];
}

class CreatePlanState extends LoadedState {
  CreatePlanState(
    List<PlanItemModel> items,
    List<PlanItemModel> recommendations,
    bool isRecommendationHide,
  ) : super(
          items,
          recommendations,
          isRecommendationHide,
        );
}

class CreatingPlanState extends LoadedState {
  CreatingPlanState(
    List<PlanItemModel> items,
    List<PlanItemModel> recommendations,
    bool isRecommendationHide,
  ) : super(
          items,
          recommendations,
          isRecommendationHide,
        );
}

class CreatedPlanState extends LoadedState {
  CreatedPlanState(
    List<PlanItemModel> items,
    List<PlanItemModel> recommendations,
    bool isRecommendationHide,
  ) : super(
          items,
          recommendations,
          isRecommendationHide,
        );
}

class ActivityToPlanState extends PlansState {
  final bool isAdd;
  ActivityToPlanState(this.isAdd) : super();
  @override
  List<Object> get props => null;
}
