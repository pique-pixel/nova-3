// @formatter:off

import 'package:optional/optional.dart';
import 'package:rp_mobile/exceptions.dart';
import 'package:rp_mobile/locale/localized_string.dart';
import 'package:rp_mobile/utils/exceptions.dart';
import 'package:rp_mobile/utils/json.dart';
import 'package:json_models_generator/annotations.dart';

part 'models.g.dart';

const availableDaysOfWeek = <String>{
  'MONDAY',
  'TUESDAY',
  'WEDNESDAY',
  'THURSDAY',
  'FRIDAY',
  'SATURDAY',
  'SUNDAY',
};

class TokenRequest {
  final String clientId;
  final String scope;
  final String secret;
  final String username;
  final String password;
  final String grantType;

  TokenRequest({
    this.clientId,
    this.scope,
    this.secret,
    this.username,
    this.password,
    this.grantType,
  }) {
    require(clientId != null, () => SchemeConsistencyException());
    require(scope != null, () => SchemeConsistencyException());
    require(secret != null, () => SchemeConsistencyException());
    require(username != null, () => SchemeConsistencyException());
    require(password != null, () => SchemeConsistencyException());
    require(grantType != null, () => SchemeConsistencyException());
  }

  String toWWWFormUrlencoded() {
    return 'client_id=$clientId&scope=$scope&secret=$secret&'
        'username=$username&password=$password&grant_type=$grantType';
  }
}

class FavoriteListRequest {
  final String listName;

  FavoriteListRequest(this.listName) {
    require(listName != null, () => SchemeConsistencyException());
  }

  Map<String, dynamic> createRequestBody() {
    return {
      "my": [
        {"name": "$listName", "activities": []}
      ],
      "tourPackages": [],
      "tours": []
    };
  }
}

//TODO нужно ли делать так, или как сделано в gateway_impl.dart createPlanFromFavorite
//class PlanFromFavoriteRequest {
//  final String name;
//  final List activities;
//
//  PlanFromFavoriteRequest(this.name, this.activities) {
//    require(name != null, () => SchemeConsistencyException());
//    require(activities != null, () => SchemeConsistencyException());
//  }
//
//  Map<String, dynamic> createRequestBody() {
//    return {
//      "plans": [
//        {
//          "name": "$name",
//          "level": "",
//          "airlineTickets": [{}],
//          "railwayTickets": [{}],
//          "hotels": [{}],
//          "days": [],
//          "activities": activities.map((it) {
//            return {
//              "id": it.id,
//              "type": it.type,
//            };
//          }).toList()
//        }
//      ]
//    };
//  }
//}

@JsonResponse()
class TokenResponseScheme {
  String access_token;
  String token_type;
  String refresh_token;
  int expires_in;
  String scope;
  List<ScopeResponseScheme> role;
}

@JsonResponse()
class ScopeResponseScheme {
  String authority;
}

@JsonResponse()
class TicketsListResponseScheme {
  bool last;
  int number;
  List<TicketsListContentResponseScheme> content;
}

@JsonResponse()
class TicketsListContentResponseScheme {
  Optional<String> qr;
  List<TicketsListContentItemResponseScheme> items;
}

@JsonResponse()
class TicketsListContentItemResponseScheme {
  int id;
  TicketsListContentItemItemResponseScheme item;
}

@JsonResponse()
class TicketsListContentItemItemResponseScheme {
  String externalId;
  Optional<OfferContentResponseScheme> offerContent;
}

@JsonResponse()
class OfferContentResponseScheme {
  String id;
  TranslatableStringResponseScheme name;
  PhotoResponseScheme photo;
}

@JsonResponse()
class PhotoResponseScheme {
  String url;
  Optional<String> description;
}

@JsonResponse()
class TranslatableStringResponseScheme {
  List<LocalizedStringItemResponseScheme> inOtherLang;
  String value;
}

extension Localize on TranslatableStringResponse {
  LocalizedString toLocalizedString() {
    return LocalizedString.fromString(value);
  }
}

@JsonResponse()
class LocalizedStringItemResponseScheme {
  String value;
  String language;
}

