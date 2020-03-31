import 'package:rp_mobile/layers/bloc/routes/bloc.dart';
import 'package:rp_mobile/layers/bloc/routes/routes_models.dart';
import 'package:rp_mobile/layers/drivers/api/models.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

abstract class GeoObjectsService {
  // NOTE(Andrey): If not found or dayRef is not presented
  //   will select the default day
  Future<List<GeoObject>> getMapGeoObjects([String dayRef]);

  Future<List<Day>> getDays();

  Future<GeoObjectDetails> getGeoObjectsDetails(String ref);

  Future<List<SearchSuggestion>> searchGeoObjects(String key);

  Future<Point> getCurrentGeoLocation();

  Future<RouteInfo> buildMasstransitRoute(Point srcPoint, Point destPoint);

  Future<void> buildPedestrianRoute(Point srcPoint, Point destPoint);

  Future<void> buildBicycleRoute(Point srcPoint, Point destPoint);

  Future<void> buildDrivingRoute(Point srcPoint, Point destPoint);

  Future<Map<RouteType, String>> estimateRoutes(
    Point srcPoint,
    Point destPoint,
  );

  Future<void> setYandexMapController(YandexMapController controller);

  Future<void> setOnPlaceMarkTap(Function(String) callback);

  Future<void> moveCameraToBoundary(
    Iterable<GeoObject> geoObjects,
    bool animation,
  );

  Future<void> clearRoutes();
}
