import 'package:equatable/equatable.dart';
import 'package:optional/optional.dart';
import 'package:rp_mobile/containers/image.dart';
import 'package:rp_mobile/locale/localized_string.dart';

class PlanItemModel extends Equatable {
  final String ref;
  final Optional<ImageEither> thumbnail;
  final LocalizedString title;
  final LocalizedString subTitle;

  PlanItemModel({
    this.ref,
    this.thumbnail,
    this.title,
    this.subTitle,
  })  : assert(ref != null),
        assert(thumbnail != null),
        assert(title != null),
        assert(subTitle != null);

  @override
  List<Object> get props => [
        thumbnail,
        title,
        subTitle,
      ];
}
