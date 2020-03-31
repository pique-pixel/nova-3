import 'package:equatable/equatable.dart';

class PackageItemModel extends Equatable {
  final String ref;
  final String title;
  final String thumbnailUrl;
  final String type;
  final String untilDate;
  final bool soonWillEnd;
  final bool openQRCode;

  PackageItemModel({
    this.ref,
    this.title,
    this.thumbnailUrl,
    this.type,
    this.untilDate,
    this.soonWillEnd,
    this.openQRCode,
  });

  @override
  List<Object> get props => [
        ref,
        title,
        thumbnailUrl,
        type,
        untilDate,
        soonWillEnd,
        openQRCode,
      ];
}
