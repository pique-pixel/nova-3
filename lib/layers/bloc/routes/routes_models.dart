import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:optional/optional_internal.dart';
import 'package:rp_mobile/containers/image.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class SearchSuggestion extends Equatable {
  final String ref;
  final String name;
  final String address;
  final Optional<ImageEither> image;
  final Optional<String> distance;

  SearchSuggestion({
    this.ref,
    this.name,
    this.address,
    this.image = const Optional.empty(),
    this.distance = const Optional.empty(),
  });

  @override
  List<Object> get props => [ref, name];
}

class Day extends Equatable {
  final String ref;
  final String day;

  Day({
    @required this.ref,
    @required this.day,
  })  : assert(ref != null),
        assert(day != null);

  @override
  List<Object> get props => [ref, day];
}

class GeoObject extends Equatable {
  final String ref;
  final String title;
  final double latitude;
  final double longitude;
  final Optional<String> distance;
  final Optional<String> pinIconUrl;

  GeoObject({
    @required this.ref,
    @required this.title,
    @required this.latitude,
    @required this.longitude,
    this.distance = const Optional.empty(),
    this.pinIconUrl = const Optional.empty(),
  })  : assert(ref != null),
        assert(latitude != null),
        assert(longitude != null);

  @override
  List<Object> get props => [ref, title, latitude, longitude, pinIconUrl];
}

class GeoObjectDetails extends Equatable {
  final String ref;
  final String title;
  final String openUntil;
  final Optional<ImageEither> image;
  final String address;
  final double latitude;
  final double longitude;
  final Optional<String> distance;

  Point get point => Point(latitude: latitude, longitude: longitude);

  GeoObjectDetails({
    @required this.ref,
    @required this.title,
    @required this.openUntil,
    @required this.address,
    @required this.latitude,
    @required this.longitude,
    this.distance = const Optional.empty(),
    this.image = const Optional.empty(),
  })  : assert(ref != null),
        assert(title != null),
        assert(openUntil != null),
        assert(address != null),
        assert(latitude != null),
        assert(longitude != null),
        assert(distance != null),
        assert(image != null);

  @override
  List<Object> get props => [
        ref,
        title,
        openUntil,
        address,
        latitude,
        longitude,
        distance,
        image,
      ];
}
