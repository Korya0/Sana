// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_content_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DailyContentState {
  DailyContentStatus get status => throw _privateConstructorUsedError;
  DailyContentModel? get dailyHadith => throw _privateConstructorUsedError;
  DailyContentModel? get dailySunnah => throw _privateConstructorUsedError;
  AsmaulHusnaModel? get dailyAsma => throw _privateConstructorUsedError;
  bool get hadithViewedToday => throw _privateConstructorUsedError;
  bool get sunnahViewedToday => throw _privateConstructorUsedError;
  bool get isHadithFavorite => throw _privateConstructorUsedError;
  bool get isSunnahFavorite => throw _privateConstructorUsedError;

  /// Create a copy of DailyContentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyContentStateCopyWith<DailyContentState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyContentStateCopyWith<$Res> {
  factory $DailyContentStateCopyWith(
    DailyContentState value,
    $Res Function(DailyContentState) then,
  ) = _$DailyContentStateCopyWithImpl<$Res, DailyContentState>;
  @useResult
  $Res call({
    DailyContentStatus status,
    DailyContentModel? dailyHadith,
    DailyContentModel? dailySunnah,
    AsmaulHusnaModel? dailyAsma,
    bool hadithViewedToday,
    bool sunnahViewedToday,
    bool isHadithFavorite,
    bool isSunnahFavorite,
  });

  $DailyContentModelCopyWith<$Res>? get dailyHadith;
  $DailyContentModelCopyWith<$Res>? get dailySunnah;
  $AsmaulHusnaModelCopyWith<$Res>? get dailyAsma;
}

