import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:optional/optional.dart';
import 'package:rp_mobile/config.dart';
import 'package:rp_mobile/containers/image.dart';
import 'package:rp_mobile/containers/page.dart';
import 'package:rp_mobile/layers/adapters/ui_models_factory.dart';
import 'package:rp_mobile/layers/bloc/plan_details/plan_models.dart';
import 'package:rp_mobile/layers/bloc/plans/plans_models.dart';
import 'package:rp_mobile/layers/bloc/favorites/favorite_models.dart';
import 'package:rp_mobile/layers/bloc/routes/routes_models.dart';
import 'package:rp_mobile/layers/bloc/single_favorite_my_content_details/single_favorite_my_content_details_models.dart';
import 'package:rp_mobile/layers/bloc/single_ticket_content_details/single_ticket_content_details_models.dart';
import 'package:rp_mobile/layers/bloc/tickets/tickets_models.dart';
import 'package:rp_mobile/layers/drivers/api/models.dart';
import 'package:rp_mobile/locale/localized_string.dart';
import 'package:rp_mobile/utils/strings.dart';
import 'package:rp_mobile/layers/bloc/services_package_details/services_package_details_models.dart';
import 'package:rp_mobile/layers/bloc/event_detail/event_detail_models.dart';
import 'package:rp_mobile/layers/bloc/restaurant_detail/restaurant_detail_models.dart';

class UiModelsFactoryImpl implements UiModelsFactory {
  final Config _config;

  UiModelsFactoryImpl(this._config);

  _absoluteImageUrl(String relativeUrl) {
    return '${_config.apiBaseUrl}/attach/image?file=$relativeUrl';
  }

  @override
  Page<TicketItemModel> createTicketsPage(TicketsListResponse response,) {
    final items = <TicketItemModel>[];

    for (final content in response.content) {
      for (final item in content.items) {
        if (!item.item.offerContent.isPresent) {
          continue;
        }

        if (!content.qr.isPresent) {
          continue;
        }

        final ticket = createTicket(content, item);
        items.add(ticket);
      }
    }

    return Page(
      data: items,
      nextPage: response.last ? null : response.number + 2,
    );
  }

  @override
  TicketItemModel createTicket(TicketsListContentResponse content,
      TicketsListContentItemResponse response,) {
    final offerContent = response.item.offerContent.value;
    return TicketItemModel(
      ref: offerContent.id,
      title: LocalizedString.fromString(offerContent.name.value),
      thumbnail: ImageEither.url(_absoluteImageUrl(offerContent.photo.url)),
    );
  }

  @override
  TicketInfoModel createTicketInfo(TicketsListContentResponse content,
      TicketsListContentItemResponse response,) {
    final offerContent = response.item.offerContent.value;
    return TicketInfoModel(
      title: LocalizedString.fromString(offerContent.name.value),
      subTitle: LocalizedString.fromString('RUSSPASS'),
      qrCode: content.qr,
      hint: content.qr
          .map((_) => LocalizedString.fromString('Покажите QR код сотруднику'))
          .orElse(LocalizedString.fromString('')),
      thumbnail: Optional.empty(),
    );
  }

