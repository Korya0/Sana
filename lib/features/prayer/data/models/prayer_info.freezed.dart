// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prayer_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PrayerInfo {
  Prayer get prayer => throw _privateConstructorUsedError;
  DateTime get time => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get sunnah => throw _privateConstructorUsedError;

  /// Create a copy of PrayerInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrayerInfoCopyWith<PrayerInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrayerInfoCopyWith<$Res> {
  factory $PrayerInfoCopyWith(
    PrayerInfo value,
    $Res Function(PrayerInfo) then,
  ) = _$PrayerInfoCopyWithImpl<$Res, PrayerInfo>;
  @useResult
  $Res call({Prayer prayer, DateTime time, String name, String? sunnah});
}

/// @nodoc
class _$PrayerInfoCopyWithImpl<$Res, $Val extends PrayerInfo>
    implements $PrayerInfoCopyWith<$Res> {
  _$PrayerInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrayerInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prayer = null,
    Object? time = null,
    Object? name = null,
    Object? sunnah = freezed,
  }) {
    return _then(
      _value.copyWith(
            prayer: null == prayer
                ? _value.prayer
                : prayer // ignore: cast_nullable_to_non_nullable
                      as Prayer,
            time: null == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            sunnah: freezed == sunnah
                ? _value.sunnah
                : sunnah // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PrayerInfoImplCopyWith<$Res>
    implements $PrayerInfoCopyWith<$Res> {
  factory _$$PrayerInfoImplCopyWith(
    _$PrayerInfoImpl value,
    $Res Function(_$PrayerInfoImpl) then,
  ) = __$$PrayerInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Prayer prayer, DateTime time, String name, String? sunnah});
}

/// @nodoc
class __$$PrayerInfoImplCopyWithImpl<$Res>
    extends _$PrayerInfoCopyWithImpl<$Res, _$PrayerInfoImpl>
    implements _$$PrayerInfoImplCopyWith<$Res> {
  __$$PrayerInfoImplCopyWithImpl(
    _$PrayerInfoImpl _value,
    $Res Function(_$PrayerInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrayerInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prayer = null,
    Object? time = null,
    Object? name = null,
    Object? sunnah = freezed,
  }) {
    return _then(
      _$PrayerInfoImpl(
        prayer: null == prayer
            ? _value.prayer
            : prayer // ignore: cast_nullable_to_non_nullable
                  as Prayer,
        time: null == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        sunnah: freezed == sunnah
            ? _value.sunnah
            : sunnah // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PrayerInfoImpl implements _PrayerInfo {
  const _$PrayerInfoImpl({
    required this.prayer,
    required this.time,
    required this.name,
    this.sunnah,
  });

  @override
  final Prayer prayer;
  @override
  final DateTime time;
  @override
  final String name;
  @override
  final String? sunnah;

  @override
  String toString() {
    return 'PrayerInfo(prayer: $prayer, time: $time, name: $name, sunnah: $sunnah)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrayerInfoImpl &&
            (identical(other.prayer, prayer) || other.prayer == prayer) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sunnah, sunnah) || other.sunnah == sunnah));
  }

  @override
  int get hashCode => Object.hash(runtimeType, prayer, time, name, sunnah);

  /// Create a copy of PrayerInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrayerInfoImplCopyWith<_$PrayerInfoImpl> get copyWith =>
      __$$PrayerInfoImplCopyWithImpl<_$PrayerInfoImpl>(this, _$identity);
}

abstract class _PrayerInfo implements PrayerInfo {
  const factory _PrayerInfo({
    required final Prayer prayer,
    required final DateTime time,
    required final String name,
    final String? sunnah,
  }) = _$PrayerInfoImpl;

  @override
  Prayer get prayer;
  @override
  DateTime get time;
  @override
  String get name;
  @override
  String? get sunnah;

  /// Create a copy of PrayerInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrayerInfoImplCopyWith<_$PrayerInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
