// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prayer_time_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PrayerTimeStatus _$PrayerTimeStatusFromJson(Map<String, dynamic> json) {
  return _PrayerTimeStatus.fromJson(json);
}

/// @nodoc
mixin _$PrayerTimeStatus {
  String get id => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;

  /// Serializes this PrayerTimeStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrayerTimeStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrayerTimeStatusCopyWith<PrayerTimeStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrayerTimeStatusCopyWith<$Res> {
  factory $PrayerTimeStatusCopyWith(
    PrayerTimeStatus value,
    $Res Function(PrayerTimeStatus) then,
  ) = _$PrayerTimeStatusCopyWithImpl<$Res, PrayerTimeStatus>;
  @useResult
  $Res call({String id, String status, String description, String? source});
}

/// @nodoc
class _$PrayerTimeStatusCopyWithImpl<$Res, $Val extends PrayerTimeStatus>
    implements $PrayerTimeStatusCopyWith<$Res> {
  _$PrayerTimeStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrayerTimeStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? description = null,
    Object? source = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            source: freezed == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PrayerTimeStatusImplCopyWith<$Res>
    implements $PrayerTimeStatusCopyWith<$Res> {
  factory _$$PrayerTimeStatusImplCopyWith(
    _$PrayerTimeStatusImpl value,
    $Res Function(_$PrayerTimeStatusImpl) then,
  ) = __$$PrayerTimeStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String status, String description, String? source});
}

/// @nodoc
class __$$PrayerTimeStatusImplCopyWithImpl<$Res>
    extends _$PrayerTimeStatusCopyWithImpl<$Res, _$PrayerTimeStatusImpl>
    implements _$$PrayerTimeStatusImplCopyWith<$Res> {
  __$$PrayerTimeStatusImplCopyWithImpl(
    _$PrayerTimeStatusImpl _value,
    $Res Function(_$PrayerTimeStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrayerTimeStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? description = null,
    Object? source = freezed,
  }) {
    return _then(
      _$PrayerTimeStatusImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        source: freezed == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PrayerTimeStatusImpl implements _PrayerTimeStatus {
  const _$PrayerTimeStatusImpl({
    required this.id,
    required this.status,
    required this.description,
    this.source,
  });

  factory _$PrayerTimeStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrayerTimeStatusImplFromJson(json);

  @override
  final String id;
  @override
  final String status;
  @override
  final String description;
  @override
  final String? source;

  @override
  String toString() {
    return 'PrayerTimeStatus(id: $id, status: $status, description: $description, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrayerTimeStatusImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.source, source) || other.source == source));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, status, description, source);

  /// Create a copy of PrayerTimeStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrayerTimeStatusImplCopyWith<_$PrayerTimeStatusImpl> get copyWith =>
      __$$PrayerTimeStatusImplCopyWithImpl<_$PrayerTimeStatusImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PrayerTimeStatusImplToJson(this);
  }
}

abstract class _PrayerTimeStatus implements PrayerTimeStatus {
  const factory _PrayerTimeStatus({
    required final String id,
    required final String status,
    required final String description,
    final String? source,
  }) = _$PrayerTimeStatusImpl;

  factory _PrayerTimeStatus.fromJson(Map<String, dynamic> json) =
      _$PrayerTimeStatusImpl.fromJson;

  @override
  String get id;
  @override
  String get status;
  @override
  String get description;
  @override
  String? get source;

  /// Create a copy of PrayerTimeStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrayerTimeStatusImplCopyWith<_$PrayerTimeStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
