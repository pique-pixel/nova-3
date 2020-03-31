import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'generator.dart';

// Example
// @JsonResponse()
// class CmsResponsePlaceScheme {
//   String id;
//   String title;
//   String address;
//   CoordinatesResponse coordinates;
//   List<CoordinatesResponse> coordinatesList;
//   Optional<String> optionalId;
//   Optional<CoordinatesResponse> optionalCoordinates;
//   Optional<List<CoordinatesResponse>> optionalCoordinatesList;
//   EnumDayOfWeek dayOfWeek;
//   Optional<EnumDayOfWeek> optionalDayOfWeek;
//   List<EnumDayOfWeek> listDayOfWeek;
//   Optional<List<EnumDayOfWeek>> optionalListDayOfWeek;
// }

Builder jsonBuilder(BuilderOptions options) =>
    SharedPartBuilder([JsonSerializableGenerator()], 'multiply');
