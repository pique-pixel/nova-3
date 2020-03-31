import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class Boundary {
  final Point southWestPoint;
  final Point northEastPoint;

  Boundary(this.southWestPoint, this.northEastPoint);
}

Boundary getBoundariesByPoints({
  Iterable<Point> points,
  double boundaryBorder = 0,
}) {
  assert(points != null);

  var southWestPoint = Point(latitude: 999, longitude: 999);
  var northEastPoint = Point(latitude: 0, longitude: 0);

  for (final geoObject in points) {
    if (southWestPoint.latitude > geoObject.latitude) {
      southWestPoint = Point(
        latitude: geoObject.latitude - boundaryBorder,
        longitude: southWestPoint.longitude - boundaryBorder,
      );
    }

    if (southWestPoint.longitude > geoObject.longitude) {
      southWestPoint = Point(
        latitude: southWestPoint.latitude - boundaryBorder,
        longitude: geoObject.longitude - boundaryBorder,
      );
    }

    if (northEastPoint.latitude < geoObject.latitude) {
      northEastPoint = Point(
        latitude: geoObject.latitude + boundaryBorder,
        longitude: northEastPoint.longitude + boundaryBorder,
      );
    }

    if (northEastPoint.longitude < geoObject.longitude) {
      northEastPoint = Point(
        latitude: northEastPoint.latitude + boundaryBorder,
        longitude: geoObject.longitude + boundaryBorder,
      );
    }
  }

  return Boundary(southWestPoint, northEastPoint);
}

//Future<void> getBoundariesByPoints({
//  Iterable<Point> points,
//  double boundaryBorder = 0.05,
//}) async {
//  assert(points != null);
//
//  final boundaryBorder = 0.05;
//
//  var southWestPoint = Point(latitude: 999, longitude: 999);
//  var northEastPoint = Point(latitude: 0, longitude: 0);
//
//  for (final geoObject in points) {
//    if (southWestPoint.latitude > geoObject.latitude) {
//      southWestPoint = Point(
//        latitude: geoObject.latitude - boundaryBorder,
//        longitude: southWestPoint.longitude - boundaryBorder,
//      );
//    }
//
//    if (southWestPoint.longitude > geoObject.longitude) {
//      southWestPoint = Point(
//        latitude: southWestPoint.latitude - boundaryBorder,
//        longitude: geoObject.longitude - boundaryBorder,
//      );
//    }
//
//    if (northEastPoint.latitude < geoObject.latitude) {
//      northEastPoint = Point(
//        latitude: geoObject.latitude + boundaryBorder,
//        longitude: northEastPoint.longitude + boundaryBorder,
//      );
//    }
//
//    if (northEastPoint.longitude < geoObject.longitude) {
//      northEastPoint = Point(
//        latitude: northEastPoint.latitude + boundaryBorder,
//        longitude: geoObject.longitude + boundaryBorder,
//      );
//    }
//  }
//
//  await yandexMapController.setBounds(
//    southWestPoint: southWestPoint,
//    northEastPoint: northEastPoint,
//    animation: animation
//        ? MapAnimation(
//            duration: animationDuration,
//            smooth: true,
//          )
//        : null,
//  );
//}

Future<Point> getCurrentGeoLocation() async {
  await PermissionHandler().requestPermissions(
    <PermissionGroup>[PermissionGroup.location],
  );

  final location = Location();
  final currentLocation = await location.getLocation();
  final srcPoint = Point(
    latitude: currentLocation.latitude,
    longitude: currentLocation.longitude,
  );

  return srcPoint;
}