/// @nodoc
class _$DailyContentStateCopyWithImpl<$Res, $Val extends DailyContentState>
    implements $DailyContentStateCopyWith<$Res> {
  _$DailyContentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyContentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? dailyHadith = freezed,
    Object? dailySunnah = freezed,
    Object? dailyAsma = freezed,
    Object? hadithViewedToday = null,
    Object? sunnahViewedToday = null,
    Object? isHadithFavorite = null,
    Object? isSunnahFavorite = null,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as DailyContentStatus,
            dailyHadith: freezed == dailyHadith
                ? _value.dailyHadith
                : dailyHadith // ignore: cast_nullable_to_non_nullable
                      as DailyContentModel?,
            dailySunnah: freezed == dailySunnah
                ? _value.dailySunnah
                : dailySunnah // ignore: cast_nullable_to_non_nullable
                      as DailyContentModel?,
            dailyAsma: freezed == dailyAsma
                ? _value.dailyAsma
                : dailyAsma // ignore: cast_nullable_to_non_nullable
                      as AsmaulHusnaModel?,
            hadithViewedToday: null == hadithViewedToday
                ? _value.hadithViewedToday
                : hadithViewedToday // ignore: cast_nullable_to_non_nullable
                      as bool,
            sunnahViewedToday: null == sunnahViewedToday
                ? _value.sunnahViewedToday
                : sunnahViewedToday // ignore: cast_nullable_to_non_nullable
                      as bool,
            isHadithFavorite: null == isHadithFavorite
                ? _value.isHadithFavorite
                : isHadithFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSunnahFavorite: null == isSunnahFavorite
                ? _value.isSunnahFavorite
                : isSunnahFavorite // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of DailyContentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DailyContentModelCopyWith<$Res>? get dailyHadith {
    if (_value.dailyHadith == null) {
      return null;
    }

    return $DailyContentModelCopyWith<$Res>(_value.dailyHadith!, (value) {
      return _then(_value.copyWith(dailyHadith: value) as $Val);
    });
  }

  /// Create a copy of DailyContentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DailyContentModelCopyWith<$Res>? get dailySunnah {
    if (_value.dailySunnah == null) {
      return null;
    }

    return $DailyContentModelCopyWith<$Res>(_value.dailySunnah!, (value) {
      return _then(_value.copyWith(dailySunnah: value) as $Val);
    });
  }

  /// Create a copy of DailyContentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AsmaulHusnaModelCopyWith<$Res>? get dailyAsma {
    if (_value.dailyAsma == null) {
      return null;
    }

    return $AsmaulHusnaModelCopyWith<$Res>(_value.dailyAsma!, (value) {
      return _then(_value.copyWith(dailyAsma: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DailyContentStateImplCopyWith<$Res>
    implements $DailyContentStateCopyWith<$Res> {
  factory _$$DailyContentStateImplCopyWith(
    _$DailyContentStateImpl value,
    $Res Function(_$DailyContentStateImpl) then,
  ) = __$$DailyContentStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DailyContentStatus status,
    DailyContentModel? dailyHadith,
    DailyContentModel? dailySunnah,
    AsmaulHusnaModel? dailyAsma,
    bool hadithViewedToday,
    bool sunnahViewedToday,
    bool isHadithFavorite,
    bool isSunnahFavorite,
  });

  @override
  $DailyContentModelCopyWith<$Res>? get dailyHadith;
  @override
  $DailyContentModelCopyWith<$Res>? get dailySunnah;
  @override
  $AsmaulHusnaModelCopyWith<$Res>? get dailyAsma;
}

/// @nodoc
class __$$DailyContentStateImplCopyWithImpl<$Res>
    extends _$DailyContentStateCopyWithImpl<$Res, _$DailyContentStateImpl>
    implements _$$DailyContentStateImplCopyWith<$Res> {
  __$$DailyContentStateImplCopyWithImpl(
    _$DailyContentStateImpl _value,
    $Res Function(_$DailyContentStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyContentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? dailyHadith = freezed,
    Object? dailySunnah = freezed,
    Object? dailyAsma = freezed,
    Object? hadithViewedToday = null,
    Object? sunnahViewedToday = null,
    Object? isHadithFavorite = null,
    Object? isSunnahFavorite = null,
  }) {
    return _then(
      _$DailyContentStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as DailyContentStatus,
        dailyHadith: freezed == dailyHadith
            ? _value.dailyHadith
            : dailyHadith // ignore: cast_nullable_to_non_nullable
                  as DailyContentModel?,
        dailySunnah: freezed == dailySunnah
            ? _value.dailySunnah
            : dailySunnah // ignore: cast_nullable_to_non_nullable
                  as DailyContentModel?,
        dailyAsma: freezed == dailyAsma
            ? _value.dailyAsma
            : dailyAsma // ignore: cast_nullable_to_non_nullable
                  as AsmaulHusnaModel?,
        hadithViewedToday: null == hadithViewedToday
            ? _value.hadithViewedToday
            : hadithViewedToday // ignore: cast_nullable_to_non_nullable
                  as bool,
        sunnahViewedToday: null == sunnahViewedToday
            ? _value.sunnahViewedToday
            : sunnahViewedToday // ignore: cast_nullable_to_non_nullable
                  as bool,
        isHadithFavorite: null == isHadithFavorite
            ? _value.isHadithFavorite
            : isHadithFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSunnahFavorite: null == isSunnahFavorite
            ? _value.isSunnahFavorite
            : isSunnahFavorite // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$DailyContentStateImpl implements _DailyContentState {
  const _$DailyContentStateImpl({
    this.status = DailyContentStatus.initial,
    this.dailyHadith,
    this.dailySunnah,
    this.dailyAsma,
    this.hadithViewedToday = false,
    this.sunnahViewedToday = false,
    this.isHadithFavorite = false,
    this.isSunnahFavorite = false,
  });

  @override
  @JsonKey()
  final DailyContentStatus status;
  @override
  final DailyContentModel? dailyHadith;
  @override
  final DailyContentModel? dailySunnah;
  @override
  final AsmaulHusnaModel? dailyAsma;
  @override
  @JsonKey()
  final bool hadithViewedToday;
  @override
  @JsonKey()
  final bool sunnahViewedToday;
  @override
  @JsonKey()
  final bool isHadithFavorite;
  @override
  @JsonKey()
  final bool isSunnahFavorite;

  @override
  String toString() {
    return 'DailyContentState(status: $status, dailyHadith: $dailyHadith, dailySunnah: $dailySunnah, dailyAsma: $dailyAsma, hadithViewedToday: $hadithViewedToday, sunnahViewedToday: $sunnahViewedToday, isHadithFavorite: $isHadithFavorite, isSunnahFavorite: $isSunnahFavorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyContentStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dailyHadith, dailyHadith) ||
                other.dailyHadith == dailyHadith) &&
            (identical(other.dailySunnah, dailySunnah) ||
                other.dailySunnah == dailySunnah) &&
            (identical(other.dailyAsma, dailyAsma) ||
                other.dailyAsma == dailyAsma) &&
            (identical(other.hadithViewedToday, hadithViewedToday) ||
                other.hadithViewedToday == hadithViewedToday) &&
            (identical(other.sunnahViewedToday, sunnahViewedToday) ||
                other.sunnahViewedToday == sunnahViewedToday) &&
            (identical(other.isHadithFavorite, isHadithFavorite) ||
                other.isHadithFavorite == isHadithFavorite) &&
            (identical(other.isSunnahFavorite, isSunnahFavorite) ||
                other.isSunnahFavorite == isSunnahFavorite));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    dailyHadith,
    dailySunnah,
    dailyAsma,
    hadithViewedToday,
    sunnahViewedToday,
    isHadithFavorite,
    isSunnahFavorite,
  );

  /// Create a copy of DailyContentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyContentStateImplCopyWith<_$DailyContentStateImpl> get copyWith =>
      __$$DailyContentStateImplCopyWithImpl<_$DailyContentStateImpl>(
        this,
        _$identity,
      );
}

abstract class _DailyContentState implements DailyContentState {
  const factory _DailyContentState({
    final DailyContentStatus status,
    final DailyContentModel? dailyHadith,
    final DailyContentModel? dailySunnah,
    final AsmaulHusnaModel? dailyAsma,
    final bool hadithViewedToday,
    final bool sunnahViewedToday,
    final bool isHadithFavorite,
    final bool isSunnahFavorite,
  }) = _$DailyContentStateImpl;

  @override
  DailyContentStatus get status;
  @override
  DailyContentModel? get dailyHadith;
  @override
  DailyContentModel? get dailySunnah;
  @override
  AsmaulHusnaModel? get dailyAsma;
  @override
  bool get hadithViewedToday;
  @override
  bool get sunnahViewedToday;
  @override
  bool get isHadithFavorite;
  @override
  bool get isSunnahFavorite;

  /// Create a copy of DailyContentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyContentStateImplCopyWith<_$DailyContentStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
