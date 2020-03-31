import 'package:intl/intl.dart';

final DateFormat _simpleFormat = DateFormat("dd.MMM.yyyy");
final DateFormat _isoFormat = DateFormat("yyyy-MM-dd");

String simpleFormat(DateTime dateTime) {
  return _simpleFormat.format(dateTime);
}

String isoDateFormat(DateTime dateTime) {
  return _isoFormat.format(dateTime);
}
