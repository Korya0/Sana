// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_prayer_times_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserPrayerTimesSettings {
  CalculationMethod get method => throw _privateConstructorUsedError;
  Madhab get madhab => throw _privateConstructorUsedError;
  PrayerAdjustments get adjustments => throw _privateConstructorUsedError;

  /// Create a copy of UserPrayerTimesSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPrayerTimesSettingsCopyWith<UserPrayerTimesSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPrayerTimesSettingsCopyWith<$Res> {
  factory $UserPrayerTimesSettingsCopyWith(
    UserPrayerTimesSettings value,
    $Res Function(UserPrayerTimesSettings) then,
  ) = _$UserPrayerTimesSettingsCopyWithImpl<$Res, UserPrayerTimesSettings>;
  @useResult
  $Res call({
    CalculationMethod method,
    Madhab madhab,
    PrayerAdjustments adjustments,
  });
}

/// @nodoc
class _$UserPrayerTimesSettingsCopyWithImpl<
  $Res,
  $Val extends UserPrayerTimesSettings
>
    implements $UserPrayerTimesSettingsCopyWith<$Res> {
  _$UserPrayerTimesSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPrayerTimesSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? madhab = null,
    Object? adjustments = null,
  }) {
    return _then(
      _value.copyWith(
            method: null == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as CalculationMethod,
            madhab: null == madhab
                ? _value.madhab
                : madhab // ignore: cast_nullable_to_non_nullable
                      as Madhab,
            adjustments: null == adjustments
                ? _value.adjustments
                : adjustments // ignore: cast_nullable_to_non_nullable
                      as PrayerAdjustments,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserPrayerTimesSettingsImplCopyWith<$Res>
    implements $UserPrayerTimesSettingsCopyWith<$Res> {
  factory _$$UserPrayerTimesSettingsImplCopyWith(
    _$UserPrayerTimesSettingsImpl value,
    $Res Function(_$UserPrayerTimesSettingsImpl) then,
  ) = __$$UserPrayerTimesSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    CalculationMethod method,
    Madhab madhab,
    PrayerAdjustments adjustments,
  });
}

/// @nodoc
class __$$UserPrayerTimesSettingsImplCopyWithImpl<$Res>
    extends
        _$UserPrayerTimesSettingsCopyWithImpl<
          $Res,
          _$UserPrayerTimesSettingsImpl
        >
    implements _$$UserPrayerTimesSettingsImplCopyWith<$Res> {
  __$$UserPrayerTimesSettingsImplCopyWithImpl(
    _$UserPrayerTimesSettingsImpl _value,
    $Res Function(_$UserPrayerTimesSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserPrayerTimesSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? method = null,
    Object? madhab = null,
    Object? adjustments = null,
  }) {
    return _then(
      _$UserPrayerTimesSettingsImpl(
        method: null == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as CalculationMethod,
        madhab: null == madhab
            ? _value.madhab
            : madhab // ignore: cast_nullable_to_non_nullable
                  as Madhab,
        adjustments: null == adjustments
            ? _value.adjustments
            : adjustments // ignore: cast_nullable_to_non_nullable
                  as PrayerAdjustments,
      ),
    );
  }
}

/// @nodoc

class _$UserPrayerTimesSettingsImpl extends _UserPrayerTimesSettings {
  const _$UserPrayerTimesSettingsImpl({
    required this.method,
    required this.madhab,
    required this.adjustments,
  }) : super._();

  @override
  final CalculationMethod method;
  @override
  final Madhab madhab;
  @override
  final PrayerAdjustments adjustments;

  @override
  String toString() {
    return 'UserPrayerTimesSettings(method: $method, madhab: $madhab, adjustments: $adjustments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPrayerTimesSettingsImpl &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.madhab, madhab) || other.madhab == madhab) &&
            (identical(other.adjustments, adjustments) ||
                other.adjustments == adjustments));
  }

  @override
  int get hashCode => Object.hash(runtimeType, method, madhab, adjustments);

  /// Create a copy of UserPrayerTimesSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPrayerTimesSettingsImplCopyWith<_$UserPrayerTimesSettingsImpl>
  get copyWith =>
      __$$UserPrayerTimesSettingsImplCopyWithImpl<
        _$UserPrayerTimesSettingsImpl
      >(this, _$identity);
}

abstract class _UserPrayerTimesSettings extends UserPrayerTimesSettings {
  const factory _UserPrayerTimesSettings({
    required final CalculationMethod method,
    required final Madhab madhab,
    required final PrayerAdjustments adjustments,
  }) = _$UserPrayerTimesSettingsImpl;
  const _UserPrayerTimesSettings._() : super._();

  @override
  CalculationMethod get method;
  @override
  Madhab get madhab;
  @override
  PrayerAdjustments get adjustments;

  /// Create a copy of UserPrayerTimesSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPrayerTimesSettingsImplCopyWith<_$UserPrayerTimesSettingsImpl>
  get copyWith => throw _privateConstructorUsedError;
}
