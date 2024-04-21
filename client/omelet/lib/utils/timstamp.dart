import 'package:intl/intl.dart';

String timestampToTime(int timestamp, String format) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  DateFormat dateFormat = DateFormat(format);
  return dateFormat.format(dateTime);
}
