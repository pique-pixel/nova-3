import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:optional/optional_internal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rp_mobile/containers/page.dart';
import 'package:rp_mobile/layers/adapters/ui_models_factory.dart';
import 'package:rp_mobile/layers/bloc/plan_details/plan_details_bloc.dart';
import 'package:rp_mobile/layers/bloc/plan_details/plan_models.dart';
import 'package:rp_mobile/layers/bloc/plans/plans_models.dart';
import 'package:rp_mobile/layers/drivers/api/gateway.dart';
import 'package:rp_mobile/layers/drivers/api/models.dart';
import 'package:rp_mobile/layers/drivers/geo.dart';
import 'package:rp_mobile/layers/services/plans_service.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'package:rp_mobile/locale/localized_string.dart';
import 'package:rp_mobile/utils/future.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class PlansServiceImpl implements PlansService {
  final ApiGateway _apiGateway;
  final UiModelsFactory _uiModelsFactory;
  final SessionService _sessionService;
  final geoObjects = <String, Point>{};
  final geoObjectsForDay = <String, Point>{};
  final MapAnimation _mapAnimation = MapAnimation(smooth: true, duration: 1.5);
  final double _boundaryBorder = 0.04;
  Map<String, dynamic> currentDetailsRow;
  PlanDetailedViewResponse currentDetails;
  PlanDetails currentDetailsUI;
  YandexMapController _yandexMapController;
  void Function(String spotRef) _onTapOnMark;

  PlansServiceImpl(
    this._apiGateway,
    this._uiModelsFactory,
    this._sessionService,
  );

  @override
  Future<PlanDetails> getPlanDetails(String ref, Optional<String> dateRef) =>
      _sessionService.refreshSessionOnUnauthorized(() async {
        final re = await _apiGateway.getPlanDetails(ref);
        PlanDetailedViewResponse details = re.planDetailedViewResponse;
        currentDetailsRow = re.response;
        geoObjects.clear();
        geoObjectsForDay.clear();

        if (dateRef.isPresent) {
          print('Data est');
          final day = details.days.firstWhere((t) => t.date == dateRef.value);
          for (final activity in day.activities) {
            if (activity.activity.type == 'RESTAURANT') {
              if (activity.activity.activity.item.coordinates.isPresent) {
                geoObjectsForDay[activity.activity.id] = Point(
                  latitude:
                  activity.activity.activity.item.coordinates.value.lat,
                  longitude:
                  activity.activity.activity.item.coordinates.value.lng,
                );
              }
              continue;
            }
            final places = activity.activity.activity.places;
            if (activity.activity.type == 'EVENT') {
              if (!places.isPresent) {
                continue;
              }
              for (final place in places.value) {
                geoObjectsForDay[activity.activity.id] = Point(
                  latitude: place.coordinates.lat,
                  longitude: place.coordinates.lng,
                );
              }
            }
          }
        } else {
          for (final activity in details.activities) {
            if (activity.type == 'RESTAURANT') {
              if (activity.activity.item.coordinates.isPresent) {
                geoObjects[activity.id] = Point(
                  latitude: activity.activity.item.coordinates.value.lat,
                  longitude: activity.activity.item.coordinates.value.lng,
                );
              }
              continue;
            }
            final places = activity.activity.places;

            if (!places.isPresent) {
              continue;
            }

            for (final place in places.value) {
              geoObjects[activity.id] = Point(
                latitude: place.coordinates.lat,
                longitude: place.coordinates.lng,
              );
            }
          }
        }

        currentDetailsUI = _uiModelsFactory.createPlanDetails(details, dateRef);
        return currentDetailsUI;
      });

  @override
  Future<Page<PlanItemModel>> getPlans([int page = 1]) =>
      _sessionService.refreshSessionOnUnauthorized(() async {
        final response = await _apiGateway.getMyActivePlansLite();
        return _uiModelsFactory.createPlansPage(response);
      });

  Future<List<PlanItemModel>> getRecommendations() async {
    return [];
  }

  Future<bool> isRecommendationHide() async {
    return false;
  }

  @override
  Future<PlanItemModel> createPlan(String name) =>
      _sessionService.refreshSessionOnUnauthorized(
            () async {
          final createPlanResponse = await _apiGateway.createPlan(name);

          return PlanItemModel(
            ref: createPlanResponse.id,
            thumbnail: Optional.empty(),
            title: LocalizedString.fromString(name),
            subTitle: LocalizedString.fromString('Список поездок пуст'),
          );
        },
      );

  @override
  Future<bool> deletePlan(String id) =>
      _sessionService.refreshSessionOnUnauthorized(
            () async {
          final bool response = await _apiGateway.deletePlan(id);
          return response;
        },
      );

  @override
  Future<bool> deleteActivity(String planId,
      String activityId, {
        void Function(bool b) isLastInDay,
      }) =>
      _sessionService.refreshSessionOnUnauthorized(
            () async {
          print('Here ------- planId: $planId activityId: $activityId');
          Map<String, dynamic> updatedData = currentDetailsRow;

          print(_prepareData(updatedData));
          updatedData = _removeActivityFromDay(
            updatedData,
            activityId,
            printRemovedActivityTitle: true,
            isLastInDay: isLastInDay,
          );

          updatedData = _prepareData(updatedData);
          print(updatedData);

          final isUpdatedFine = await _apiGateway.updatePlan(updatedData);
          return isUpdatedFine;
        },
      );

  @override
  Future<bool> assignActivityDate(String planId,
      String activityId,
      String date, {
        void Function(bool b) isLastInDay,
      }) =>
      _sessionService.refreshSessionOnUnauthorized(
            () async {
          print('Here ------- planId: $planId activityId: $activityId');
          Map<String, dynamic> updatedData = currentDetailsRow;
          print('Initial data to send');
          print(_prepareData(updatedData));
          updatedData = _removeActivityFromDay(
            updatedData,
            activityId,
            isLastInDay: isLastInDay,
          );
          updatedData = _assignActivityToDay(
            updatedData,
            activityId,
            date,
            printAddedActivityTitle: true,
          );

          updatedData = _prepareData(updatedData);
          print('Final data sned');
          print(updatedData);
          final isUpdatedFine = await _apiGateway.updatePlan(updatedData);
          return isUpdatedFine;
        },
      );

  Map<String, dynamic> _prepareData(Map<String, dynamic> updatedData) {
    return {
      "plans": [
        {
          'id': updatedData['id'],
          'name': updatedData['name'],
          'startDate': updatedData['startDate'],
          'endDate': updatedData['endDate'],
          'level': updatedData['level'],
          'airlineTickets': [],
          'railwayTickets': [],
          'hotels': [],
          'days': _prepareListDaysData(updatedData['days']),
          'activities': _prepareListActivitiesData(updatedData['activities']),
        }
      ]
    };
  }

  List<Map<String, dynamic>> _prepareListActivitiesData(activities) {
    return [
      for (var i = 0; i < activities.length; ++i)
        {
          'id': activities[i]['id'],
          'type': activities[i]['type'],
        },
    ];
  }

  List<Map<String, dynamic>> _prepareListDaysData(days) {
    return [
      for (var i = 0; i < days.length; ++i)
        {
          'date': days[i]['date'],
          'activities': _prepareActivitiesWithOrder(days[i]['activities']),
        },
    ];
  }

  List<Map<String, dynamic>> _prepareActivitiesWithOrder(List activities) {
    return [
      for (var i = 0; i < activities.length; ++i)
        {
          'order': activities[i]['order'],
          'activity': {
            'id': activities[i]['activity']['id'],
            'type': activities[i]['activity']['type'],
          },
        },
    ];
  }

  void _printAllTitles(Map<String, dynamic> tmp) {
    List list = (tmp['activities'] as List);
    print('\n---------------');
    for (var i = 0; i < list.length; ++i) {
      print('*-$i-* ' + list[i]['activity']['item']['title']);
    }
    print('---------------');
  }

  Map<String, dynamic> _removeActivityFromDay(Map<String, dynamic> tmp,
      String activityId, {
        bool printRemovedActivityTitle = false,
        void Function(bool isLast) isLastInDay,
      }) {
    bool isActivityExistInDays = false;
    bool isNeedToDeleteWholeDay = false;
    int dayIndex;
    int activityIndex;
    for (var i = 0; i < tmp['days'].length; ++i) {
      var day = tmp['days'][i];
      for (var j = 0; j < day['activities'].length; ++j) {
        var activity = day['activities'][j];
        if (activity['activity']['id'] == activityId) {
          isActivityExistInDays = true;
          isNeedToDeleteWholeDay = day['activities'].length == 1;
          dayIndex = i;
          activityIndex = j;
          print(
              'isActivityExistInDays $isActivityExistInDays isNeedToDeleteWholeDay: $isNeedToDeleteWholeDay ${day['activities']
                  .length}');
        }
      }
    }

    if (isNeedToDeleteWholeDay && isActivityExistInDays) {
      var rm = (tmp['days'] as List).removeAt(dayIndex);
      if (printRemovedActivityTitle && rm != null) {
        isLastInDay(true);
        print('Removed day: ');
        print(rm);
      }
    }

    if (!isNeedToDeleteWholeDay && isActivityExistInDays) {
      var rm = ((tmp['days'] as List)[dayIndex]['activities'] as List)
          .removeAt(activityIndex);
      if (printRemovedActivityTitle && rm != null) {
        print('Removed activity:');
        print(rm);
      }
    }
    if (!isActivityExistInDays) {
      print('---- Not in the days so should be deleted out of trip-plan ----');
    }

    return tmp;
  }

  Map<String, dynamic> _assignActivityToDay(Map<String, dynamic> tmp,
      String activityId,
      String date, {
        bool printAddedActivityTitle = false,
      }) {
    Map<String, dynamic> updated = tmp;
    Map<String, dynamic> activityWithType =
    _takeActivityFromActivities(updated, activityId);
    int indexDay = _isDayExistAndIndex(updated, date);

    tmp = _removeActivityFromDay(tmp, activityId);

    if (indexDay >= 0) {
      (updated['days'] as List)[indexDay]['activities'].add(
        {
          'order': ((updated['days'] as List)[indexDay]['activities'] as List)
              .length,
          'activity': activityWithType
        },
      );
    } else {
      (updated['days'] as List).add(
        {
          'date': '$date',
          "activities": [
            {
              'order': 0,
              'activity': activityWithType,
            },
          ],
        },
      );
    }

    if (printAddedActivityTitle) {
      print('Added to day $date: ' +
          activityWithType['activity']['item']['title']);
    }

    return updated;
  }

  Map<String, dynamic> _takeActivityFromActivities(Map<String, dynamic> tmp,
      String activityId) {
    Map<String, dynamic> activityWithType = (tmp['activities'] as List)
        .firstWhere((t) => t['id'] == activityId, orElse: () => null);
    if (activityWithType == null) {
      throw Exception('no activity with id $activityId in activities array');
    }
    return activityWithType;
  }

  int _isDayExistAndIndex(Map<String, dynamic> tmp, String date) {
    List daysList = tmp['days'] as List;
    return daysList.indexWhere((t) => t['date'] == date);
  }

  @override
  Future<void> setupMap(YandexMapController controller,
      void Function(String spotRef) onTapOnMark,) async {
    final Boundary boundary = getBoundariesByPoints2(
      points: geoObjects.values,
      boundaryBorder: _boundaryBorder,
    );

    _yandexMapController = controller;
    _onTapOnMark = onTapOnMark;
    await _yandexMapController.setBounds(
      southWestPoint: boundary.southWestPoint,
      northEastPoint: boundary.northEastPoint,
      animation: _mapAnimation,
    );
    await _requestPermissions();
    await _yandexMapController.showUserLayer(
      pinIconName: 'images/current_location.png',
      arrowIconName: 'images/current_location.png',
    );
    _yandexMapController.placemarks.clear();
    for (final ref in geoObjects.keys) {
      final point = geoObjects[ref];
      await _yandexMapController.addPlacemark(
        Placemark(
          point: point,
          iconName: 'images/placemark.png',
          opacity: 1.0,
          onTap: (double latitude, double longitude) async {
            onTapOnMark(ref);
          },
        ),
      );
    }
  }

  Future<void> _requestPermissions() async {
    await PermissionHandler().requestPermissions(
      <PermissionGroup>[PermissionGroup.location],
    );
  }

  @override
  Future<PlanDetails> updatePlanDetailsName(String ref, String name) async {
    await delay(1000);

    currentDetailsUI = currentDetailsUI.copyWith(
      header: currentDetailsUI.header.copyWith(
        title: LocalizedString.fromString(name),
      ),
    );
    return currentDetailsUI;
  }

  @override
  Future<void> moveToPlace(Spot data) async {
    if (geoObjects.containsKey(data.ref)) {
      _yandexMapController.move(
        point: geoObjects[data.ref],
        animation: _mapAnimation,
      );
    } else {
      print("Просто костыль, что бы хоть кауюто метку показывать");
      print('Нету кординат у этой активности');
    }
    return null;
  }

  @override
  Future<void> showAllPoints() async {
    if (_yandexMapController == null) {
      return null;
    }
    await _yandexMapController.clearRoutes();
    _yandexMapController.placemarks.clear();
//    for (var i = 0; i < geoObjects.length; ++i) {
//      var o = geoObjects[i];
//      await _yandexMapController.
//    }

    Map<String, Point> gObjects = {};
    if (geoObjectsForDay.length > 0) {
      gObjects = geoObjectsForDay;
    } else {
      gObjects = geoObjects;
    }
    for (final ref in gObjects.keys) {
      final point = gObjects[ref];
      await _yandexMapController.addPlacemark(
        Placemark(
          point: point,
          iconName: 'images/placemark.png',
          opacity: 1.0,
          onTap: (double latitude, double longitude) async {
            _onTapOnMark(ref);
          },
        ),
      );
    }
    final Boundary boundary = getBoundariesByPoints2(
      points: gObjects.values,
      boundaryBorder: _boundaryBorder,
    );

    await _yandexMapController.setBounds(
      southWestPoint: boundary.southWestPoint,
      northEastPoint: boundary.northEastPoint,
      animation: _mapAnimation,
    );
  }

  Boundary getBoundariesByPoints2({
    @required Iterable<Point> points,
    @required double boundaryBorder,
  }) {
    Point southWestPoint;
    Point northEastPoint;
    if (points.length == 0) {
      Point southWestPoint = Point(latitude: 999, longitude: 999);

      Point northEastPoint = Point(latitude: 0, longitude: 0);
      return Boundary(southWestPoint, northEastPoint);
    }

    points = points.toList();
    List<double> latList = [];
    List<double> latListSorted = [];
    List<double> lonList = [];
    List<double> lonListSorted = [];
    for (var i = 0; i < points
        .toList()
        .length; ++i) {
      var o = points.toList()[i];
      latList.add(o.latitude);
      lonList.add(o.longitude);
    }
    latListSorted = latList..sort();
    lonListSorted = lonList..sort();
    double boundaryBorderLat = 0;
    double boundaryBorderLog = 0;
    if (lonListSorted.last - lonListSorted.first >
        latListSorted.last - latListSorted.first) {
//      print('long is greater');
      boundaryBorderLog = boundaryBorder;
      boundaryBorderLat = boundaryBorder / 3;
    } else {
//      print('lat is greater');
      boundaryBorderLog = boundaryBorder / 3;
      boundaryBorderLat = boundaryBorder;
    }
    northEastPoint = Point(
      latitude: latListSorted.last + boundaryBorderLat,
      longitude: lonListSorted.last + boundaryBorderLog,
    );
    southWestPoint = Point(
      latitude: latListSorted.first - boundaryBorderLat,
      longitude: lonListSorted.first - boundaryBorderLog,
    );

    Boundary boundary = Boundary(southWestPoint, northEastPoint);
    return boundary;
  }

  @override
  Future<void> showMyLocation() async {
    Point myLocation = await getCurrentGeoLocation();
    await _yandexMapController.move(
      point: myLocation,
      animation: _mapAnimation,
    );
  }

  @override
  Point getPointByRef(String ref) {
    if (geoObjectsForDay.containsKey(ref)) {
      return Point(
        latitude: geoObjectsForDay[ref].latitude,
        longitude: geoObjectsForDay[ref].longitude,
      );
    } else if (geoObjects.containsKey(ref)) {
      return Point(
        latitude: geoObjects[ref].latitude,
        longitude: geoObjects[ref].longitude,
      );
    }

    return null;
  }

  @override
  Future<Map<RouteTypes, String>> estimateRoutes({
    Point srcPoint,
    Point destPoint,
  }) async {
    print('destPoint ${destPoint.longitude} ${destPoint.latitude}');
    if (srcPoint == null) {
      throw Exception('srcPoint should not be null!');
    }
    if (destPoint == null) {
      throw Exception('destPoint should not be null!');
    }
    return {
      RouteTypes.masstransit: await _yandexMapController
          .estimateMasstransitRoute(src: srcPoint, dest: destPoint),
      RouteTypes.pedestrian: await _yandexMapController.estimatePedestrianRoute(
          src: srcPoint, dest: destPoint),
      RouteTypes.bicycle: await _yandexMapController.estimateBicycleRoute(
          src: srcPoint, dest: destPoint),
      RouteTypes.driving: await _yandexMapController.estimateDrivingRoute(
          src: srcPoint, dest: destPoint),
    };
  }

  @override
  Future<RouteInfo> buildMasstransitRoute(Point srcPoint,
      Point destPoint) async {
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

  _boundByPoints(Point srcPoint, Point destPoint) async {
    final Boundary boundary = getBoundariesByPoints(
      points: [srcPoint, destPoint],
      boundaryBorder: 0.005,
    );

    await _yandexMapController.setBounds(
      southWestPoint: boundary.southWestPoint,
      northEastPoint: boundary.northEastPoint,
      animation: _mapAnimation,
    );
  }

  @override
  Future<void> clearRoutes() async {
    assert(_yandexMapController != null);
    await _yandexMapController.clearRoutes();
  }

  @override
  Future<bool> addActivityToPlan(String name, String activityId, String type) async {
    _sessionService.refreshSessionOnUnauthorized(() async {
        print('addActivity ------- planId: $name activityId: $activityId type: $type');
        final bool response =
        await _apiGateway.addActivityToPlan(name, activityId, type);
        return response;
      },
    );
  }
}
