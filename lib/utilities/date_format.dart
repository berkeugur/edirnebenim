import 'package:intl/intl.dart';

class AppDateFormat {
  static DateFormat? dateFormat;
  static DateFormat? timeFormat;

  String dateFormatText(DateTime? dateTime) =>
      AppDateFormat.dateFormat?.format(dateTime ?? DateTime(2022)) ?? '';
}
