import 'package:equatable/equatable.dart';
//import 'package:rp_mobile/locale/localized_string.dart';

abstract class SectionModel extends Equatable {}

class PackageDetail extends SectionModel {
  final HeaderSection header;
  final PackageConstitutionSection services;
  final ActivitiesSection activities;

  PackageDetail({
    this.header,
    this.services,
    this.activities,
  })  : assert(header != null),
        assert(services != null),
        assert(activities != null);

  @override
  List<Object> get props => [header, services, activities];
}

class HeaderSection extends SectionModel {
  final String id;
  final String thumbnailUrl;
  final String title;
  final List<SubTitle> subTitle;
  final List<CityModel> cities;
  final int price;

  HeaderSection({
    this.id,
    this.thumbnailUrl,
    this.title,
    this.subTitle,
    this.cities = const [],
    this.price,
  })  : assert(id != null),
        assert(thumbnailUrl != null),
        assert(title != null),
        assert(subTitle != null),
        assert(cities != null),
        assert(price != null);

  @override
  List<Object> get props => [id, title, subTitle, cities, price];
}

class PackageConstitutionSection extends SectionModel {
  final String title;
  final List<PackageConstitutionItem> items;

  PackageConstitutionSection({
    this.title,
    this.items = const [],
  })  : assert(title != null),
        assert(items != null);

  @override
  List<Object> get props => [title, items];
}

class PackageConstitutionItem extends Equatable {
  final String title;
  final String description;
  final String thumbnailUrl;

  PackageConstitutionItem({this.title, this.description, this.thumbnailUrl})
      : assert(title != null),
        assert(description != null),
        assert(thumbnailUrl != null);

  @override
  List<Object> get props => [title, description, thumbnailUrl];
}

class ActivitiesSection extends SectionModel {
  final String title;
  final String description;
  final List<ActivityFilter> filters;
  final List<ActivityModel> activities;
  final bool isLoadedAllItems;

  ActivitiesSection({
    this.title,
    this.filters,
    this.activities = const [],
    this.description,
    this.isLoadedAllItems = false,
  })  : assert(title != null),
        assert(filters != null),
        assert(activities != null),
        assert(description != null),
        assert(isLoadedAllItems != null);

  @override
  List<Object> get props => [
        title,
        description,
        filters,
        activities,
        isLoadedAllItems,
      ];

  @override
  String toString() {
    return '$ActivitiesSection($title, $description, $filters, $activities, '
        '$isLoadedAllItems)';
  }

  ActivitiesSection copyWith({
    title,
    filters,
    activities,
    description,
    isExpanded,
  }) {
    return ActivitiesSection(
      title: title ?? this.title,
      filters: filters ?? this.filters,
      activities: activities ?? this.activities,
      description: description ?? this.description,
      isLoadedAllItems: isExpanded ?? this.isLoadedAllItems,
    );
  }
}

class ActivityModel extends Equatable {
  final String id;
  final String thumbnailUrl;
  final String title;

  ActivityModel({this.id, this.thumbnailUrl, this.title})
      : assert(id != null),
        assert(thumbnailUrl != null),
        assert(title != null);

  @override
  List<Object> get props => [id, thumbnailUrl, title];

  @override
  String toString() {
    return '$ActivityModel($id, $thumbnailUrl, $title)';
  }
}

class ActivityFilter extends Equatable {
  final String ref;
  final String title;
  final bool isActive;

  ActivityFilter({this.ref, this.title, this.isActive = false})
      : assert(title != null),
        assert(isActive != null);

  @override
  List<Object> get props => [title, isActive];

  ActivityFilter copyWith({ref, title, isActive}) {
    return ActivityFilter(
      ref: ref ?? this.ref,
      title: title ?? this.title,
      isActive: isActive ?? this.isActive,
    );
  }
}

enum SubTitleGrade {
  normal,
  grade1,
}

class SubTitle extends Equatable {
  final String data;
  final SubTitleGrade subTitleGrade;

  SubTitle(this.data, [this.subTitleGrade = SubTitleGrade.normal])
      : assert(data != null),
        assert(subTitleGrade != null);

  @override
  List<Object> get props => [data, subTitleGrade];
}

class CityModel extends Equatable {
  final String ref;
  final String name;
  final bool isSelected;

  CityModel({this.ref, this.name, this.isSelected})
      : assert(ref != null),
        assert(name != null),
        assert(isSelected != null);

  @override
  List<Object> get props => [name, isSelected];
}