  @override
  SingleTicketContentDetails createSingleTicketContentDetails(
      OfferResponse response,) {
    final sections = <SingleTicketContentSection>[];

    sections.add(
      SingleTicketContentAddressSection(
        address: Optional.of(response.place.address.toLocalizedString()),
        webSite: Optional.of(response.place.url),
      ),
    );

    final availabilities = <String>[];

    if (response.place.forSedentary) {
      availabilities.add('Сидячие инвалиды');
    }

    if (response.place.forVisually) {
      availabilities.add('Слепые');
    }

    if (response.place.forHearing) {
      availabilities.add('Глухие');
    }

    if (response.place.forMental) {
      availabilities.add('Ментальная инвалидность');
    }

    for (final schedule in response.schedules) {
      final fromDate = formatDate(schedule.fromDate);
      final toDate = formatDate(schedule.toDate);
      final scheduleString = <String>['$fromDate - $toDate:\n'];

      for (final details in schedule.details) {
        final grouped = groupWeekDays(details.dayOfWeeks, 2)
            .map((it) => it.show())
            .join(', ');

        final from = formatTime(details.fromTime, '.');
        final to = formatTime(details.toTime, '.');

        scheduleString.add('$grouped: $from - $to');
      }

      if (schedule.additionalInfos.isNotEmpty) {
        scheduleString.add('');
      }

      for (final additionalInfo in schedule.additionalInfos) {
        scheduleString.add(additionalInfo.name.value);
      }

      if (scheduleString.isNotEmpty) {
        sections.add(
          SingleTicketContentIconInfoSpoilerBarSection(
            icon: SingleTicketContentSectionIcon.calendar,
            text: schedule.name.toLocalizedString(),
            spoilerText: LocalizedString.fromString(scheduleString.join('\n')),
          ),
        );
      }
    }

    if (availabilities.isNotEmpty) {
      sections.add(
        SingleTicketContentIconInfoSpoilerBarSection(
          icon: SingleTicketContentSectionIcon.disabled,
          text: LocalizedString.fromString('Адаптирован для МГН'),
          spoilerText: LocalizedString.fromString(
              availabilities.map((it) => it).join('\n')),
        ),
      );
    }

    final price = response.prices.firstWhere(
          (it) => it.currency == 'RUB',
      orElse: () => null,
    );

    if (price != null) {
      String tariffName;

      if (price.type == 'ADULT') {
        tariffName = 'Тариф Взрослый';
      } else if (price.type == 'CHILD') {
        tariffName = 'Тариф Детский';
      }

      assert(tariffName != null);

      sections.add(
        SingleTicketContentInfoBarTariffSection(
          text: LocalizedString.fromString(tariffName),
          time: LocalizedString.fromString(
            '≈ ' + formatScheduleDuration(response.durationMin),
          ),
          price: LocalizedString.fromString('${price.value} р'),
        ),
      );
    }

    sections.add(
      SingleTicketContentMapSection(
        latitude: response.place.location.x,
        longitude: response.place.location.y,
      ),
    );

    sections.add(
      SingleTicketContentDescSection(
        text: response.description.toLocalizedString(),
      ),
    );

    return SingleTicketContentDetails(
      headerThumbnail: ImageEither.url(
        _absoluteImageUrl(response.place.headerPhoto.url),
      ),
      title: response.fullName.toLocalizedString(),
      tags: response.tags.map((it) => it.name.toLocalizedString()).toList(),
      sections: sections,
    );
  }

  @override
  PlanItemModel createPlanItemModel(PlanViewLiteResponse response) {
    LocalizedString subTitle = LocalizedString.fromString('');

    if (response.startDate.isPresent && response.endDate.isPresent) {
      final startDateTime = createDateTimeFromResponse(
        response.startDate.orElse(''),
      );
      final endDateTime = createDateTimeFromResponse(
        response.endDate.orElse(''),
      );

      final String startDate = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY, 'ru')
          .format(startDateTime);
      final String endDate =
      DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY, 'ru').format(endDateTime);

