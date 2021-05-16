import 'package:date_format/date_format.dart';

String getFormattedDate(DateTime dt) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
  final aDate = DateTime(dt.year, dt.month, dt.day);
  if (aDate == today) {
    return "Today " + formatDate(dt, [hh, ':', nn, ' ', am]);
  } else if (aDate == yesterday) {
    return "Yesterday " + formatDate(dt, [hh, ':', nn, ' ', am]);
  } else {
    return formatDate(dt, [d, '-', M, '-', yy]);
  }
}
