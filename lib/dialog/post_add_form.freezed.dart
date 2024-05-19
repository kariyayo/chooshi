// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_add_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PostForm {
  int? get rating => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PostFormCopyWith<PostForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostFormCopyWith<$Res> {
  factory $PostFormCopyWith(PostForm value, $Res Function(PostForm) then) =
      _$PostFormCopyWithImpl<$Res, PostForm>;
  @useResult
  $Res call({int? rating, List<String>? tags});
}

/// @nodoc
class _$PostFormCopyWithImpl<$Res, $Val extends PostForm>
    implements $PostFormCopyWith<$Res> {
  _$PostFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rating = freezed,
    Object? tags = freezed,
  }) {
    return _then(_value.copyWith(
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostFormImplCopyWith<$Res>
    implements $PostFormCopyWith<$Res> {
  factory _$$PostFormImplCopyWith(
          _$PostFormImpl value, $Res Function(_$PostFormImpl) then) =
      __$$PostFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? rating, List<String>? tags});
}

/// @nodoc
class __$$PostFormImplCopyWithImpl<$Res>
    extends _$PostFormCopyWithImpl<$Res, _$PostFormImpl>
    implements _$$PostFormImplCopyWith<$Res> {
  __$$PostFormImplCopyWithImpl(
      _$PostFormImpl _value, $Res Function(_$PostFormImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rating = freezed,
    Object? tags = freezed,
  }) {
    return _then(_$PostFormImpl(
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc

class _$PostFormImpl extends _PostForm {
  const _$PostFormImpl({this.rating, final List<String>? tags})
      : _tags = tags,
        super._();

  @override
  final int? rating;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PostForm(rating: $rating, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostFormImpl &&
            (identical(other.rating, rating) || other.rating == rating) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, rating, const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PostFormImplCopyWith<_$PostFormImpl> get copyWith =>
      __$$PostFormImplCopyWithImpl<_$PostFormImpl>(this, _$identity);
}

abstract class _PostForm extends PostForm {
  const factory _PostForm({final int? rating, final List<String>? tags}) =
      _$PostFormImpl;
  const _PostForm._() : super._();

  @override
  int? get rating;
  @override
  List<String>? get tags;
  @override
  @JsonKey(ignore: true)
  _$$PostFormImplCopyWith<_$PostFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