@JsonResponse()
class OfferResponseScheme {
  TranslatableStringResponseScheme fullName;
  PlaceResponseScheme place;
  List<TagResponseScheme> tags;
  TranslatableStringResponseScheme description;
  int durationMin;
  List<OfferScheduleResponseScheme> schedules;
  List<BasePriceResponseScheme> prices;
}

@JsonResponse()
class PlaceResponseScheme {
  String url;
  LocationResponseScheme location;
  TranslatableStringResponseScheme address;
  PhotoResponseScheme headerPhoto;

  bool forSedentary;
  bool forVisually;
  bool forHearing;
  bool forMental;
}

@JsonResponse()
class TagResponseScheme {
  TranslatableStringResponseScheme name;
}

@JsonResponse()
class LocationResponseScheme {
  double x;
  double y;
}

@JsonResponse()
class OfferScheduleResponseScheme {
  TranslatableStringResponseScheme name;
  List<int> fromDate;
  List<int> toDate;
  List<OfferScheduleDetailsResponseScheme> details;
  List<OfferScheduleExcludeResponseScheme> excludes;
  List<OfferAdditionalInfoResponseScheme> additionalInfos;

  static validate(OfferScheduleResponse response) {
    require(response.fromDate.length == 3, () => SchemeConsistencyException('fromDate.length != 3'));
    require(response.toDate.length == 3, () => SchemeConsistencyException('toDate.length != 3'));
  }
}

class EnumDayOfWeek {
  static const acceptable = <String>{
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  };
}

@JsonResponse()
class OfferScheduleDetailsResponseScheme {
  List<int> fromTime;
  List<int> toTime;
  List<EnumDayOfWeek> dayOfWeeks;

  static void validate(OfferScheduleDetailsResponse response) {
    require(response.fromTime.length >= 2, () => SchemeConsistencyException('fromTime.length < 2'));
    require(response.toTime.length >= 2, () => SchemeConsistencyException('toTime.length < 2'));
  }
}

@JsonResponse()
class OfferScheduleExcludeResponseScheme {
  String date;
  List<EnumDayOfWeek> dayOfWeeks;
}

@JsonResponse()
class OfferAdditionalInfoResponseScheme {
  TranslatableStringResponseScheme name;
}

class EnumTariffType {
  static const acceptable = <String>{
    'CHILD',
    'ADULT',
  };
}

@JsonResponse()
class BasePriceResponseScheme {
  String currency;
  EnumTariffType type;
  double value;
}

@JsonResponse()
class PlanViewLiteResponseScheme {
  String id;
  String name;
  int contentCount;
  Optional<String> startDate;
  Optional<String> endDate;
  List<ImageMetaResponseScheme> images;
}

@JsonResponse()
class ImageMetaResponseScheme {
  String url;
  Optional<String> description;
}

@JsonResponse()
class PlanDetailedViewResponseScheme {
  String id;
  String name;
  Optional<String> startDate;
  Optional<String> endDate;
  List<PlanDayDetailedViewResponseScheme> days;
  List<PlanEntityViewResponseScheme> activities;
}

@JsonResponse()
class PlanDayDetailedViewResponseScheme {
  String date;
  List<PlanDayEntityViewResponseScheme> activities;
}

@JsonResponse()
class PlanDayEntityViewResponseScheme {
  int order;
  PlanEntityViewResponseScheme activity;
}

@JsonResponse()
class PlanEntityViewResponseScheme {
  String id;
  String type;
  CmsResponseResponseScheme activity;
}

@JsonResponse()
class CmsResponseResponseScheme {
  CmsResponseItemResponseScheme item;

  // TODO(Andrey): Свериться с документацией, в доке пока нету описания этой модели
  Optional<List<CmsResponsePlaceResponseScheme>> places;
}

@JsonResponse()
class CmsResponseItemResponseScheme {
  String id;
  String title;
  String description;
  Optional<String> duration;
  Optional<CoordinatesResponseScheme> coordinates;
  List<CmsImageResponseScheme> images;
}

@JsonResponse()
class CmsImageResponseScheme {
  String image;
  CmsColorResponseScheme avg;
}

