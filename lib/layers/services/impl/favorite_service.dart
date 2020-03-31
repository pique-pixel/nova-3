import 'package:rp_mobile/layers/adapters/ui_models_factory.dart';
import 'package:rp_mobile/layers/bloc/favorites/favorite_models.dart';
import 'package:rp_mobile/layers/bloc/single_favorite_my_content_details/single_favorite_my_content_details_models.dart';
import 'package:rp_mobile/layers/drivers/api/gateway.dart';
import 'package:rp_mobile/layers/drivers/api/models.dart';
import 'package:rp_mobile/layers/services/favorite_services.dart';
import 'package:rp_mobile/layers/services/session.dart';

class FavoriteServiceImpl implements FavoriteService {
  final ApiGateway _apiGateway;
  final UiModelsFactory _uiModelsFactory;
  final SessionService _sessionService;

  FavoriteServiceImpl(
      this._apiGateway, this._uiModelsFactory, this._sessionService);

  @override
  Future<FavoriteModel> getFavoriteList() =>
      _sessionService.refreshSessionOnUnauthorized(() async {
        final response = await _apiGateway.getFavoriteList();

        return _uiModelsFactory.createFavorite(response);
      });

  @override
  Future<FavoriteMyDetailModel> getFavoritDetailById(String id) =>
      _sessionService.refreshSessionOnUnauthorized(() async {
        final response = await _apiGateway.getFavoritDetailById(id);

        return _uiModelsFactory.createFavoriteDetailById(response);
      });

  @override
  Future<FavoriteModel> createNewFavoriteList(String listName) =>
      _sessionService.refreshSessionOnUnauthorized(() async {
        final request = FavoriteListRequest(listName);
        final response = await _apiGateway.createNewFavoriteList(request);

        return _uiModelsFactory.createFavorite(response);
      });

  @override
  Future<FavoriteForPlan> getFavoriteForPlanById(String ref)=>
      _sessionService.refreshSessionOnUnauthorized(() async{
        final response = await _apiGateway.getFavoriteForPlanById(ref);

        return _uiModelsFactory.createFavoriteForPlanById(response);
      });

  @override
  Future<void>createPlanFromFavorite(String name, List activities) =>
      _sessionService.refreshSessionOnUnauthorized(() async{
        final response =
        await _apiGateway.createPlanFromFavorite(name, activities);
        print(response);
      });

  @override
  Future<void> deleteFavoriteList(String id) =>
      _sessionService.refreshSessionOnUnauthorized(() async {
        final response = await _apiGateway.deleteFavoriteList(id);
        print(response);
      });

}
