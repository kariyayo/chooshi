import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag_detail.freezed.dart';
part 'tag_detail.g.dart';

@freezed
class TagDetail with _$TagDetail {
  @JsonSerializable(explicitToJson: true)
  const factory TagDetail({
    required String label,
    required double count,
    required double mean,
    required Map<int, int> ratings,
  }) = _TagDetail;

  const TagDetail._();

  factory TagDetail.fromJson(Map<String, dynamic> json) => _$TagDetailFromJson(json);

  TagDetail add(int rating) {
    final newCount = count + 1;
    final newMean = (mean * count + rating) / newCount;
    final newRatings = {...ratings};
    newRatings.update(
      rating,
      (value) => value + 1,
      ifAbsent: () => 1,
    );
    return copyWith(count: newCount, mean: newMean, ratings: newRatings);
  }

  TagDetail remove(int rating) {
    final newCount = count - 1;
    if (newCount == 0) {
      return this;
    }
    final newMean = (mean * count - rating) / newCount;
    final newRatings = {...ratings};
    newRatings.update(
      rating,
      (value) => value - 1 < 0 ? 0 : value - 1,
      ifAbsent: () => 0,
    );
    return copyWith(count: newCount, mean: newMean, ratings: newRatings);
  }
}