@JsonResponse()
class CmsColorResponseScheme {
  int r;
  int g;
  int b;
  int a;
}

@JsonResponse()
class CmsResponsePlaceResponseScheme {
  String id;
  String title;
  String address;
  CoordinatesResponseScheme coordinates;
  List<CmsImageResponseScheme> images;
}

@JsonResponse()
class CoordinatesResponseScheme {
  double lat;
  double lng;
}

class FavoriteResponse {
  final List<FavoriteMyResponse> my;
  final List<FavoriteTourPackagesResponse> tourPackages;
  final List<FavoriteToursResponse> tours;

  FavoriteResponse.fromJson(Map<String, dynamic> json)
      : my = transformJsonListOfMap(
          json,
          'my',
          (it) => FavoriteMyResponse.fromJson(it),
        ),
        tourPackages = transformJsonListOfMap(
          json,
          'tourPackages',
          (it) => FavoriteTourPackagesResponse.fromJson(it),
        ),
        tours = transformJsonListOfMap(
          json,
          'tours',
          (it) => FavoriteToursResponse.fromJson(it),
        ) {
    require(
      my != null,
      () => SchemeConsistencyException('my is null'),
    );
    require(
      tourPackages != null,
      () => SchemeConsistencyException('tourPackages is null'),
    );
    require(
      tours != null,
      () => SchemeConsistencyException('tours is null'),
    );
  }
}

class FavoriteMyResponse {
  final int contentCount;
  final String id;
  final List<FavoriteMyImagesResponse> images;
  final String name;
  final Optional<FavoriteMyOffersResponse> offers;

  FavoriteMyResponse.fromJson(Map<String, dynamic> json)
      : contentCount = getJsonValue(json, 'contentCount'),
        id = getJsonValue(json, 'id'),
        images = transformJsonListOfMap(
          json,
          'images',
          (it) => FavoriteMyImagesResponse.fromJson(it),
        ),
        name = getJsonValue(json, 'name'),
        offers = transformJsonValueOrEmpty(
          json,
          'offers',
          (it) => FavoriteMyOffersResponse.fromJson(it),
        ) {
    require(
      contentCount != null,
      () => SchemeConsistencyException('contentCount is null'),
    );
    require(
      id != null,
      () => SchemeConsistencyException('id is null'),
    );
    require(
      images != null,
      () => SchemeConsistencyException('images is null'),
    );
    require(
      name != null,
      () => SchemeConsistencyException('name is null'),
    );
    require(
      offers != null,
      () => SchemeConsistencyException('offers is null'),
    );
  }
}

class FavoriteMyImagesResponse {
  final Optional<String> description;
  final String url;

  FavoriteMyImagesResponse.fromJson(Map<String, dynamic> json)
      : description = getJsonValueOrEmpty(json, 'description'),
        url = getJsonValue(json, 'url') {
    require(
      description != null,
      () => SchemeConsistencyException('description is null'),
    );
    require(
      url != null,
      () => SchemeConsistencyException('url is null'),
    );
  }
}

class FavoriteMyOffersResponse {
  final String id;

  FavoriteMyOffersResponse.fromJson(Map<String, dynamic> json)
      : id = getJsonValue(json, 'id') {
    require(
      id != null,
      () => SchemeConsistencyException('id is null'),
    );
  }
}

class FavoriteMyDetailResponse {
  final List<FavoriteMyDetailActivitiesResponse> activities;
  final int contentCount;
  final String id;
  final String name;

  FavoriteMyDetailResponse.fromJson(Map<String, dynamic> json)
      : activities = transformJsonListOfMap(
          json,
          'activities',
          (it) => FavoriteMyDetailActivitiesResponse.fromJson(it),
        ),
        contentCount = getJsonValue(json, 'contentCount'),
        id = getJsonValue(json, 'id'),
        name = getJsonValue(json, 'name') {
    require(
      activities != null,
      () => SchemeConsistencyException('activities is null'),
    );
    require(
      contentCount != null,
      () => SchemeConsistencyException('contentCount is null'),
    );
    require(
      id != null,
      () => SchemeConsistencyException('id is null'),
    );
    require(
      name != null,
      () => SchemeConsistencyException('name is null'),
    );
  }
}

