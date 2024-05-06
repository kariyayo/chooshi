import 'package:freezed_annotation/freezed_annotation.dart';

part 'month.freezed.dart';

@freezed
class Month with _$Month {
  const factory Month({
    required int year,
    required int month,
  }) = _Month;

  const Month._();

  static const List<String> _labels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String get label => _labels[month - 1];
}
