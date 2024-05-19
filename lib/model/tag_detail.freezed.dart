// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TagDetail _$TagDetailFromJson(Map<String, dynamic> json) {
  return _TagDetail.fromJson(json);
}

/// @nodoc
mixin _$TagDetail {
  String get label => throw _privateConstructorUsedError;
  double get count => throw _privateConstructorUsedError;
  double get mean => throw _privateConstructorUsedError;
  Map<int, int> get ratings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TagDetailCopyWith<TagDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagDetailCopyWith<$Res> {
  factory $TagDetailCopyWith(TagDetail value, $Res Function(TagDetail) then) =
      _$TagDetailCopyWithImpl<$Res, TagDetail>;
  @useResult
  $Res call({String label, double count, double mean, Map<int, int> ratings});
}

/// @nodoc
class _$TagDetailCopyWithImpl<$Res, $Val extends TagDetail>
    implements $TagDetailCopyWith<$Res> {
  _$TagDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? count = null,
    Object? mean = null,
    Object? ratings = null,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as double,
      mean: null == mean
          ? _value.mean
          : mean // ignore: cast_nullable_to_non_nullable
              as double,
      ratings: null == ratings
          ? _value.ratings
          : ratings // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TagDetailImplCopyWith<$Res>
    implements $TagDetailCopyWith<$Res> {
  factory _$$TagDetailImplCopyWith(
          _$TagDetailImpl value, $Res Function(_$TagDetailImpl) then) =
      __$$TagDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, double count, double mean, Map<int, int> ratings});
}

/// @nodoc
class __$$TagDetailImplCopyWithImpl<$Res>
    extends _$TagDetailCopyWithImpl<$Res, _$TagDetailImpl>
    implements _$$TagDetailImplCopyWith<$Res> {
  __$$TagDetailImplCopyWithImpl(
      _$TagDetailImpl _value, $Res Function(_$TagDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? count = null,
    Object? mean = null,
    Object? ratings = null,
  }) {
    return _then(_$TagDetailImpl(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as double,
      mean: null == mean
          ? _value.mean
          : mean // ignore: cast_nullable_to_non_nullable
              as double,
      ratings: null == ratings
          ? _value._ratings
          : ratings // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$TagDetailImpl extends _TagDetail {
  const _$TagDetailImpl(
      {required this.label,
      required this.count,
      required this.mean,
      required final Map<int, int> ratings})
      : _ratings = ratings,
        super._();

  factory _$TagDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$TagDetailImplFromJson(json);

  @override
  final String label;
  @override
  final double count;
  @override
  final double mean;
  final Map<int, int> _ratings;
  @override
  Map<int, int> get ratings {
    if (_ratings is EqualUnmodifiableMapView) return _ratings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_ratings);
  }

  @override
  String toString() {
    return 'TagDetail(label: $label, count: $count, mean: $mean, ratings: $ratings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TagDetailImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.mean, mean) || other.mean == mean) &&
            const DeepCollectionEquality().equals(other._ratings, _ratings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, label, count, mean,
      const DeepCollectionEquality().hash(_ratings));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TagDetailImplCopyWith<_$TagDetailImpl> get copyWith =>
      __$$TagDetailImplCopyWithImpl<_$TagDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TagDetailImplToJson(
      this,
    );
  }
}

abstract class _TagDetail extends TagDetail {
  const factory _TagDetail(
      {required final String label,
      required final double count,
      required final double mean,
      required final Map<int, int> ratings}) = _$TagDetailImpl;
  const _TagDetail._() : super._();

  factory _TagDetail.fromJson(Map<String, dynamic> json) =
      _$TagDetailImpl.fromJson;

  @override
  String get label;
  @override
  double get count;
  @override
  double get mean;
  @override
  Map<int, int> get ratings;
  @override
  @JsonKey(ignore: true)
  _$$TagDetailImplCopyWith<_$TagDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