class FavoriteMyDetailActivitiesResponse {
  //final FavoriteMyEntityDetailedViewResponse entity;
  dynamic entity;
  final String id;
  final String type;

  final acceptable = ['ROUTE', 'TOUR', 'PLACE', 'RESTAURANT', 'EVENT'];

  FavoriteMyDetailActivitiesResponse.fromJson(Map<String, dynamic> json)
      : type = getJsonValue(json, 'type'),
        id = getJsonValue(json, 'id') {
    entity = getEntityParseSheme(type, json);
    require(
      entity != null,
      () => SchemeConsistencyException('entity is null'),
    );
    require(
      id != null,
      () => SchemeConsistencyException('id is null'),
    );
    require(
      acceptable.contains(type),
      () => SchemeConsistencyException(
        'type contains invalid value: $type !in $acceptable',
      ),
    );
  }

  dynamic getEntityParseSheme(String type, Map<String, dynamic> json) {
    switch (type) {
      case 'EVENT':
        return FavoriteMyEntityDetailedViewEventResponse.fromJson(
          getJsonValue(json, 'entity'),
        );
        break;
      case 'RESTAURANT':
        return FavoriteMyEntityDetailedViewRestaurantResponse.fromJson(
          getJsonValue(json, 'entity'),
        );
      default:
        return '';
    }
  }
}

class FavoriteMyEntityDetailedViewEventResponse {
  final FavoriteMyDetailActivitiesEntityEventItemResponse item;
  final List<FavoriteMyDetailActivitiesEntityEventItemPlacesResponse> places;

  FavoriteMyEntityDetailedViewEventResponse.fromJson(Map<String, dynamic> json)
      : item = FavoriteMyDetailActivitiesEntityEventItemResponse.fromJson(
          getJsonValue(json, 'item'),
        ),
        places = transformJsonListOfMap(
          json,
          'places',
          (it) =>
              FavoriteMyDetailActivitiesEntityEventItemPlacesResponse.fromJson(
                  it),
        ) {
    require(
      item != null,
      () => SchemeConsistencyException('item is null'),
    );
    require(
      places != null,
      () => SchemeConsistencyException('places is null'),
    );
  }
}

class FavoriteMyDetailActivitiesEntityEventItemResponse {
  final String id;
  final String title;
  final String description;
  final List<FavoriteMyDetailActivitiesEntityEventItemImagesResponse> images;

  FavoriteMyDetailActivitiesEntityEventItemResponse.fromJson(
      Map<String, dynamic> json)
      : id = getJsonValue(json, 'id'),
        title = getJsonValue(json, 'title'),
        description = getJsonValue(json, 'description'),
        images = transformJsonListOfMap(
          json,
          'images',
          (it) =>
              FavoriteMyDetailActivitiesEntityEventItemImagesResponse.fromJson(
                  it),
        ) {
    require(
      id != null,
      () => SchemeConsistencyException('id is null'),
    );
    require(
      title != null,
      () => SchemeConsistencyException('title is null'),
    );
    require(
      description != null,
      () => SchemeConsistencyException('description is null'),
    );
    require(
      images != null,
      () => SchemeConsistencyException('images is null'),
    );
  }
}

class FavoriteMyDetailActivitiesEntityEventItemImagesResponse {
  final String image;

  FavoriteMyDetailActivitiesEntityEventItemImagesResponse.fromJson(
      Map<String, dynamic> json)
      : image = getJsonValue(json, 'image') {
    require(
      image != null,
      () => SchemeConsistencyException('image is null'),
    );
  }
}

class FavoriteMyDetailActivitiesEntityEventItemPlacesResponse {
  final String id;
  final String title;
  final String address;
  final FavoriteMyDetailActivitiesEntityEventItemPlacesCoordinatesResponse
      coordinates;
  final List<FavoriteMyDetailActivitiesEntityEventItemPlacesImagesResponse>
      images;

