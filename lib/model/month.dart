import 'package:freezed_annotation/freezed_annotation.dart';

part 'month.freezed.dart';

@freezed
class Month with _$Month {
  const factory Month({
    required int year,
    required int month,
  }) = _Month;
}
