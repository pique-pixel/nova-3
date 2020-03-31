import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:optional/optional.dart';

class FavoriteModel extends Equatable {
  final List<FavoriteMyItemModel> my;
  final List<FavoriteTourPackagesModel> tourPackages;
  final List<FavoriteToursModel> tours;

  FavoriteModel({
    @required this.my,
    @required this.tourPackages,
    @required this.tours,
  }) : assert(my != null),
       assert(tourPackages != null),
       assert(tours != null);

  @override
  List<Object> get props => [my, tourPackages, tours];
}

class FavoriteMyItemModel extends Equatable {
  final int contentCount;
  final String id;
  final List<FavoriteMyItemImages> images;
  final String name;

  FavoriteMyItemModel({
    @required this.contentCount,
    @required this.id,
    @required this.images,
    @required this.name,
  })  : assert(contentCount != null),
        assert(id != null),
        assert(images != null),
        assert(name != null);

  @override
  List<Object> get props => [contentCount, id, images, name];
}

class FavoriteMyItemImages {
  final Optional<String> description;
  final String url;

  FavoriteMyItemImages({this.description, this.url});
}

class FavoriteTourPackagesModel extends Equatable {
  final String id;
  final String name;
  final String image;
  final String price;

  FavoriteTourPackagesModel({
    @required this.id,
    @required this.name,
    @required this.image,
    @required this.price
  })
      : assert(id != null),
        assert(name != null),
        assert(image != null),
        assert(price != null);

  @override
  List<Object> get props => [id, name, image, price];
}

class FavoriteToursModel extends Equatable {
  final String id;
  final String name;
  final String image;
  final String price;

  FavoriteToursModel({
    @required this.id,
    @required this.name,
    @required this.image,
    @required this.price})
      : assert(id != null),
        assert(name != null),
        assert(image != null),
        assert(price != null);

  @override
  List<Object> get props => [id, name, image, price];
}

class FavoriteForPlan extends Equatable {
  final String id;
  final String name;
  final List<FavoriteForPlanActivities> activities;

  FavoriteForPlan({
    @required this.id,
    @required this.name,
    @required this.activities,
  }) : assert(id != null),
        assert(name != null),
        assert(activities != null);

  @override
  List<Object> get props => [id, name, activities];
}
class FavoriteForPlanActivities extends Equatable {
  final String id;
  final String type;
  FavoriteForPlanActivities({
    @required this.id,
    @required this.type,
  }) : assert(id != null),
        assert(type != null);

  @override
  List<Object> get props => [id, type];
}

/*
class PlanFromFavorite extends Equatable {
  final String name;
  final List<PlanFromFavoriteActivities> activities;

  PlanFromFavorite({
    @required this.name,
    @required this.activities,
  }) : assert(name != null),
        assert(activities != null);

  @override
  List<Object> get props => [name, activities];
}

class PlanFromFavoriteActivities extends Equatable {
  final String id;
  final String type;
  PlanFromFavoriteActivities({
    @required this.id,
    @required this.type,
  }) : assert(id != null),
        assert(type != null);

  @override
  List<Object> get props => [id, type];
}*/