  FavoriteMyDetailActivitiesEntityEventItemPlacesResponse.fromJson(
      Map<String, dynamic> json)
      : id = getJsonValue(json, 'id'),
        title = getJsonValue(json, 'title'),
        address = getJsonValue(json, 'address'),
        coordinates =
            FavoriteMyDetailActivitiesEntityEventItemPlacesCoordinatesResponse
                .fromJson(
          getJsonValue(json, 'coordinates'),
        ),
        images = transformJsonListOfMap(
          json,
          'images',
          (it) => FavoriteMyDetailActivitiesEntityEventItemPlacesImagesResponse
              .fromJson(it),
        ) {
    require(
      id != null,
      () => SchemeConsistencyException('id is null'),
    );
    require(
      title != null,
      () => SchemeConsistencyException('title is null'),
    );
    require(
      address != null,
      () => SchemeConsistencyException('address is null'),
    );
    require(
      coordinates != null,
      () => SchemeConsistencyException('coordinates is null'),
    );
    require(
      images != null,
      () => SchemeConsistencyException('images is null'),
    );
  }
}

class FavoriteMyDetailActivitiesEntityEventItemPlacesCoordinatesResponse {
  final double lng;
  final double lat;

  FavoriteMyDetailActivitiesEntityEventItemPlacesCoordinatesResponse.fromJson(
      Map<String, dynamic> json)
      : lng = getJsonValue(json, 'lng'),
        lat = getJsonValue(json, 'lat') {
    require(
      lng != null,
      () => SchemeConsistencyException('lng is null'),
    );
    require(
      lat != null,
      () => SchemeConsistencyException('lat is null'),
    );
  }
}

class FavoriteMyDetailActivitiesEntityEventItemPlacesImagesResponse {
  final String image;

  FavoriteMyDetailActivitiesEntityEventItemPlacesImagesResponse.fromJson(
      Map<String, dynamic> json)
      : image = getJsonValue(json, 'image') {
    require(
      image != null,
      () => SchemeConsistencyException('image is null'),
    );
  }
}

class FavoriteMyEntityDetailedViewRestaurantResponse {
  final FavoriteMyEntityDetailedViewRestaurantItemResponse item;

  FavoriteMyEntityDetailedViewRestaurantResponse.fromJson(
      Map<String, dynamic> json)
      : item = FavoriteMyEntityDetailedViewRestaurantItemResponse.fromJson(
          getJsonValue(json, 'item'),
        ) {
    require(
      item != null,
      () => SchemeConsistencyException('item is null'),
    );
  }
}

class FavoriteMyEntityDetailedViewRestaurantItemResponse {
  final String id;
  final String title;
  final String description;
  final String address;
  final FavoriteMyEntityDetailedViewRestaurantItemCoordinatesResponse
      coordinates;
  final List<FavoriteMyEntityDetailedViewRestaurantItemImagesResponse> images;

  FavoriteMyEntityDetailedViewRestaurantItemResponse.fromJson(
      Map<String, dynamic> json)
      : id = getJsonValue(json, 'id'),
        title = getJsonValue(json, 'title'),
        description = getJsonValue(json, 'description'),
        address = getJsonValue(json, 'address'),
        coordinates =
            FavoriteMyEntityDetailedViewRestaurantItemCoordinatesResponse
                .fromJson(
          getJsonValue(json, 'coordinates'),
        ),
        images = transformJsonListOfMap(
          json,
          'images',
          (it) =>
              FavoriteMyEntityDetailedViewRestaurantItemImagesResponse.fromJson(
                  it),
        ) {
    require(
      id != null,
      () => SchemeConsistencyException('id is null'),
    );
    require(
      title != null,
      () => SchemeConsistencyException('title is null'),
    );
    require(
      description != null,
      () => SchemeConsistencyException('description is null'),
    );
    require(
      address != null,
      () => SchemeConsistencyException('address is null'),
    );
    require(
      coordinates != null,
      () => SchemeConsistencyException('coordinates is null'),
    );
    require(
      images != null,
      () => SchemeConsistencyException('images is null'),
    );
  }
}

class FavoriteMyEntityDetailedViewRestaurantItemCoordinatesResponse {
  final double lng;
  final double lat;