      subTitle = LocalizedString.fromString('$startDate - $endDate');
    } else {
      if (response.contentCount > 0) {
        final count = formatCount(
          response.contentCount,
          ['точек', 'точка', 'точки'],
        );
        subTitle = LocalizedString.fromString(count);
      } else {
        subTitle = LocalizedString.fromString('Список поездок пуст');
      }
    }

    final Optional<ImageEither> image = response.images.isEmpty
        ? Optional.empty()
        : Optional.of(ImageEither.url(response.images.first.url));

    return PlanItemModel(
      ref: response.id,
      thumbnail: image,
      title: LocalizedString.fromString(response.name),
      subTitle: subTitle,
    );
  }

  @override
  Page<PlanItemModel> createPlansPage(List<PlanViewLiteResponse> response) {
    return Page(
      data: response.map((it) => createPlanItemModel(it)).toList(),
      nextPage: null,
    );
  }

  @override
  PlanDetails createPlanDetails(
      PlanDetailedViewResponse response, Optional<String> selectedDateRef) {
    String startDate = '';
    String endDate = '';
    if (response.startDate.isPresent && response.endDate.isPresent) {
      final startDateTime = createDateTimeFromResponse(
        response.startDate.value,
      );
      final endDateTime = createDateTimeFromResponse(
        response.endDate.value,
      );

      startDate = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY, 'ru')
          .format(startDateTime);
      endDate =
          DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY, 'ru').format(endDateTime);
    }

    final spots = <Spot>[];
    final spotsNoDate = <Spot>[];
    final days = <PlanDate>[];
    String spotsHint;
    int totalDurationInMin = 0;
    final Set<String> datedIds = {};

    for (final day in response.days) {
      final date = createDateTimeFromResponse(day.date);

      days.add(
        PlanDate(
          ref: day.date,
          day: date.day,
          weekDayShort: LocalizedString.fromString(
              DateFormat(DateFormat.ABBR_WEEKDAY, 'ru')
                  .format(date)
                  .toUpperCase()),
        ),
      );

      if (selectedDateRef.isPresent) {
        if (selectedDateRef.value != day.date) {
          continue;
        }
      }

      for (final activity in day.activities) {
        var duration = 'Здесь проводят ~ ';

        try {
          final durationOpt = activity.activity.activity.item.duration;

          if (durationOpt.isPresent) {
            duration += formatScheduleDuration(
              int.parse(durationOpt.value),
            );
          } else {
            duration = '';
          }
        } catch (_) {
          duration = '';
        }

        final CmsResponseResponse activityVar = activity.activity.activity;
        ActivityType activityType;
        if (activity.activity.type == 'EVENT') {
          activityType = ActivityType.event;
        } else if (activity.activity.type == 'RESTAURANT') {
          activityType = ActivityType.restaurant;
        } else {
          throw Exception('Invalid Activity Type! Must be EVENT or RESTAURANT');
        }
        datedIds.add(activity.activity.id);
        spots.add(
          Spot(
            ref: activity.activity.id,
            title: LocalizedString.fromString(activityVar.item.title),
            hint: LocalizedString.fromString(duration),
            thumbnail: ImageEither.url(activityVar.item.images.first.image),
            address: LocalizedString.fromString(
              activityVar.places.isPresent
              ? activityVar.places.value.length > 0
                ? activityVar.places.value.first.address
                : null
              : null,
            ),
            type: activityType,
          ),
        );
        if (activityVar.item.duration.isPresent) {
          int parsedInt = int.tryParse(activityVar.item.duration.value) ?? 0;
          totalDurationInMin = totalDurationInMin + parsedInt;
        }
        print(
            'Info ${spots.length}: ${activityVar.item.title} ${activityVar.item
                                                                   .duration
                                                                   .isPresent
                                                               ? activityVar
                                                                   .item
                                                                   .duration
                                                                   .value
                                                               : 'NoTime'}');
      }
    }
    if (!selectedDateRef.isPresent) {
      for (final activity in response.activities) {
        if (datedIds.contains(activity.id)) {
          continue;
        }
        var duration = 'Здесь проводят ~ ';

        try {
          final durationOpt = activity.activity.item.duration;

          if (durationOpt.isPresent) {
            duration += formatScheduleDuration(
              int.parse(durationOpt.value),
            );
          } else {
            duration = '';
          }
        } catch (_) {
          duration = '';
        }

        final CmsResponseResponse activityVar = activity.activity;
        ActivityType activityType;
        if (activity.type == 'EVENT') {
          activityType = ActivityType.event;
        } else if (activity.type == 'RESTAURANT') {
          activityType = ActivityType.restaurant;
        } else {
          throw Exception('Invalid Activity Type! Must be EVENT or RESTAURANT');
        }
        spotsNoDate.add(
          Spot(
            ref: activity.id,
            title: LocalizedString.fromString(activityVar.item.title),
            hint: LocalizedString.fromString(duration),
            thumbnail: ImageEither.url(activityVar.item.images.first.image),
            address: LocalizedString.fromString(
              activityVar.places.isPresent
              ? activityVar.places.value.length > 0
                ? activityVar.places.value.first.address
                : null
              : null,
            ),
            type: activityType,
          ),
        );
        if (activityVar.item.duration.isPresent) {
          int parsedInt = int.tryParse(activityVar.item.duration.value) ?? 0;
          totalDurationInMin = totalDurationInMin + parsedInt;
        }
        print(
            'Info no dated ${spotsNoDate.length}: ${activityVar.item
                .title} ${activityVar.item.duration.isPresent ? activityVar.item
                .duration.value : 'NoTime'}');
      }
    }

    spotsHint = '${formatCount(
      spots.length + spotsNoDate.length,
      ['точек', 'точка', 'точки', 'точек'],
    )}: ~ ${formatHalfHourTime(
      Duration(minutes: totalDurationInMin),
    )}';

    days.sort((a, b) {
      List<int> aa = a.ref.split('.').map((t) => int.tryParse(t)).toList();
      List<int> bb = b.ref.split('.').map((t) => int.tryParse(t)).toList();
      return DateTime(aa[2], aa[1], aa[0])
          .compareTo(DateTime(bb[2], bb[1], bb[0]));
    });

    return PlanDetails(
      ref: response.id,
      header: Header(
        title: LocalizedString.fromString(response.name),
        fromDate: LocalizedString.fromString(startDate),
        toDate: LocalizedString.fromString(endDate),
        selectedDateRef: selectedDateRef,
        dates: days,
      ),
      body: Body(
        tickets: <Ticket>[
//          Ticket(
//            ref: '1',
//            title: LocalizedString.fromString('Нью-Йорк - Москва\nАэрофлот'),
//            date: LocalizedString.fromString('8 фев, чт в 00:20'),
//          ),
//          Ticket(
//            ref: '2',
//            title: LocalizedString.fromString('Нью-Йорк - Москва\nАэрофлот'),
//            date: LocalizedString.fromString('8 фев, чт в 00:20'),
//          ),
//          Ticket(
//            ref: '3',
//            title: LocalizedString.fromString('Нью-Йорк - Москва\nАэрофлот'),
//            date: LocalizedString.fromString('8 фев, чт в 00:20'),
//          ),
        ],
        spots: spots,
        spotsNoDate: spotsNoDate,
        spotsHint: LocalizedString.fromString(spotsHint),
      ),
    );
  }

  @override
  FavoriteModel createFavorite(FavoriteResponse response) {
    final my = <FavoriteMyItemModel>[];
    final tourPackages = response.tourPackages.map((it) =>
        FavoriteTourPackagesModel(
          id: it.id,
          name: it.name,
          image: it.images.length>0 && it.images.first.url.isNotEmpty
              ? it.images.first.url
              : '',
          price: it.price,
        ),
    ).toList();

    final tours = response.tours.map((it) =>
        FavoriteToursModel(
          id: it.id,
          name: it.name,
          image: it.images.length>0 && it.images.first.url.isNotEmpty
              ? it.images.first.url
              : '',
          price: it.price,
        ),
    ).toList();

    for (final item in response.my) {
      my.add(createFavoriteMy(item));
    }

    return FavoriteModel(
        my: my,
        tourPackages: tourPackages,
        tours: tours
    );
  }

  @override
  FavoriteMyItemModel createFavoriteMy(FavoriteMyResponse item) {
    final images = <FavoriteMyItemImages>[];

//    TODO КОСТЫЛЬ, переделать! Сделать как в дизайне, если ничего не добавлено в избранное
    if(item.images.length > 0) {
      for (final data in item.images) {
        images.add(
            FavoriteMyItemImages(description: data.description, url: data.url));
      }
    }else{
      images.add(
          FavoriteMyItemImages(description: null, url: ""));
    }

    return FavoriteMyItemModel(
      contentCount: item.contentCount,
      id: item.id,
      images: images,
      name: item.name,
    );
  }

  FavoriteMyDetailModel createFavoriteDetailById(
      FavoriteMyDetailResponse response) {
    final int contentCount = response.contentCount;
    final String id = response.id;
    final String name = response.name;
    final activities = <FavoriteMyDetailItemModel>[];

    int index = 0;

    for (final data in response.activities) {
      if (data.type == 'EVENT') {
        activities.add(
          FavoriteMyDetailItemModel(
            id: data.id,
            type: data.type,
            address: data.entity.places[0].address,
            description: data.entity.item.description,
            image: data.entity.item.images[0].image,
            title: data.entity.places[0].title,
            geoData: GeoObject(
              ref: index.toString(),
              title: data.entity.places[0].title,
              latitude: data.entity.places[0].coordinates.lat,
              longitude: data.entity.places[0].coordinates.lng,
              pinIconUrl: Optional.of('images/placemark.png'),
            ),
          ),
        );
        index += 1;
      }
      if (data.type == 'RESTAURANT') {
        activities.add(
          FavoriteMyDetailItemModel(
            id: data.id,
            type: data.type,
            address: data.entity.item.address,
            description: data.entity.item.description,
            image: data.entity.item.images[0].image,
            title: data.entity.item.title,
            geoData: GeoObject(
              ref: index.toString(),
              title: data.entity.item.title,
              latitude: data.entity.item.coordinates.lat,
              longitude: data.entity.item.coordinates.lng,
              pinIconUrl: Optional.of('images/placemark.png'),
            ),
          ),
        );
        index += 1;
      }
    }
    return FavoriteMyDetailModel(
      contentCount: contentCount,
      id: id,
      name: name,
      activities: activities,
    );
  }

  @override
  FavoriteForPlan createFavoriteForPlanById(FavoriteForPlanResponse response) {
    //print("createFavoriteForPlanById");
    final planActivities = response.activities.map((it) =>
        FavoriteForPlanActivities(
          id: it.id,
          type: it.type,
        ),
    ).toList();
    return FavoriteForPlan(
        id: response.id,
        name: response.name,
        activities: planActivities
    );
  }

  @override
  PackageDetail createPackageDetails(PackageDetailResponse response) {
//    LocalizedString subTitleString = LocalizedString.fromString('');
    final idTagService = '5e5933093c3de000124a2bc8';

    final imageHeader = response.item.image_detailed_page_main.isEmpty
        ? ""
        : response.item.image_detailed_page_main.first.image;

    final tagsPackage = response.tags.map((it) =>
        ActivityFilter(
          ref: it.id,
          title: it.title,
        ),
    ).toList();

    var activitiesArr = [];
    var servicesArr = [];
    response.item.route.forEach((it) {
      if (it.tags.contains(idTagService)) {
        servicesArr.add(it);
      } else {
        activitiesArr.add(it);
      }
    });
    final activitiesLength = activitiesArr.length;
    final servicesLength = servicesArr.length;
    final activitiesPackage = activitiesArr.map((it) =>
        ActivityModel(
            id: it.id,
            title: it.title,
            thumbnailUrl:
            it.images.length>0 && it.images.first.image.isNotEmpty
                ? it.images.first.image
                : ''
        ),
    ).toList();
    final servicesPackage = servicesArr.map((it) =>
        PackageConstitutionItem(
            title: it.title,
            description: '',
            thumbnailUrl:
            it.images.length>0 && it.images.first.image.isNotEmpty
                ? it.images.first.image
                : ''
        ),
    ).toList();

    var subTitleArr = [];
    if (activitiesLength > 0) {
      final count = formatCount(
          activitiesLength, ['локаций', 'локация', 'локации']);
//      subTitleString = LocalizedString.fromString(count);
      subTitleArr.add('$count');
    }
    if (servicesLength > 0) {
      final count = formatCount(
          servicesLength, ['сервисов', 'сервис', 'сервиса']);
//      subTitleString = LocalizedString.fromString(count);
      subTitleArr.add('$count');
    }
    final countActivities = formatCount(activitiesLength, ['музеям', 'музею',
      'музеям']);
    final titlePackage = 'Доступ к $countActivities и другим локациям';

    final subTitle = subTitleArr.map((it) =>
        SubTitle(it),
    ).toList();

    final citiesPackage = response.cities.map((it) =>
        CityModel(ref: it.id, name: it.title, isSelected: (it.id == response.item.city)),
    ).toList();

    return PackageDetail(
      header: HeaderSection(
        id: response.item.id,
        thumbnailUrl: imageHeader,
        title: response.item.title,
        subTitle: subTitle,
        cities: citiesPackage,
        price: response.item.packet_price,
      ),
      services: PackageConstitutionSection(
        title: 'В составе пакета',
        items: servicesPackage,
      ),
      activities: ActivitiesSection(
        title: titlePackage,
        description: response.item.description,
        filters: tagsPackage,
        activities: activitiesPackage,
      ),
    );
  }

  @override
  EventDetail createEventDetails(EventDetailResponse response) {

    //TODO доделать? Нет в дизайне.
//    final tagsEvent = response.tags.map((it) =>
//        EventTag(
//          ref: it.id,
//          title: it.title,
//        ),
//    ).toList();

    final imagesEvent = response.item.images.map((it) =>
        it.image
    ).skip(1).toList();

    final placesEvent = response.places.map((it) =>
        EventDetailPlacesContent(
          address: it.address,
          coordinates: EventDetailPlacesMap(
              lng: it.coordinates.lng,
              lat: it.coordinates.lat
          ),
        ),
    ).toList();

    String durationEvent = '';
    if(response.item.duration.isNotEmpty) {
      int durationInt = int.tryParse(response.item.duration);
      durationEvent = durationInt != null ? '~' + formatScheduleDuration(durationInt) : '';
    }

    bool validURL = Uri.parse(response.item.link_source).isAbsolute;

    return EventDetail(
      id: response.item.id,
      headerThumbnail: ImageEither.url(response.item.images.first.image),
      title: response.item.title,
      description: response.item.description,
      places: placesEvent,
      images: imagesEvent,
      price: response.item.ticket_price,
      duration: durationEvent,
      link: validURL ? response.item.link_source : '',
//      tags: tagsEvent
    );
  }

  @override
  RestaurantDetail createRestaurantDetails(RestaurantDetailResponse response) {

    final imagesRestaurant = response.item.images.map((it) =>
    it.image
    ).skip(1).toList();

    String durationRestaurant = '';
    if(response.item.avg_time_visit != null) {
      durationRestaurant = '~' + formatScheduleDuration(response.item.avg_time_visit);
    }

    bool validURL = Uri.parse(response.item.site).isAbsolute;

    final cuisinesEvent = response.cuisines.map((it) =>
        RestaurantDetailPlacesCuisines(
          id: it.id,
          title: it.title,
        ),
    ).toList();


    return RestaurantDetail(
      id: response.item.id,
      headerThumbnail: ImageEither.url(response.item.images.first.image),
      title: response.item.title,
      description: response.item.description,
      address: response.item.address,
      coordinates: RestaurantDetailPlacesMap(
          lng: response.item.coordinates.lng,
          lat: response.item.coordinates.lat
      ),
      images: imagesRestaurant,
      price: response.item.bill != null ? '~' + response.item.bill.toString() + ' Р' : '',
      duration: durationRestaurant,
      link: validURL ? response.item.site : '',
      cuisines: cuisinesEvent
//      schedule: []
    );
  }
}

