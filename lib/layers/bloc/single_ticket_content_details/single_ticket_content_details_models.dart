import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:optional/optional.dart';
import 'package:rp_mobile/containers/image.dart';
import 'package:rp_mobile/locale/localized_string.dart';

class SingleTicketContentDetails extends Equatable {
  final ImageEither headerThumbnail;
  final LocalizedString title;
  final List<LocalizedString> tags;
  final List<SingleTicketContentSection> sections;

  SingleTicketContentDetails({
    @required this.headerThumbnail,
    @required this.title,
    @required this.tags,
    @required this.sections,
  })  : assert(headerThumbnail != null),
        assert(title != null),
        assert(tags != null),
        assert(sections != null);

  @override
  List<Object> get props => [
        headerThumbnail,
        title,
        tags,
        sections,
      ];
}

abstract class SingleTicketContentSection extends Equatable {}

enum SingleTicketContentSectionIcon {
  calendar,
  disabled,
}

class SingleTicketContentIconInfoBarSection extends SingleTicketContentSection {
  final SingleTicketContentSectionIcon icon;
  final LocalizedString text;

  SingleTicketContentIconInfoBarSection({
    @required this.icon,
    @required this.text,
  })  : assert(icon != null),
        assert(text != null);

  @override
  List<Object> get props => [icon, text];
}

class SingleTicketContentIconInfoSpoilerBarSection
    extends SingleTicketContentSection {
  final SingleTicketContentSectionIcon icon;
  final LocalizedString text;
  final LocalizedString spoilerText;

  SingleTicketContentIconInfoSpoilerBarSection({
    @required this.icon,
    @required this.text,
    @required this.spoilerText,
  })  : assert(icon != null),
        assert(text != null),
        assert(spoilerText != null);

  @override
  List<Object> get props => [icon, text, spoilerText];
}

class SingleTicketContentInfoBarSection extends SingleTicketContentSection {
  final LocalizedString text;

  SingleTicketContentInfoBarSection({
    @required this.text,
  }) : assert(text != null);

  @override
  List<Object> get props => [text];
}

class SingleTicketContentInfoBarTariffSection extends SingleTicketContentSection {
  final LocalizedString text;
  final LocalizedString time;
  final LocalizedString price;

  SingleTicketContentInfoBarTariffSection({
    @required this.time,
    @required this.text,
    @required this.price,
  })  : assert(text != null),
        assert(time != null),
        assert(price != null);

  @override
  List<Object> get props => [time, price, text];
}

class SingleTicketContentMapSection extends SingleTicketContentSection {
  final double latitude;
  final double longitude;

  SingleTicketContentMapSection({
    @required this.latitude,
    @required this.longitude,
  })  : assert(latitude != null),
        assert(longitude != null);

  @override
  List<Object> get props => [latitude, longitude];
}

class SingleTicketContentAddressSection extends SingleTicketContentSection {
  final Optional<LocalizedString> address;
  final Optional<String> webSite;

  SingleTicketContentAddressSection({
    @required this.address,
    @required this.webSite,
  })  : assert(address != null),
        assert(webSite != null);

  @override
  List<Object> get props => [address, webSite];
}

class SingleTicketContentDescSection extends SingleTicketContentSection {
  final LocalizedString text;

  SingleTicketContentDescSection({
    @required this.text,
  }) : assert(text != null);

  @override
  List<Object> get props => [text];
}
