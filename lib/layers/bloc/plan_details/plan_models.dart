import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:optional/optional.dart';
import 'package:rp_mobile/containers/image.dart';
import 'package:rp_mobile/locale/localized_string.dart';

class PlanDetails extends Equatable {
  final String ref;
  final Header header;
  final Body body;

  PlanDetails({
    @required this.ref,
    @required this.header,
    @required this.body,
  })  : assert(ref != null),
        assert(header != null),
        assert(body != null);

  @override
  List<Object> get props => [ref, header, body];

  PlanDetails copyWith({
    String ref,
    Header header,
    Body body,
  }) {
    return PlanDetails(
      ref: ref ?? this.ref,
      header: header ?? this.header,
      body: body ?? this.body,
    );
  }
}

class Header extends Equatable {
  final LocalizedString title;
  final LocalizedString fromDate;
  final LocalizedString toDate;
  final List<PlanDate> dates;
  final Optional<String> selectedDateRef;

  Header({
    @required this.title,
    @required this.fromDate,
    @required this.toDate,
    @required this.dates,
    @required this.selectedDateRef,
  })  : assert(title != null),
        assert(fromDate != null),
        assert(toDate != null),
        assert(dates != null);

  Header copyWith({
    LocalizedString title,
    LocalizedString fromDate,
    LocalizedString toDate,
    List<PlanDate> dates,
    Optional<String> selectedDateRef,
  }) {
    return Header(
      title: title ?? this.title,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      dates: dates ?? this.dates,
      selectedDateRef: selectedDateRef ?? this.selectedDateRef,
    );
  }

  @override
  List<Object> get props => [
        title,
        fromDate,
        toDate,
        dates,
        selectedDateRef,
      ];
}

class PlanDate extends Equatable {
  final String ref;
  final LocalizedString weekDayShort;
  final int day;

  PlanDate({
    @required this.ref,
    @required this.weekDayShort,
    @required this.day,
  })  : assert(ref != null),
        assert(weekDayShort != null),
        assert(day != null);

  PlanDate copyWith({
    String ref,
    LocalizedString weekDayShort,
    int day,
  }) {
    return PlanDate(
      ref: ref ?? this.ref,
      weekDayShort: weekDayShort ?? this.weekDayShort,
      day: day ?? this.day,
    );
  }

  @override
  List<Object> get props => [ref, weekDayShort, day];
}

class Body extends Equatable {
  final LocalizedString spotsHint;
  final List<Ticket> tickets;
  final List<Spot> spots;
  final List<Spot> spotsNoDate;

  Body({
    @required this.spotsHint,
    @required this.tickets,
    @required this.spots,
    @required this.spotsNoDate,
  })  : assert(spotsHint != null),
        assert(tickets != null),
        assert(spots != null);

  Body copyWith({
    LocalizedString spotsHint,
    List<Ticket> tickets,
    List<Spot> spots,
  }) {
    return Body(
      spotsHint: spotsHint ?? this.spotsHint,
      tickets: tickets ?? this.tickets,
      spots: spots ?? this.spots,
      spotsNoDate: spotsNoDate ?? this.spotsNoDate,
    );
  }

  @override
  List<Object> get props => [spotsHint, tickets, spots];
}

enum ActivityType {
  event,
  restaurant,
}

class Spot extends Equatable {
  final String ref;
  final ActivityType type;
  final ImageEither thumbnail;
  final LocalizedString title;
  final LocalizedString hint;
  final LocalizedString address;

  Spot({
    @required this.ref,
    @required this.thumbnail,
    @required this.title,
    @required this.hint,
    @required this.address,
    this.type,
  })  : assert(ref != null),
        assert(ActivityType != null),
        assert(thumbnail != null),
        assert(title != null),
        assert(hint != null);

  Spot copyWith({
    String ref,
    ImageEither thumbnail,
    LocalizedString title,
    LocalizedString hint,
    ActivityType type,
  }) {
    return Spot(
      ref: ref ?? this.ref,
      thumbnail: thumbnail ?? this.thumbnail,
      title: title ?? this.title,
      hint: hint ?? this.hint,
      address: address ?? this.address,
      type: type ?? this.type,
    );
  }

  @override
  List<Object> get props => [ref, thumbnail, title, hint, address];
}

class Ticket extends Equatable {
  final String ref;
  final LocalizedString title;
  final LocalizedString date;

  Ticket({
    @required this.ref,
    @required this.title,
    @required this.date,
  })  : assert(ref != null),
        assert(title != null),
        assert(date != null);

  Ticket copyWith({
    String ref,
    LocalizedString title,
    LocalizedString date,
  }) {
    return Ticket(
      ref: ref ?? this.ref,
      title: title ?? this.title,
      date: date ?? this.date,
    );
  }

  @override
  List<Object> get props => [ref, title, date];
}