String formatHalfHourTime(Duration duration) {
  print('${duration.inHours}h ${duration.inMinutes}m');
  if (duration == null) {
    return 'No time given';
  }
  int rMin = duration.inMinutes % 60;
  if (rMin < 15) {
    return formatCount(duration.inHours, ['часов', 'час', 'часа', 'часов']);
  } else if (15 < rMin && rMin < 36) {
    return '${duration.inHours},5 часа';
  } else {
    return formatCount(duration.inHours + 1, ['часов', 'час', 'часа', 'часов']);
  }
}

// TODO: Move to another module
class WeeksGroup extends Equatable {
  final String from;
  final String to;

  WeeksGroup(this.from, this.to)
      : assert(from != null),
        assert(to != null);

  @override
  List<Object> get props => [from, to];

  @override
  String toString() => 'WeeksGroup($from - $to)';

  // TODO: Use LocalizedString
  String show() {
    final weekDays = <String, String>{
      'MONDAY': 'Пн',
      'TUESDAY': 'Вт',
      'WEDNESDAY': 'Ср',
      'THURSDAY': 'Чт',
      'FRIDAY': 'Пт',
      'SATURDAY': 'Сб',
      'SUNDAY': 'Вс',
    };

    if (from == to) {
      return weekDays[from];
    } else {
      return '${weekDays[from]} - ${weekDays[to]}';
    }
  }
}