  FavoriteMyEntityDetailedViewRestaurantItemCoordinatesResponse.fromJson(
      Map<String, dynamic> json)
      : lng = getJsonValue(json, 'lng'),
        lat = getJsonValue(json, 'lat') {
    require(
      lng != null,
      () => SchemeConsistencyException('lng is null'),
    );
    require(
      lat != null,
      () => SchemeConsistencyException('lat is null'),
    );
  }
}

class FavoriteMyEntityDetailedViewRestaurantItemImagesResponse {
  final String image;

  FavoriteMyEntityDetailedViewRestaurantItemImagesResponse.fromJson(
      Map<String, dynamic> json)
      : image = getJsonValue(json, 'image') {
    require(
      image != null,
      () => SchemeConsistencyException('image is null'),
    );
  }
}

class FavoriteTourPackagesResponse {
  final String id;
  final String name;
  final List<FavoriteTourPackagesImagesResponse> images;
  final String price;

  FavoriteTourPackagesResponse.fromJson(Map<String, dynamic> json)
      : id = getJsonValue(json, 'id'),
        name = getJsonValue(json, 'name'),
        images = transformJsonListOfMap(json, 'images',
            (it) => FavoriteTourPackagesImagesResponse.fromJson(it)),
        price = getJsonValue(json, 'price') {
    require(id != null,
        () => SchemeConsistencyException('"id" should not be null'));
    require(name != null,
        () => SchemeConsistencyException('"name" should not be null'));
    require(images != null,
        () => SchemeConsistencyException('"images" should not be null'));
    require(price != null,
        () => SchemeConsistencyException('"price" should not be null'));
  }
}

class FavoriteTourPackagesImagesResponse {
  final String url;

  FavoriteTourPackagesImagesResponse.fromJson(Map<String, dynamic> json)
      : url = getJsonValue(json, 'url') {
    require(url != null,
        () => SchemeConsistencyException('"url" should not be null'));
  }
}

class FavoriteToursResponse {
  final String id;
  final String name;
  final List<FavoriteToursImagesResponse> images;
  final String price;

  FavoriteToursResponse.fromJson(Map<String, dynamic> json)
      : id = getJsonValue(json, 'id'),
        name = getJsonValue(json, 'name'),
        images = transformJsonListOfMap(
            json, 'images', (it) => FavoriteToursImagesResponse.fromJson(it)),
        price = getJsonValue(json, 'price') {
    require(id != null,
        () => SchemeConsistencyException('"id" should not be null'));
    require(name != null,
        () => SchemeConsistencyException('"name" should not be null'));
    require(images != null,
        () => SchemeConsistencyException('"images" should not be null'));
    require(price != null,
        () => SchemeConsistencyException('"price" should not be null'));
  }
}

class FavoriteToursImagesResponse {
  final String url;

  FavoriteToursImagesResponse.fromJson(Map<String, dynamic> json)
      : url = getJsonValue(json, 'url') {
    require(url != null,
        () => SchemeConsistencyException('"url" should not be null'));
  }
//TODO: create tourPackages and tours response
//final List<TourPackagesResponse> tourPackages;
//final List<ToursResponse> tours;
}

@JsonResponse()
class FavoriteForPlanResponseScheme {
  String id;
  String name;
  List<FavoriteForPlanActivitiesResponseScheme> activities;
}

@JsonResponse()
class FavoriteForPlanActivitiesResponseScheme {
  String id;
  String type;
}

@JsonResponse()
class PackageDetailResponseScheme {
  PackageDetailItemResponseScheme item;
  List<PackageDetailRouteCitiesResponseScheme> cities;
  List<PackageDetailTagsResponseScheme> tags;
}

@JsonResponse()
class PackageDetailRouteCitiesResponseScheme {
  String id;
  String title;
}

@JsonResponse()
class PackageDetailItemResponseScheme {
  String id;
  String title;
  String description;
  String time;
  String city;
  int packet_price;
  List<PackageDetailItemRouteResponseScheme> route;
  List<PackageDetailItemImageDetailedPageMainResponseScheme>
      image_detailed_page_main;
}

