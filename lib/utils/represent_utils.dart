import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension FileSizeExtension on int {
  double get syzeInMb => this / 1000000;

  String get fileSizeRepresentInMb => '${syzeInMb.toStringAsFixed(2)} Mb';

  String fileSizeOfTotalRepresentInMb(int total) =>
      '$fileSizeRepresentInMb / ${total.fileSizeRepresentInMb}';

  String fileSizeOfTotalRepresentInPercent(int total) =>
      total == 0 ? '0%' : '${((this / total) * 100).round()}%';
}

extension DateTimeFormatterExtension on DateTime {
  static final defaultFormat = DateFormat('MMM dd, yyyy HH:mm', 'en');
  static final fullFormat = DateFormat('MMM dd, yyyy HH:mm', 'en');
  static final dateOnlyFormat = DateFormat('MMM dd, yyyy', 'en');

  static final yearFormat = DateFormat('yyyy', 'ru');
  static final monthFormat = DateFormat('MMMM', 'ru');
  static final dateFormat = DateFormat('dd', 'ru');

  String get localRepresent => defaultFormat.format(toLocal());

  String get fullLocalRepresent => fullFormat.format(toLocal());

  String get dateOnlyLocalRepresent => dateOnlyFormat.format(toLocal());

  String get yearRepresent => yearFormat.format(toLocal());
  String get monthRepresent => monthFormat.format(toLocal());
  String get dayRepresent => dateFormat.format(toLocal());

  String toJson() => toIso8601String();

  DateTime fromLocalRepresent({required String dateRepresent}) =>
      defaultFormat.parse(dateRepresent);

  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

  DateTime applied(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }
}