List<WeeksGroup> groupWeekDays(List<String> weekDays, [int length = 1]) {
  final ordered = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];

  final res = <WeeksGroup>[];
  String fromWeek;
  String toWeek;
  int lastWeight;

  pushGroup() {
    final delta = ordered.indexOf(toWeek) - ordered.indexOf(fromWeek);

    if (delta >= length || delta == 0) {
      res.add(WeeksGroup(fromWeek, toWeek));
    } else {
      res.add(WeeksGroup(fromWeek, fromWeek));
      res.add(WeeksGroup(toWeek, toWeek));
    }
  }

  for (int i = 0; i < 7; i += 1) {
    final week = ordered[i];
    final contains = weekDays.contains(week);

    if (lastWeight == null && contains) {
      fromWeek = week;
      toWeek = week;
      lastWeight = i;
      continue;
    }

    if (lastWeight == null) {
      continue;
    }

    if (lastWeight + 1 == i && contains) {
      lastWeight = i;
      toWeek = week;
    } else {
      pushGroup();

      lastWeight = null;
      fromWeek = null;
      toWeek = null;
    }
  }

  if (fromWeek != null) {
    pushGroup();
  }

  return res;
}

String formatTime(List<int> time, [delimiter = ':']) {
  assert(time.length >= 2);

  var hours = time[0].toString();
  var minutes = time[1].toString();

  if (time[1] < 10) {
    minutes = '0$minutes';
  }

  return '$hours$delimiter$minutes';
}

String formatDate(List<int> date, [delimiter = '.']) {
  assert(date.length >= 2);

  var day = date[2].toString();
  var month = date[1].toString();
  var year = date[0].toString();

  if (date[2] < 10) {
    day = '0$day';
  }

  if (date[1] < 10) {
    month = '0$month';
  }

  return '$day$delimiter$month$delimiter$year';
}

String formatScheduleDuration(int durationInMinutes) {
  final hours = (durationInMinutes / 60).floor();
  final minutes = (durationInMinutes - (hours * 60)).floor();

  if (minutes <= 0) {
    return '$hours ч';
  } else {
    return '$hours ч $minutes м';
  }
}

DateTime createDateTimeFromResponse(String date) {
  // NOTE: format is 'dd.MM.yyyy'
  final dateComponents = date.split('.');
  return new DateTime(
    int.parse(dateComponents[2]),
    int.parse(dateComponents[1]),
    int.parse(dateComponents[0]),
  );
}