@JsonResponse()
class PackageDetailItemRouteResponseScheme {
  String id;
  String title;
  List<String> tags;
  List<PackageDetailItemRouteImagesResponseScheme> images;
}

@JsonResponse()
class PackageDetailItemImageDetailedPageMainResponseScheme {
  String image;
}

@JsonResponse()
class PackageDetailItemRouteImagesResponseScheme {
  String image;
}

@JsonResponse()
class PackageDetailTagsResponseScheme {
  String id;
  String title;
}

@JsonResponse()
class EventDetailResponseScheme {
  EventDetailItemResponseScheme item;
  List<EventDetailPlacesResponseScheme> places;
  //TODO доделать после показа, только в дизайне их нет
//  List<EventDetailTagsResponseScheme> tags;
}

@JsonResponse()
class EventDetailItemResponseScheme {
  String id;
  String title;
  String description;
  String min_age;
  List<EventDetailItemImagesResponseScheme> images;
  List<String> tags_ids;
  List<String> small_schedule;
  List<String> places_ids;
  List<String> city;
  String duration;
  String ticket_price;
  String schedule_description;
  String link_source;
}

@JsonResponse()
class EventDetailItemImagesResponseScheme {
  String image;
}

@JsonResponse()
class EventDetailPlacesResponseScheme {
  String address;
  EventDetailPlacesCoordinatesResponseScheme coordinates;
}

@JsonResponse()
class EventDetailPlacesCoordinatesResponseScheme {
  double lat;
  double lng;
}

@JsonResponse()
class RestaurantDetailResponseScheme {
  RestaurantDetailItemResponseScheme item;
  List<RestaurantDetailCuisinesResponseScheme> cuisines;
}

@JsonResponse()
class RestaurantDetailItemResponseScheme {
  String id;
  String title;
  String description;
  String address;
  RestaurantDetailCoordinatesResponseScheme coordinates;
  List<RestaurantDetailImagesResponseScheme> images;
  //TODO в одних ресторанах есть в других нет
//  Optional<List<RestaurantDetailImageDetailedPageMainResponseScheme>> image_detailed_page_main;
  List<String> cuisines_ids;
  int bill;
  int avg_time_visit;
  String site;
  RestaurantDetailScheduleResponseScheme working_time;
}

@JsonResponse()
class RestaurantDetailCoordinatesResponseScheme {
  double lat;
  double lng;
}

@JsonResponse()
class RestaurantDetailImagesResponseScheme {
  String image;
}

//@JsonResponse()
//class RestaurantDetailImageDetailedPageMainResponseScheme {
//  String image;
//}

@JsonResponse()
class RestaurantDetailScheduleResponseScheme {
  Optional<RestaurantDetailScheduleAllResponseScheme> all;
  Optional<RestaurantDetailScheduleDaysResponseScheme> days;
  Optional<String> description;
}

@JsonResponse()
class RestaurantDetailScheduleAllResponseScheme {
  Optional<String> startTime;
  Optional<String> endTime;
//  List breaks;
}

@JsonResponse()
class RestaurantDetailScheduleDaysResponseScheme {
  Optional<RestaurantDetailScheduleCurDaysResponseScheme> Mon;
  Optional<RestaurantDetailScheduleCurDaysResponseScheme> Tue;
  Optional<RestaurantDetailScheduleCurDaysResponseScheme> Wed;
  Optional<RestaurantDetailScheduleCurDaysResponseScheme> Thu;
  Optional<RestaurantDetailScheduleCurDaysResponseScheme> Fri;
  Optional<RestaurantDetailScheduleCurDaysResponseScheme> Sat;
  Optional<RestaurantDetailScheduleCurDaysResponseScheme> Sun;
}

@JsonResponse()
class RestaurantDetailScheduleCurDaysResponseScheme {
  Optional<bool> closed;
  Optional<String> startTime;
  Optional<String> endTime;
}

@JsonResponse()
class RestaurantDetailCuisinesResponseScheme {
  String id;
  String title;
}

@JsonResponse()
class CreatePlanResponseScheme {
  String id;
}
