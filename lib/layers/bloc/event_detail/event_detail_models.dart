import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
//import 'package:optional/optional.dart';
import 'package:rp_mobile/containers/image.dart';
//import 'package:rp_mobile/locale/localized_string.dart';

class EventDetail extends Equatable {
  final String id;
  final ImageEither headerThumbnail;
  final String title;
//  final List tags;
  final String description;
  final List<EventDetailPlacesContent> places;
  final List images;
  final String price;
  final String duration;
  final String link;

  EventDetail({
    @required this.id,
    @required this.headerThumbnail,
    @required this.title,
//    @required this.tags,
    @required this.description,
    @required this.places,
    @required this.images,
    @required this.price,
    @required this.duration,
    @required this.link,
  })  : assert(id != null),
        assert(headerThumbnail != null),
        assert(title != null),
//        assert(tags != null),
        assert(description != null),
        assert(places != null),
        assert(images != null),
        assert(price != null),
        assert(duration != null),
        assert(link != null);

  @override
  List<Object> get props => [
    id,
    headerThumbnail,
    title,
//    tags,
    description,
    places,
    images,
    price,
    duration,
    link
  ];
}

abstract class EventDetailPlaces extends Equatable {}

class EventDetailPlacesContent extends EventDetailPlaces {
  final String address;
  final EventDetailPlacesMap coordinates;

  EventDetailPlacesContent({
    @required this.address,
    @required this.coordinates,
  })  : assert(address != null),
        assert(coordinates != null);

  @override
  List<Object> get props => [address, coordinates];
}

class EventDetailPlacesMap extends EventDetailPlaces {
  final double lng;
  final double lat;

  EventDetailPlacesMap({
    @required this.lng,
    @required this.lat,
  })  : assert(lng != null),
        assert(lat != null);

  @override
  List<Object> get props => [lng, lat];
}