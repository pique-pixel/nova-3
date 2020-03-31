import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:location/location.dart';
import 'package:optional/optional.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rp_mobile/containers/image.dart';
import 'package:rp_mobile/layers/bloc/routes/routes_bloc.dart';
import 'package:rp_mobile/layers/bloc/routes/routes_models.dart';
import 'package:rp_mobile/layers/drivers/api/gateway.dart';
import 'package:rp_mobile/layers/drivers/api/models.dart';
import 'package:rp_mobile/layers/services/geo_objects.dart';
import 'package:rp_mobile/layers/services/impl/favorite_service.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'package:rp_mobile/layers/services/plans_service.dart';
import 'package:rp_mobile/layers/services/impl/favorite_service.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'package:rp_mobile/utils/future.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class GeoObjectsServiceImpl implements GeoObjectsService {
  YandexMapController _yandexMapController;
  Function(String) _onPlaceMarkTapCallback;

  final GeoObjectDetails _yandexGeoPointResults = null;
  final List<GeoObjectDetails> _searchResultsDetails = <GeoObjectDetails>[];
  final PlansService _plansService;

  String _currentDay = '1';

  final ApiGateway _apiGateway;

  static final _geoObjectLocations = <Point>[
    Point(latitude: 55.690797, longitude: 37.561547),
    Point(latitude: 55.668132, longitude: 37.662215),
    Point(latitude: 55.728895, longitude: 37.600971),
    Point(latitude: 55.761287, longitude: 37.578628),
    Point(latitude: 55.756280, longitude: 37.617097),
    Point(latitude: 55.823328, longitude: 37.639855),
    Point(latitude: 55.756280, longitude: 37.617097),
    Point(latitude: 55.792181, longitude: 37.763279),
  ];

  static final _mockGeoObjects = <GeoObject>[
    GeoObject(
      ref: '0',
      title: 'Государственный Дарвиновский музей',
      latitude: _geoObjectLocations[0].latitude,
      longitude: _geoObjectLocations[0].longitude,
      pinIconUrl: Optional.of('images/mock_images/circle_0.png'),
      distance: Optional.of('~1.9 км'),
    ),
    GeoObject(
      ref: '1',
      title: 'Музей-заповедник "Коломенское"',
      latitude: _geoObjectLocations[1].latitude,
      longitude: _geoObjectLocations[1].longitude,
      pinIconUrl: Optional.of('images/mock_images/circle_1.png'),
      distance: Optional.of('~2.3 км'),
    ),
    GeoObject(
      ref: '2',
      title: 'Парк Горького',
      latitude: _geoObjectLocations[2].latitude,
      longitude: _geoObjectLocations[2].longitude,
      pinIconUrl: Optional.of('images/mock_images/circle_2.png'),
      distance: Optional.of('~3.0 км'),
//      pinIconUrl: Optional.of('https://webpop.github.io/jquery.pin/images/pin.png'),
    ),
    GeoObject(
      ref: '3',
      title: 'Московский зоопарк',
      latitude: _geoObjectLocations[3].latitude,
      longitude: _geoObjectLocations[3].longitude,
      pinIconUrl: Optional.of('images/mock_images/circle_3.png'),
      distance: Optional.of('~1.1 км'),
    ),
    GeoObject(
      ref: '4',
      title: 'Музей археологии Москвы',
      latitude: _geoObjectLocations[4].latitude,
      longitude: _geoObjectLocations[4].longitude,
      pinIconUrl: Optional.of('images/mock_images/circle_4.png'),
      distance: Optional.of('~2.8 км'),
    ),
    GeoObject(
      ref: '5',
      title: 'Музей Космонавтики',
      latitude: _geoObjectLocations[5].latitude,
      longitude: _geoObjectLocations[5].longitude,
      pinIconUrl: Optional.of('images/mock_images/circle_5.png'),
      distance: Optional.of('~4.2 км'),
    ),
    GeoObject(
      ref: '6',
      title: 'Музей сословий',
      latitude: _geoObjectLocations[6].latitude,
      longitude: _geoObjectLocations[6].longitude,
      pinIconUrl: Optional.of('images/mock_images/circle_6.png'),
      distance: Optional.of('~0.7 км'),
    ),
    GeoObject(
      ref: '7',
      title: 'Музей-усадьба Измайлово',
      latitude: _geoObjectLocations[7].latitude,
      longitude: _geoObjectLocations[7].longitude,
      pinIconUrl: Optional.of('images/mock_images/circle_7.png'),
      distance: Optional.of('~1.4 км'),
    ),
  ];

  static final _mockGeoObjectsDetails = <GeoObjectDetails>[
    GeoObjectDetails(
      ref: '0',
      title: _mockGeoObjects[0].title,
      openUntil: 'Открыто до 17:30',
      address: 'Вавилова, 57',
      latitude: _geoObjectLocations[0].latitude,
      longitude: _geoObjectLocations[0].longitude,
      image: Optional.of(ImageEither.asset('images/mock_images/geo_0.jpg')),
      distance: _mockGeoObjects[0].distance,
    ),
    GeoObjectDetails(
      ref: '1',
      title: _mockGeoObjects[1].title,
      openUntil: 'Открыто до 24:00',
      address: 'Пр. Андропова, 39',
      latitude: _geoObjectLocations[1].latitude,
      longitude: _geoObjectLocations[1].longitude,
      image: Optional.of(ImageEither.asset('images/mock_images/geo_1.jpg')),
      distance: _mockGeoObjects[1].distance,
    ),
    GeoObjectDetails(
      ref: '2',
      title: _mockGeoObjects[2].title,
      openUntil: 'Открыто круглосуточно',
      address: 'Крымский вал, 9',
      latitude: _geoObjectLocations[2].latitude,
      longitude: _geoObjectLocations[2].longitude,
      image: Optional.of(ImageEither.asset('images/mock_images/geo_2.jpg')),
      distance: _mockGeoObjects[2].distance,
    ),
    GeoObjectDetails(
      ref: '3',
      title: _mockGeoObjects[3].title,
      openUntil: 'Открыто до 16:30',
      address: 'Б. Грузинская, 1',
      latitude: _geoObjectLocations[3].latitude,
      longitude: _geoObjectLocations[3].longitude,
      image: Optional.of(ImageEither.asset('images/mock_images/geo_3.jpg')),
      distance: _mockGeoObjects[3].distance,
    ),
    GeoObjectDetails(
      ref: '4',
      title: _mockGeoObjects[4].title,
      openUntil: 'Открыто до 19:00',
      address: 'Манежная пл., 1а',
      latitude: _geoObjectLocations[4].latitude,
      longitude: _geoObjectLocations[4].longitude,
      image: Optional.of(ImageEither.asset('images/mock_images/geo_4.jpg')),
      distance: _mockGeoObjects[4].distance,
    ),
    GeoObjectDetails(
      ref: '5',
      title: _mockGeoObjects[5].title,
      openUntil: 'Открыто до 19:00',
      address: 'Пр. Мира, 111',
      latitude: _geoObjectLocations[5].latitude,
      longitude: _geoObjectLocations[5].longitude,
      image: Optional.of(ImageEither.asset('images/mock_images/geo_5.jpg')),
      distance: _mockGeoObjects[5].distance,
    ),
    GeoObjectDetails(
      ref: '6',
      title: _mockGeoObjects[6].title,
      openUntil: 'Открыто до 18:15',
      address: 'Манежная пл., 1а',
      latitude: _geoObjectLocations[6].latitude,
      longitude: _geoObjectLocations[6].longitude,
      image: Optional.of(ImageEither.asset('images/mock_images/geo_6.jpg')),
      distance: _mockGeoObjects[6].distance,
    ),
    GeoObjectDetails(
      ref: '7',
      title: _mockGeoObjects[7].title,
      openUntil: 'Открыто до 24:00',
      address: 'городок имени Баумана, 2с14',
      latitude: _geoObjectLocations[7].latitude,
      longitude: _geoObjectLocations[7].longitude,
      image: Optional.of(ImageEither.asset('images/mock_images/geo_7.jpg')),
      distance: _mockGeoObjects[7].distance,
    ),
  ];

  GeoObjectsServiceImpl(this._apiGateway, this._plansService);

  Future<void> setYandexMapController(YandexMapController controller) async {
    _yandexMapController = controller;

    await _requestPermissions();
    await _yandexMapController.showUserLayer(
      pinIconName: 'images/placemark.png', //'images/current_location.png',
      arrowIconName: 'images/placemark.png',
    );
  }

  Future<void> _requestPermissions() async {
    await PermissionHandler().requestPermissions(
      <PermissionGroup>[PermissionGroup.location],
    );
  }

  @override
  Future<GeoObjectDetails> getGeoObjectsDetails(String ref) async {
    await delay(2000);

    if (ref.startsWith('search:')) {
      final index = int.parse(ref.substring('search:'.length));
      _yandexMapController.move(
        point: _searchResultsDetails[index].point,
        zoom: 15.0,
      );
      return _searchResultsDetails[index];
    }

    final index = int.tryParse(ref);

    if (index == null || index >= _mockGeoObjectsDetails.length) {
      // TODO: Implement
      return null;
    } else {
      _yandexMapController.move(
        point: _mockGeoObjectsDetails[index].point,
        zoom: 15.0,
      );
      return _mockGeoObjectsDetails[index];
    }
  }

  @override
  Future<List<GeoObject>> getMapGeoObjects([String dayRef]) async {
    await delay(2000);
    await _requestPermissions();

    _currentDay = dayRef ?? '1';

    switch (_currentDay) {
      // All
      case '1':
        return _mockGeoObjects
            .where((it) =>
                ['0', '1', '2', '3', '4', '5', '6', '7'].contains(it.ref))
            .toList();
      // Today
      case '2':
        return _mockGeoObjects
            .where((it) => ['0', '1', '2', '3'].contains(it.ref))
            .toList();

      // Tomorrow
      case '3':
        return _mockGeoObjects
            .where((it) => ['4', '5', '6', '7'].contains(it.ref))
            .toList();

      default:
        throw UnsupportedError('Unknown dayRef: $dayRef');
    }
  }

  @override
  Future<List<Day>> getDays() async {
    return [
      Day(ref: '1', day: 'Москва за 3 дня'),
      Day(ref: '2', day: '25 дек'),
      Day(ref: '3', day: '26 дек'),
    ];
  }

  Future<SearchSuggestion> _searchSuggestionFromGeoObjectDetails(
    GeoObjectDetails details,
    Point userLocation,
  ) async {
    final distance = await _yandexMapController.getDistance(
      userLocation,
      details.point,
    );

    String distanceText;

    if (distance < 1000.0) {
      distanceText = '${distance.toStringAsFixed(1)} м';
    } else {
      distanceText = '${(distance / 1000.0).toStringAsFixed(1)} км';
    }

    return SearchSuggestion(
      ref: details.ref,
      name: details.title,
      address: details.address,
      image: details.image,
      distance: Optional.of(distanceText),
    );
  }

  @override
  Future<List<SearchSuggestion>> searchGeoObjects(String key) async {
    await _requestPermissions();

    final location = Location();
    final currentLocation = await location.getLocation();
    final userLocation = Point(
      latitude: currentLocation.latitude,
      longitude: currentLocation.longitude,
    );

    final searchSuggestions = <SearchSuggestion>[];

    if (key.isEmpty) {
      var details = <GeoObjectDetails>[];

      switch (_currentDay) {
        case '1':
          details = _mockGeoObjectsDetails
              .where((it) => ['0', '1', '2', '3'].contains(it.ref))
              .toList();
          break;

        case '2':
          details = _mockGeoObjectsDetails
              .where((it) => ['4', '5', '6', '7'].contains(it.ref))
              .toList();
          break;

        default:
          return [];
      }

      for (final detail in details) {
        searchSuggestions.add(
          await _searchSuggestionFromGeoObjectDetails(
            detail,
            userLocation,
          ),
        );
      }

      return searchSuggestions;
    }

    final results = await _yandexMapController.search(key);

    final geoDetails = _mockGeoObjectsDetails
        .where((it) =>
            it.address.toLowerCase().contains(key.toLowerCase()) ||
            it.title.toLowerCase().contains(key.toLowerCase()))
        .toList();

    for (final detail in geoDetails) {
      searchSuggestions.add(
        await _searchSuggestionFromGeoObjectDetails(
          detail,
          userLocation,
        ),
      );
    }

    int i = 0;
    _searchResultsDetails.clear();

    for (final result in results) {
      if (result.description == null) {
        continue;
      }

      if (result.latitude == null || result.longitude == null) {
        continue;
      }

      final details = GeoObjectDetails(
        ref: 'search:$i',
        title: result.name,
        openUntil: '',
        address: result.description,
        latitude: result.latitude,
        longitude: result.longitude,
      );

      _searchResultsDetails.add(details);
      searchSuggestions.add(
        await _searchSuggestionFromGeoObjectDetails(
          details,
          userLocation,
        ),
      );

      i += 1;
    }

    return searchSuggestions;
  }

  Future<void> _boundByPoints(Point srcPoint, Point destPoint) async {
    final boundaryBorder = 0.005;

    await _yandexMapController.setBounds(
      southWestPoint: Point(
        latitude:
            math.min(srcPoint.latitude, destPoint.latitude) - boundaryBorder,
        longitude:
            math.min(srcPoint.longitude, destPoint.longitude) - boundaryBorder,
      ),
      northEastPoint: Point(
        latitude:
            math.max(srcPoint.latitude, destPoint.latitude) + boundaryBorder,
        longitude:
            math.max(srcPoint.longitude, destPoint.longitude) + boundaryBorder,
      ),
    );
  }

  @override
  Future<RouteInfo> buildMasstransitRoute(
      Point srcPoint, Point destPoint) async {
    assert(_yandexMapController != null);

    final info = await _yandexMapController.requestMasstransitRoute(
      src: srcPoint,
      dest: destPoint,
    );

    await _boundByPoints(srcPoint, destPoint);
    return info;
  }

  Future<void> buildPedestrianRoute(Point srcPoint, Point destPoint) async {
    assert(_yandexMapController != null);
    await _yandexMapController.requestPedestrianRoute(
      src: srcPoint,
      dest: destPoint,
    );

    await _boundByPoints(srcPoint, destPoint);
  }

  Future<void> buildBicycleRoute(Point srcPoint, Point destPoint) async {
    assert(_yandexMapController != null);
    await _yandexMapController.requestBicycleRoute(
      src: srcPoint,
      dest: destPoint,
    );

    await _boundByPoints(srcPoint, destPoint);
  }

  @override
  Future<void> buildDrivingRoute(Point srcPoint, Point destPoint) async {
    assert(_yandexMapController != null);
    await _yandexMapController.requestDrivingRoute(
      src: srcPoint,
      dest: destPoint,
    );

    await _boundByPoints(srcPoint, destPoint);
  }

  @override
  Future<Map<RouteType, String>> estimateRoutes(
    Point srcPoint,
    Point destPoint,
  ) async {
    return {
      RouteType.masstransit: await _yandexMapController
          .estimateMasstransitRoute(src: srcPoint, dest: destPoint),
      RouteType.pedestrian: await _yandexMapController.estimatePedestrianRoute(
          src: srcPoint, dest: destPoint),
      RouteType.bicycle: await _yandexMapController.estimateBicycleRoute(
          src: srcPoint, dest: destPoint),
      RouteType.driving: await _yandexMapController.estimateDrivingRoute(
          src: srcPoint, dest: destPoint),
    };
  }

  @override
  Future<Point> getCurrentGeoLocation() async {
    await _requestPermissions();

    final location = Location();
    final currentLocation = await location.getLocation();
    final srcPoint = Point(
      latitude: currentLocation.latitude,
      longitude: currentLocation.longitude,
    );

    debugPrint('point is $srcPoint');
    return srcPoint;
  }

  Future<void> _moveBoundaries(
      Iterable<GeoObject> geoObjects, bool animation) async {
    animation = false;

    if (_yandexMapController == null) {
      return;
    }

    final boundaryBorder = 0.05;

    var southWestPoint = Point(latitude: 999, longitude: 999);
    var northEastPoint = Point(latitude: 0, longitude: 0);

    for (final geoObject in geoObjects) {
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

      final point = Point(
        latitude: geoObject.latitude,
        longitude: geoObject.longitude,
      );

      final onTap = (lat, lng) async {
        if (_onPlaceMarkTapCallback != null) {
          _onPlaceMarkTapCallback(geoObject.ref);
        }

        await _yandexMapController.move(
          point: point,
          zoom: 15.0,
          animation: MapAnimation(
            duration: 0.8,
            smooth: true,
          ),
        );
      };

      if (geoObject.pinIconUrl.isPresent) {
        //final response = await http.get(geoObject.pinIconUrl.value);
        final ByteData bytes =
            await rootBundle.load(geoObject.pinIconUrl.value);
        final Uint8List image = bytes.buffer.asUint8List();
        await _yandexMapController.addPlacemark(
          Placemark(
            point: point,
            onTap: onTap,
            rawImageData: image, //response.bodyBytes, //image
            opacity: 1.0,
          ),
        );
      } else {
        await _yandexMapController.addPlacemark(
          Placemark(
            point: point,
            onTap: onTap,
            iconName: 'images/placemark.png',
            opacity: 1.0,
          ),
        );
      }
    }

    await _yandexMapController.setBounds(
      southWestPoint: southWestPoint,
      northEastPoint: northEastPoint,
      animation: animation ? MapAnimation(duration: 2, smooth: true) : null,
    );
  }

  Future<void> setOnPlaceMarkTap(Function(String) callback) async {
    _onPlaceMarkTapCallback = callback;
  }

  @override
  Future<void> moveCameraToBoundary(
    Iterable<GeoObject> geoObjects,
    bool animation,
  ) async {
    await _moveBoundaries(geoObjects, animation);
  }

  @override
  Future<void> clearRoutes() async {
    assert(_yandexMapController != null);
    await _yandexMapController.clearRoutes();
  }
}
