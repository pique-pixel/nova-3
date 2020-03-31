import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:optional/optional_internal.dart';
import 'package:rp_mobile/containers/image.dart';
import 'package:rp_mobile/locale/localized_string.dart';

class TicketItemModel extends Equatable {
  final String ref;
  final LocalizedString title;
  final ImageEither thumbnail;

  TicketItemModel({
    @required this.ref,
    @required this.title,
    @required this.thumbnail,
  })  : assert(ref != null),
        assert(title != null),
        assert(thumbnail != null);

  @override
  List<Object> get props => [
        ref,
        title,
        thumbnail,
      ];
}

enum TicketType {
  transport,
  museum,
  package,
}

class TicketInfoModel extends Equatable {
  final LocalizedString title;
  final LocalizedString subTitle;
  final LocalizedString hint;
  final Optional<String> qrCode;
  final Optional<ImageEither> thumbnail;

  TicketInfoModel({
    @required this.title,
    @required this.subTitle,
    @required this.qrCode,
    @required this.hint,
    @required this.thumbnail,
  })  : assert(title != null),
        assert(subTitle != null),
        assert(qrCode != null),
        assert(hint != null),
        assert(thumbnail != null);

  @override
  List<Object> get props => [
        title,
        subTitle,
        qrCode,
        hint,
        thumbnail,
      ];
}
