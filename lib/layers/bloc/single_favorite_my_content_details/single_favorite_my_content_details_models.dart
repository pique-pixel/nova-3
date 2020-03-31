import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:rp_mobile/layers/bloc/routes/routes_models.dart';

class FavoriteMyDetailModel extends Equatable {
  final int contentCount;
  final String id;
  final String name;
  final List<FavoriteMyDetailItemModel> activities;

  FavoriteMyDetailModel(
      {@required this.contentCount,
      @required this.id,
      @required this.name,
      @required this.activities})
      : assert(contentCount != null),
        assert(id != null),
        assert(name != null),
        assert(activities != null);

  @override
  List<Object> get props =>[contentCount, id, name, activities];
}

class FavoriteMyDetailItemModel extends Equatable {
  final String id;
  final String type;
  final String address;
  final String image;
  final String title;
  final String description;
  final GeoObject geoData;

  FavoriteMyDetailItemModel(
      {
      @required this.id,
      @required this.type,
      @required this.address,
      @required this.image,
      @required this.title,
      @required this.description,
      @required this.geoData})
      : assert(id != null),
        assert(type != null),
        assert(address != null),
        assert(image != null),
        assert(title != null),
        assert(description != null),
        assert(geoData != null);

  @override
  List<Object> get props => [id, type, address, image, title, description, geoData];
}
