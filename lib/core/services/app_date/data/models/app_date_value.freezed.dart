// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_date_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AppDateValue {
  DateTime get gregorian => throw _privateConstructorUsedError;
  HijriCalendar get hijri => throw _privateConstructorUsedError;
  int get adjustment => throw _privateConstructorUsedError;

  /// Create a copy of AppDateValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppDateValueCopyWith<AppDateValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppDateValueCopyWith<$Res> {
  factory $AppDateValueCopyWith(
    AppDateValue value,
    $Res Function(AppDateValue) then,
  ) = _$AppDateValueCopyWithImpl<$Res, AppDateValue>;
  @useResult
  $Res call({DateTime gregorian, HijriCalendar hijri, int adjustment});
}

/// @nodoc
class _$AppDateValueCopyWithImpl<$Res, $Val extends AppDateValue>
    implements $AppDateValueCopyWith<$Res> {
  _$AppDateValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppDateValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gregorian = null,
    Object? hijri = null,
    Object? adjustment = null,
  }) {
    return _then(
      _value.copyWith(
            gregorian: null == gregorian
                ? _value.gregorian
                : gregorian // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            hijri: null == hijri
                ? _value.hijri
                : hijri // ignore: cast_nullable_to_non_nullable
                      as HijriCalendar,
            adjustment: null == adjustment
                ? _value.adjustment
                : adjustment // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppDateValueImplCopyWith<$Res>
    implements $AppDateValueCopyWith<$Res> {
  factory _$$AppDateValueImplCopyWith(
    _$AppDateValueImpl value,
    $Res Function(_$AppDateValueImpl) then,
  ) = __$$AppDateValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime gregorian, HijriCalendar hijri, int adjustment});
}

/// @nodoc
class __$$AppDateValueImplCopyWithImpl<$Res>
    extends _$AppDateValueCopyWithImpl<$Res, _$AppDateValueImpl>
    implements _$$AppDateValueImplCopyWith<$Res> {
  __$$AppDateValueImplCopyWithImpl(
    _$AppDateValueImpl _value,
    $Res Function(_$AppDateValueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppDateValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gregorian = null,
    Object? hijri = null,
    Object? adjustment = null,
  }) {
    return _then(
      _$AppDateValueImpl(
        gregorian: null == gregorian
            ? _value.gregorian
            : gregorian // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        hijri: null == hijri
            ? _value.hijri
            : hijri // ignore: cast_nullable_to_non_nullable
                  as HijriCalendar,
        adjustment: null == adjustment
            ? _value.adjustment
            : adjustment // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$AppDateValueImpl implements _AppDateValue {
  const _$AppDateValueImpl({
    required this.gregorian,
    required this.hijri,
    required this.adjustment,
  });

  @override
  final DateTime gregorian;
  @override
  final HijriCalendar hijri;
  @override
  final int adjustment;

  @override
  String toString() {
    return 'AppDateValue(gregorian: $gregorian, hijri: $hijri, adjustment: $adjustment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppDateValueImpl &&
            (identical(other.gregorian, gregorian) ||
                other.gregorian == gregorian) &&
            (identical(other.hijri, hijri) || other.hijri == hijri) &&
            (identical(other.adjustment, adjustment) ||
                other.adjustment == adjustment));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gregorian, hijri, adjustment);

  /// Create a copy of AppDateValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppDateValueImplCopyWith<_$AppDateValueImpl> get copyWith =>
      __$$AppDateValueImplCopyWithImpl<_$AppDateValueImpl>(this, _$identity);
}

abstract class _AppDateValue implements AppDateValue {
  const factory _AppDateValue({
    required final DateTime gregorian,
    required final HijriCalendar hijri,
    required final int adjustment,
  }) = _$AppDateValueImpl;

  @override
  DateTime get gregorian;
  @override
  HijriCalendar get hijri;
  @override
  int get adjustment;

  /// Create a copy of AppDateValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppDateValueImplCopyWith<_$AppDateValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
