// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sunnah_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PrayerSunnah {
  SunnahHadith get hadith => throw _privateConstructorUsedError;
  String? get rakats => throw _privateConstructorUsedError;
  String? get timing => throw _privateConstructorUsedError;

  /// Create a copy of PrayerSunnah
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrayerSunnahCopyWith<PrayerSunnah> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrayerSunnahCopyWith<$Res> {
  factory $PrayerSunnahCopyWith(
    PrayerSunnah value,
    $Res Function(PrayerSunnah) then,
  ) = _$PrayerSunnahCopyWithImpl<$Res, PrayerSunnah>;
  @useResult
  $Res call({SunnahHadith hadith, String? rakats, String? timing});

  $SunnahHadithCopyWith<$Res> get hadith;
}

/// @nodoc
class _$PrayerSunnahCopyWithImpl<$Res, $Val extends PrayerSunnah>
    implements $PrayerSunnahCopyWith<$Res> {
  _$PrayerSunnahCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrayerSunnah
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hadith = null,
    Object? rakats = freezed,
    Object? timing = freezed,
  }) {
    return _then(
      _value.copyWith(
            hadith: null == hadith
                ? _value.hadith
                : hadith // ignore: cast_nullable_to_non_nullable
                      as SunnahHadith,
            rakats: freezed == rakats
                ? _value.rakats
                : rakats // ignore: cast_nullable_to_non_nullable
                      as String?,
            timing: freezed == timing
                ? _value.timing
                : timing // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of PrayerSunnah
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SunnahHadithCopyWith<$Res> get hadith {
    return $SunnahHadithCopyWith<$Res>(_value.hadith, (value) {
      return _then(_value.copyWith(hadith: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PrayerSunnahImplCopyWith<$Res>
    implements $PrayerSunnahCopyWith<$Res> {
  factory _$$PrayerSunnahImplCopyWith(
    _$PrayerSunnahImpl value,
    $Res Function(_$PrayerSunnahImpl) then,
  ) = __$$PrayerSunnahImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SunnahHadith hadith, String? rakats, String? timing});

  @override
  $SunnahHadithCopyWith<$Res> get hadith;
}

/// @nodoc
class __$$PrayerSunnahImplCopyWithImpl<$Res>
    extends _$PrayerSunnahCopyWithImpl<$Res, _$PrayerSunnahImpl>
    implements _$$PrayerSunnahImplCopyWith<$Res> {
  __$$PrayerSunnahImplCopyWithImpl(
    _$PrayerSunnahImpl _value,
    $Res Function(_$PrayerSunnahImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrayerSunnah
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hadith = null,
    Object? rakats = freezed,
    Object? timing = freezed,
  }) {
    return _then(
      _$PrayerSunnahImpl(
        hadith: null == hadith
            ? _value.hadith
            : hadith // ignore: cast_nullable_to_non_nullable
                  as SunnahHadith,
        rakats: freezed == rakats
            ? _value.rakats
            : rakats // ignore: cast_nullable_to_non_nullable
                  as String?,
        timing: freezed == timing
            ? _value.timing
            : timing // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PrayerSunnahImpl implements _PrayerSunnah {
  const _$PrayerSunnahImpl({required this.hadith, this.rakats, this.timing});

  @override
  final SunnahHadith hadith;
  @override
  final String? rakats;
  @override
  final String? timing;

  @override
  String toString() {
    return 'PrayerSunnah(hadith: $hadith, rakats: $rakats, timing: $timing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrayerSunnahImpl &&
            (identical(other.hadith, hadith) || other.hadith == hadith) &&
            (identical(other.rakats, rakats) || other.rakats == rakats) &&
            (identical(other.timing, timing) || other.timing == timing));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hadith, rakats, timing);

  /// Create a copy of PrayerSunnah
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrayerSunnahImplCopyWith<_$PrayerSunnahImpl> get copyWith =>
      __$$PrayerSunnahImplCopyWithImpl<_$PrayerSunnahImpl>(this, _$identity);
}

abstract class _PrayerSunnah implements PrayerSunnah {
  const factory _PrayerSunnah({
    required final SunnahHadith hadith,
    final String? rakats,
    final String? timing,
  }) = _$PrayerSunnahImpl;

  @override
  SunnahHadith get hadith;
  @override
  String? get rakats;
  @override
  String? get timing;

  /// Create a copy of PrayerSunnah
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrayerSunnahImplCopyWith<_$PrayerSunnahImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SunnahHadith {
  String get text => throw _privateConstructorUsedError;
  String get narrator => throw _privateConstructorUsedError;

  /// Create a copy of SunnahHadith
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SunnahHadithCopyWith<SunnahHadith> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SunnahHadithCopyWith<$Res> {
  factory $SunnahHadithCopyWith(
    SunnahHadith value,
    $Res Function(SunnahHadith) then,
  ) = _$SunnahHadithCopyWithImpl<$Res, SunnahHadith>;
  @useResult
  $Res call({String text, String narrator});
}

/// @nodoc
class _$SunnahHadithCopyWithImpl<$Res, $Val extends SunnahHadith>
    implements $SunnahHadithCopyWith<$Res> {
  _$SunnahHadithCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SunnahHadith
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? narrator = null}) {
    return _then(
      _value.copyWith(
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            narrator: null == narrator
                ? _value.narrator
                : narrator // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SunnahHadithImplCopyWith<$Res>
    implements $SunnahHadithCopyWith<$Res> {
  factory _$$SunnahHadithImplCopyWith(
    _$SunnahHadithImpl value,
    $Res Function(_$SunnahHadithImpl) then,
  ) = __$$SunnahHadithImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, String narrator});
}

/// @nodoc
class __$$SunnahHadithImplCopyWithImpl<$Res>
    extends _$SunnahHadithCopyWithImpl<$Res, _$SunnahHadithImpl>
    implements _$$SunnahHadithImplCopyWith<$Res> {
  __$$SunnahHadithImplCopyWithImpl(
    _$SunnahHadithImpl _value,
    $Res Function(_$SunnahHadithImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SunnahHadith
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? narrator = null}) {
    return _then(
      _$SunnahHadithImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        narrator: null == narrator
            ? _value.narrator
            : narrator // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SunnahHadithImpl implements _SunnahHadith {
  const _$SunnahHadithImpl({required this.text, required this.narrator});

  @override
  final String text;
  @override
  final String narrator;

  @override
  String toString() {
    return 'SunnahHadith(text: $text, narrator: $narrator)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SunnahHadithImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.narrator, narrator) ||
                other.narrator == narrator));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text, narrator);

  /// Create a copy of SunnahHadith
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SunnahHadithImplCopyWith<_$SunnahHadithImpl> get copyWith =>
      __$$SunnahHadithImplCopyWithImpl<_$SunnahHadithImpl>(this, _$identity);
}

abstract class _SunnahHadith implements SunnahHadith {
  const factory _SunnahHadith({
    required final String text,
    required final String narrator,
  }) = _$SunnahHadithImpl;

  @override
  String get text;
  @override
  String get narrator;

  /// Create a copy of SunnahHadith
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SunnahHadithImplCopyWith<_$SunnahHadithImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
