// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prayer_state_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PrayerStateResult {
  /// The current prayer (if any).
  Prayer get current => throw _privateConstructorUsedError;

  /// The next prayer.
  Prayer get next => throw _privateConstructorUsedError;

  /// The active prayer for display purposes (usually [current] if not none, else [next]).
  Prayer get activePrayer => throw _privateConstructorUsedError;

  /// The spiritual/virtue status ID for the current time window.
  String get statusId => throw _privateConstructorUsedError;

  /// Create a copy of PrayerStateResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrayerStateResultCopyWith<PrayerStateResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrayerStateResultCopyWith<$Res> {
  factory $PrayerStateResultCopyWith(
    PrayerStateResult value,
    $Res Function(PrayerStateResult) then,
  ) = _$PrayerStateResultCopyWithImpl<$Res, PrayerStateResult>;
  @useResult
  $Res call({
    Prayer current,
    Prayer next,
    Prayer activePrayer,
    String statusId,
  });
}

/// @nodoc
class _$PrayerStateResultCopyWithImpl<$Res, $Val extends PrayerStateResult>
    implements $PrayerStateResultCopyWith<$Res> {
  _$PrayerStateResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrayerStateResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? next = null,
    Object? activePrayer = null,
    Object? statusId = null,
  }) {
    return _then(
      _value.copyWith(
            current: null == current
                ? _value.current
                : current // ignore: cast_nullable_to_non_nullable
                      as Prayer,
            next: null == next
                ? _value.next
                : next // ignore: cast_nullable_to_non_nullable
                      as Prayer,
            activePrayer: null == activePrayer
                ? _value.activePrayer
                : activePrayer // ignore: cast_nullable_to_non_nullable
                      as Prayer,
            statusId: null == statusId
                ? _value.statusId
                : statusId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PrayerStateResultImplCopyWith<$Res>
    implements $PrayerStateResultCopyWith<$Res> {
  factory _$$PrayerStateResultImplCopyWith(
    _$PrayerStateResultImpl value,
    $Res Function(_$PrayerStateResultImpl) then,
  ) = __$$PrayerStateResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Prayer current,
    Prayer next,
    Prayer activePrayer,
    String statusId,
  });
}

/// @nodoc
class __$$PrayerStateResultImplCopyWithImpl<$Res>
    extends _$PrayerStateResultCopyWithImpl<$Res, _$PrayerStateResultImpl>
    implements _$$PrayerStateResultImplCopyWith<$Res> {
  __$$PrayerStateResultImplCopyWithImpl(
    _$PrayerStateResultImpl _value,
    $Res Function(_$PrayerStateResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrayerStateResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? next = null,
    Object? activePrayer = null,
    Object? statusId = null,
  }) {
    return _then(
      _$PrayerStateResultImpl(
        current: null == current
            ? _value.current
            : current // ignore: cast_nullable_to_non_nullable
                  as Prayer,
        next: null == next
            ? _value.next
            : next // ignore: cast_nullable_to_non_nullable
                  as Prayer,
        activePrayer: null == activePrayer
            ? _value.activePrayer
            : activePrayer // ignore: cast_nullable_to_non_nullable
                  as Prayer,
        statusId: null == statusId
            ? _value.statusId
            : statusId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PrayerStateResultImpl implements _PrayerStateResult {
  const _$PrayerStateResultImpl({
    required this.current,
    required this.next,
    required this.activePrayer,
    required this.statusId,
  });

  /// The current prayer (if any).
  @override
  final Prayer current;

  /// The next prayer.
  @override
  final Prayer next;

  /// The active prayer for display purposes (usually [current] if not none, else [next]).
  @override
  final Prayer activePrayer;

  /// The spiritual/virtue status ID for the current time window.
  @override
  final String statusId;

  @override
  String toString() {
    return 'PrayerStateResult(current: $current, next: $next, activePrayer: $activePrayer, statusId: $statusId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrayerStateResultImpl &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.activePrayer, activePrayer) ||
                other.activePrayer == activePrayer) &&
            (identical(other.statusId, statusId) ||
                other.statusId == statusId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, current, next, activePrayer, statusId);

  /// Create a copy of PrayerStateResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrayerStateResultImplCopyWith<_$PrayerStateResultImpl> get copyWith =>
      __$$PrayerStateResultImplCopyWithImpl<_$PrayerStateResultImpl>(
        this,
        _$identity,
      );
}

abstract class _PrayerStateResult implements PrayerStateResult {
  const factory _PrayerStateResult({
    required final Prayer current,
    required final Prayer next,
    required final Prayer activePrayer,
    required final String statusId,
  }) = _$PrayerStateResultImpl;

  /// The current prayer (if any).
  @override
  Prayer get current;

  /// The next prayer.
  @override
  Prayer get next;

  /// The active prayer for display purposes (usually [current] if not none, else [next]).
  @override
  Prayer get activePrayer;

  /// The spiritual/virtue status ID for the current time window.
  @override
  String get statusId;

  /// Create a copy of PrayerStateResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrayerStateResultImplCopyWith<_$PrayerStateResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
