import 'package:rp_mobile/layers/bloc/favorites/favorite_models.dart';
import 'package:rp_mobile/layers/bloc/single_favorite_my_content_details/single_favorite_my_content_details_models.dart';

abstract class FavoriteService {
  Future<FavoriteModel> getFavoriteList();

  Future<FavoriteMyDetailModel> getFavoritDetailById(String id);

  Future<FavoriteModel> createNewFavoriteList(String request);

  Future<FavoriteForPlan> getFavoriteForPlanById(String ref);

  Future<void> createPlanFromFavorite(String name, List activities);

  Future<void> deleteFavoriteList(String id);

}
