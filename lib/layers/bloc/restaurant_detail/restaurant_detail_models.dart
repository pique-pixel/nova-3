import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
//import 'package:optional/optional.dart';
import 'package:rp_mobile/containers/image.dart';
//import 'package:rp_mobile/locale/localized_string.dart';

class RestaurantDetail extends Equatable {
  final String id;
  final ImageEither headerThumbnail;
  final String title;
  final String description;
  final String address;
  final RestaurantDetailPlacesMap coordinates;
  final List<String> images;
  final String price;
  final String duration;
  final String link;
  final List<RestaurantDetailPlacesCuisines> cuisines;
//  final RestaurantDetailPlacesSchedule schedule;

  RestaurantDetail({
    @required this.id,
    @required this.headerThumbnail,
    @required this.title,
    @required this.description,
    @required this.address,
    @required this.coordinates,
    @required this.images,
    @required this.price,
    @required this.duration,
    @required this.link,
    @required this.cuisines,
//    this.schedule,
  })  : assert(id != null),
        assert(headerThumbnail != null),
        assert(title != null),
        assert(description != null),
        assert(address != null),
        assert(coordinates != null),
        assert(images != null),
        assert(price != null),
        assert(duration != null),
        assert(link != null),
        assert(cuisines != null)/*,
        assert(schedule != null)*/;

  @override
  List<Object> get props => [
    id,
    headerThumbnail,
    title,
    description,
    address,
    coordinates,
    images,
    price,
    duration,
    link,
    cuisines,
//    schedule
  ];
}

abstract class RestaurantDetailPlaces extends Equatable {}

class RestaurantDetailPlacesSchedule extends RestaurantDetailPlaces {
  final all;
  final days;
  final String description;

  RestaurantDetailPlacesSchedule({
    this.all,
    this.days,
    this.description
  })  : assert(all != null),
        assert(days != null),
        assert(description != null);

  @override
  List<Object> get props => [all, days, description];
}

class RestaurantDetailPlacesCuisines extends RestaurantDetailPlaces {
  final String id;
  final String title;

  RestaurantDetailPlacesCuisines({
    @required this.id,
    @required this.title,
  })  : assert(id != null),
        assert(title != null);

  @override
  List<Object> get props => [id, title];
}

class RestaurantDetailPlacesMap extends RestaurantDetailPlaces {
  final double lng;
  final double lat;

  RestaurantDetailPlacesMap({
    @required this.lng,
    @required this.lat,
  })  : assert(lng != null),
        assert(lat != null);

  @override
  List<Object> get props => [lng, lat];
}