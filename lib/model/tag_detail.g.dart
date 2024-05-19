// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TagDetailImpl _$$TagDetailImplFromJson(Map<String, dynamic> json) =>
    _$TagDetailImpl(
      label: json['label'] as String,
      count: (json['count'] as num).toDouble(),
      mean: (json['mean'] as num).toDouble(),
      ratings: (json['ratings'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), (e as num).toInt()),
      ),
    );

Map<String, dynamic> _$$TagDetailImplToJson(_$TagDetailImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'count': instance.count,
      'mean': instance.mean,
      'ratings': instance.ratings.map((k, e) => MapEntry(k.toString(), e)),
    };
