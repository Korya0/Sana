// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prayer_times_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PrayerTimesState {
  UserPrayerTimesSettings get settings => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserPrayerTimesSettings settings) initial,
    required TResult Function(UserPrayerTimesSettings settings) loading,
    required TResult Function(
      List<PrayerDisplayModel> prayers,
      UserPrayerTimesSettings settings,
      Duration? timeRemaining,
      SunnahTimes? sunnahTimes,
      PrayerTimes? originPrayerTimes,
      ReligiousEventModel? currentEvent,
      bool isEventToday,
      PrayerTimeStatus? currentStatus,
    )
    success,
    required TResult Function(UserPrayerTimesSettings settings, Failure failure)
    failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserPrayerTimesSettings settings)? initial,
    TResult? Function(UserPrayerTimesSettings settings)? loading,
    TResult? Function(
      List<PrayerDisplayModel> prayers,
      UserPrayerTimesSettings settings,
      Duration? timeRemaining,
      SunnahTimes? sunnahTimes,
      PrayerTimes? originPrayerTimes,
      ReligiousEventModel? currentEvent,
      bool isEventToday,
      PrayerTimeStatus? currentStatus,
    )?
    success,
    TResult? Function(UserPrayerTimesSettings settings, Failure failure)?
    failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserPrayerTimesSettings settings)? initial,
    TResult Function(UserPrayerTimesSettings settings)? loading,
    TResult Function(
      List<PrayerDisplayModel> prayers,
      UserPrayerTimesSettings settings,
      Duration? timeRemaining,
      SunnahTimes? sunnahTimes,
      PrayerTimes? originPrayerTimes,
      ReligiousEventModel? currentEvent,
      bool isEventToday,
      PrayerTimeStatus? currentStatus,
    )?
    success,
    TResult Function(UserPrayerTimesSettings settings, Failure failure)?
    failure,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PrayerTimesInitial value) initial,
    required TResult Function(PrayerTimesLoading value) loading,
    required TResult Function(PrayerTimesLoaded value) success,
    required TResult Function(PrayerTimesError value) failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PrayerTimesInitial value)? initial,
    TResult? Function(PrayerTimesLoading value)? loading,
    TResult? Function(PrayerTimesLoaded value)? success,
    TResult? Function(PrayerTimesError value)? failure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PrayerTimesInitial value)? initial,
    TResult Function(PrayerTimesLoading value)? loading,
    TResult Function(PrayerTimesLoaded value)? success,
    TResult Function(PrayerTimesError value)? failure,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrayerTimesStateCopyWith<PrayerTimesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrayerTimesStateCopyWith<$Res> {
  factory $PrayerTimesStateCopyWith(
    PrayerTimesState value,
    $Res Function(PrayerTimesState) then,
  ) = _$PrayerTimesStateCopyWithImpl<$Res, PrayerTimesState>;
  @useResult
  $Res call({UserPrayerTimesSettings settings});

  $UserPrayerTimesSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class _$PrayerTimesStateCopyWithImpl<$Res, $Val extends PrayerTimesState>
    implements $PrayerTimesStateCopyWith<$Res> {
  _$PrayerTimesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? settings = null}) {
    return _then(
      _value.copyWith(
            settings: null == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                      as UserPrayerTimesSettings,
          )
          as $Val,
    );
  }

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserPrayerTimesSettingsCopyWith<$Res> get settings {
    return $UserPrayerTimesSettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PrayerTimesInitialImplCopyWith<$Res>
    implements $PrayerTimesStateCopyWith<$Res> {
  factory _$$PrayerTimesInitialImplCopyWith(
    _$PrayerTimesInitialImpl value,
    $Res Function(_$PrayerTimesInitialImpl) then,
  ) = __$$PrayerTimesInitialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserPrayerTimesSettings settings});

  @override
  $UserPrayerTimesSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class __$$PrayerTimesInitialImplCopyWithImpl<$Res>
    extends _$PrayerTimesStateCopyWithImpl<$Res, _$PrayerTimesInitialImpl>
    implements _$$PrayerTimesInitialImplCopyWith<$Res> {
  __$$PrayerTimesInitialImplCopyWithImpl(
    _$PrayerTimesInitialImpl _value,
    $Res Function(_$PrayerTimesInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? settings = null}) {
    return _then(
      _$PrayerTimesInitialImpl(
        settings: null == settings
            ? _value.settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as UserPrayerTimesSettings,
      ),
    );
  }
}

/// @nodoc

class _$PrayerTimesInitialImpl extends PrayerTimesInitial {
  const _$PrayerTimesInitialImpl({required this.settings}) : super._();

  @override
  final UserPrayerTimesSettings settings;

  @override
  String toString() {
    return 'PrayerTimesState.initial(settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrayerTimesInitialImpl &&
            (identical(other.settings, settings) ||
                other.settings == settings));
  }

  @override
  int get hashCode => Object.hash(runtimeType, settings);

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrayerTimesInitialImplCopyWith<_$PrayerTimesInitialImpl> get copyWith =>
      __$$PrayerTimesInitialImplCopyWithImpl<_$PrayerTimesInitialImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserPrayerTimesSettings settings) initial,
    required TResult Function(UserPrayerTimesSettings settings) loading,
    required TResult Function(
      List<PrayerDisplayModel> prayers,
      UserPrayerTimesSettings settings,
      Duration? timeRemaining,
      SunnahTimes? sunnahTimes,
      PrayerTimes? originPrayerTimes,
      ReligiousEventModel? currentEvent,
      bool isEventToday,
      PrayerTimeStatus? currentStatus,
    )
    success,
    required TResult Function(UserPrayerTimesSettings settings, Failure failure)
    failure,
  }) {
    return initial(settings);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserPrayerTimesSettings settings)? initial,
    TResult? Function(UserPrayerTimesSettings settings)? loading,
    TResult? Function(
      List<PrayerDisplayModel> prayers,
      UserPrayerTimesSettings settings,
      Duration? timeRemaining,
      SunnahTimes? sunnahTimes,
      PrayerTimes? originPrayerTimes,
      ReligiousEventModel? currentEvent,
      bool isEventToday,
      PrayerTimeStatus? currentStatus,
    )?
    success,
    TResult? Function(UserPrayerTimesSettings settings, Failure failure)?
    failure,
  }) {
    return initial?.call(settings);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserPrayerTimesSettings settings)? initial,
    TResult Function(UserPrayerTimesSettings settings)? loading,
    TResult Function(
      List<PrayerDisplayModel> prayers,
      UserPrayerTimesSettings settings,
      Duration? timeRemaining,
      SunnahTimes? sunnahTimes,
      PrayerTimes? originPrayerTimes,
      ReligiousEventModel? currentEvent,
      bool isEventToday,
      PrayerTimeStatus? currentStatus,
    )?
    success,
    TResult Function(UserPrayerTimesSettings settings, Failure failure)?
    failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(settings);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PrayerTimesInitial value) initial,
    required TResult Function(PrayerTimesLoading value) loading,
    required TResult Function(PrayerTimesLoaded value) success,
    required TResult Function(PrayerTimesError value) failure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PrayerTimesInitial value)? initial,
    TResult? Function(PrayerTimesLoading value)? loading,
    TResult? Function(PrayerTimesLoaded value)? success,
    TResult? Function(PrayerTimesError value)? failure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PrayerTimesInitial value)? initial,
    TResult Function(PrayerTimesLoading value)? loading,
    TResult Function(PrayerTimesLoaded value)? success,
    TResult Function(PrayerTimesError value)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class PrayerTimesInitial extends PrayerTimesState {
  const factory PrayerTimesInitial({
    required final UserPrayerTimesSettings settings,
  }) = _$PrayerTimesInitialImpl;
  const PrayerTimesInitial._() : super._();

  @override
  UserPrayerTimesSettings get settings;

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrayerTimesInitialImplCopyWith<_$PrayerTimesInitialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PrayerTimesLoadingImplCopyWith<$Res>
    implements $PrayerTimesStateCopyWith<$Res> {
  factory _$$PrayerTimesLoadingImplCopyWith(
    _$PrayerTimesLoadingImpl value,
    $Res Function(_$PrayerTimesLoadingImpl) then,
  ) = __$$PrayerTimesLoadingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserPrayerTimesSettings settings});

  @override
  $UserPrayerTimesSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class __$$PrayerTimesLoadingImplCopyWithImpl<$Res>
    extends _$PrayerTimesStateCopyWithImpl<$Res, _$PrayerTimesLoadingImpl>
    implements _$$PrayerTimesLoadingImplCopyWith<$Res> {
  __$$PrayerTimesLoadingImplCopyWithImpl(
    _$PrayerTimesLoadingImpl _value,
    $Res Function(_$PrayerTimesLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? settings = null}) {
    return _then(
      _$PrayerTimesLoadingImpl(
        settings: null == settings
            ? _value.settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as UserPrayerTimesSettings,
      ),
    );
  }
}

/// @nodoc

class _$PrayerTimesLoadingImpl extends PrayerTimesLoading {
  const _$PrayerTimesLoadingImpl({required this.settings}) : super._();

  @override
  final UserPrayerTimesSettings settings;

  @override
  String toString() {
    return 'PrayerTimesState.loading(settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrayerTimesLoadingImpl &&
            (identical(other.settings, settings) ||
                other.settings == settings));
  }

  @override
  int get hashCode => Object.hash(runtimeType, settings);

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrayerTimesLoadingImplCopyWith<_$PrayerTimesLoadingImpl> get copyWith =>
      __$$PrayerTimesLoadingImplCopyWithImpl<_$PrayerTimesLoadingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserPrayerTimesSettings settings) initial,
    required TResult Function(UserPrayerTimesSettings settings) loading,
    required TResult Function(
      List<PrayerDisplayModel> prayers,
      UserPrayerTimesSettings settings,
      Duration? timeRemaining,
      SunnahTimes? sunnahTimes,
      PrayerTimes? originPrayerTimes,
      ReligiousEventModel? currentEvent,
      bool isEventToday,
      PrayerTimeStatus? currentStatus,
    )
    success,
    required TResult Function(UserPrayerTimesSettings settings, Failure failure)
    failure,
  }) {
    return loading(settings);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserPrayerTimesSettings settings)? initial,
    TResult? Function(UserPrayerTimesSettings settings)? loading,
    TResult? Function(
      List<PrayerDisplayModel> prayers,
      UserPrayerTimesSettings settings,
      Duration? timeRemaining,
      SunnahTimes? sunnahTimes,
      PrayerTimes? originPrayerTimes,
      ReligiousEventModel? currentEvent,
      bool isEventToday,
      PrayerTimeStatus? currentStatus,
    )?
    success,
    TResult? Function(UserPrayerTimesSettings settings, Failure failure)?
    failure,
  }) {
    return loading?.call(settings);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserPrayerTimesSettings settings)? initial,
    TResult Function(UserPrayerTimesSettings settings)? loading,
    TResult Function(
      List<PrayerDisplayModel> prayers,
      UserPrayerTimesSettings settings,
      Duration? timeRemaining,
      SunnahTimes? sunnahTimes,
      PrayerTimes? originPrayerTimes,
      ReligiousEventModel? currentEvent,
      bool isEventToday,
      PrayerTimeStatus? currentStatus,
    )?
    success,
    TResult Function(UserPrayerTimesSettings settings, Failure failure)?
    failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(settings);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PrayerTimesInitial value) initial,
    required TResult Function(PrayerTimesLoading value) loading,
    required TResult Function(PrayerTimesLoaded value) success,
    required TResult Function(PrayerTimesError value) failure,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PrayerTimesInitial value)? initial,
    TResult? Function(PrayerTimesLoading value)? loading,
    TResult? Function(PrayerTimesLoaded value)? success,
    TResult? Function(PrayerTimesError value)? failure,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PrayerTimesInitial value)? initial,
    TResult Function(PrayerTimesLoading value)? loading,
    TResult Function(PrayerTimesLoaded value)? success,
    TResult Function(PrayerTimesError value)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class PrayerTimesLoading extends PrayerTimesState {
  const factory PrayerTimesLoading({
    required final UserPrayerTimesSettings settings,
  }) = _$PrayerTimesLoadingImpl;
  const PrayerTimesLoading._() : super._();

  @override
  UserPrayerTimesSettings get settings;

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrayerTimesLoadingImplCopyWith<_$PrayerTimesLoadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PrayerTimesLoadedImplCopyWith<$Res>
    implements $PrayerTimesStateCopyWith<$Res> {
  factory _$$PrayerTimesLoadedImplCopyWith(
    _$PrayerTimesLoadedImpl value,
    $Res Function(_$PrayerTimesLoadedImpl) then,
  ) = __$$PrayerTimesLoadedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<PrayerDisplayModel> prayers,
    UserPrayerTimesSettings settings,
    Duration? timeRemaining,
    SunnahTimes? sunnahTimes,
    PrayerTimes? originPrayerTimes,
    ReligiousEventModel? currentEvent,
    bool isEventToday,
    PrayerTimeStatus? currentStatus,
  });

  @override
  $UserPrayerTimesSettingsCopyWith<$Res> get settings;
  $ReligiousEventModelCopyWith<$Res>? get currentEvent;
  $PrayerTimeStatusCopyWith<$Res>? get currentStatus;
}

/// @nodoc
class __$$PrayerTimesLoadedImplCopyWithImpl<$Res>
    extends _$PrayerTimesStateCopyWithImpl<$Res, _$PrayerTimesLoadedImpl>
    implements _$$PrayerTimesLoadedImplCopyWith<$Res> {
  __$$PrayerTimesLoadedImplCopyWithImpl(
    _$PrayerTimesLoadedImpl _value,
    $Res Function(_$PrayerTimesLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prayers = null,
    Object? settings = null,
    Object? timeRemaining = freezed,
    Object? sunnahTimes = freezed,
    Object? originPrayerTimes = freezed,
    Object? currentEvent = freezed,
    Object? isEventToday = null,
    Object? currentStatus = freezed,
  }) {
    return _then(
      _$PrayerTimesLoadedImpl(
        prayers: null == prayers
            ? _value._prayers
            : prayers // ignore: cast_nullable_to_non_nullable
                  as List<PrayerDisplayModel>,
        settings: null == settings
            ? _value.settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as UserPrayerTimesSettings,
        timeRemaining: freezed == timeRemaining
            ? _value.timeRemaining
            : timeRemaining // ignore: cast_nullable_to_non_nullable
                  as Duration?,
        sunnahTimes: freezed == sunnahTimes
            ? _value.sunnahTimes
            : sunnahTimes // ignore: cast_nullable_to_non_nullable
                  as SunnahTimes?,
        originPrayerTimes: freezed == originPrayerTimes
            ? _value.originPrayerTimes
            : originPrayerTimes // ignore: cast_nullable_to_non_nullable
                  as PrayerTimes?,
        currentEvent: freezed == currentEvent
            ? _value.currentEvent
            : currentEvent // ignore: cast_nullable_to_non_nullable
                  as ReligiousEventModel?,
        isEventToday: null == isEventToday
            ? _value.isEventToday
            : isEventToday // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentStatus: freezed == currentStatus
            ? _value.currentStatus
            : currentStatus // ignore: cast_nullable_to_non_nullable
                  as PrayerTimeStatus?,
      ),
    );
  }

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReligiousEventModelCopyWith<$Res>? get currentEvent {
    if (_value.currentEvent == null) {
      return null;
    }

    return $ReligiousEventModelCopyWith<$Res>(_value.currentEvent!, (value) {
      return _then(_value.copyWith(currentEvent: value));
    });
  }

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PrayerTimeStatusCopyWith<$Res>? get currentStatus {
    if (_value.currentStatus == null) {
      return null;
    }

    return $PrayerTimeStatusCopyWith<$Res>(_value.currentStatus!, (value) {
      return _then(_value.copyWith(currentStatus: value));
    });
  }
}

/// @nodoc

class _$PrayerTimesLoadedImpl extends PrayerTimesLoaded {
  const _$PrayerTimesLoadedImpl({
    required final List<PrayerDisplayModel> prayers,
    required this.settings,
    this.timeRemaining,
    this.sunnahTimes,
    this.originPrayerTimes,
    this.currentEvent,
    this.isEventToday = true,
    this.currentStatus,
  }) : _prayers = prayers,
       super._();

  final List<PrayerDisplayModel> _prayers;
  @override
  List<PrayerDisplayModel> get prayers {
    if (_prayers is EqualUnmodifiableListView) return _prayers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prayers);
  }

  @override
  final UserPrayerTimesSettings settings;
  @override
  final Duration? timeRemaining;
  @override
  final SunnahTimes? sunnahTimes;
  @override
  final PrayerTimes? originPrayerTimes;
  @override
  final ReligiousEventModel? currentEvent;
  @override
  @JsonKey()
  final bool isEventToday;
  @override
  final PrayerTimeStatus? currentStatus;

  @override
  String toString() {
    return 'PrayerTimesState.success(prayers: $prayers, settings: $settings, timeRemaining: $timeRemaining, sunnahTimes: $sunnahTimes, originPrayerTimes: $originPrayerTimes, currentEvent: $currentEvent, isEventToday: $isEventToday, currentStatus: $currentStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrayerTimesLoadedImpl &&
            const DeepCollectionEquality().equals(other._prayers, _prayers) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.timeRemaining, timeRemaining) ||
                other.timeRemaining == timeRemaining) &&
            (identical(other.sunnahTimes, sunnahTimes) ||
                other.sunnahTimes == sunnahTimes) &&
            (identical(other.originPrayerTimes, originPrayerTimes) ||
                other.originPrayerTimes == originPrayerTimes) &&
            (identical(other.currentEvent, currentEvent) ||
                other.currentEvent == currentEvent) &&
            (identical(other.isEventToday, isEventToday) ||
                other.isEventToday == isEventToday) &&
            (identical(other.currentStatus, currentStatus) ||
                other.currentStatus == currentStatus));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_prayers),
    settings,
    timeRemaining,
    sunnahTimes,
    originPrayerTimes,
    currentEvent,
    isEventToday,
    currentStatus,
  );

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrayerTimesLoadedImplCopyWith<_$PrayerTimesLoadedImpl> get copyWith =>
      __$$PrayerTimesLoadedImplCopyWithImpl<_$PrayerTimesLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserPrayerTimesSettings settings) initial,
    required TResult Function(UserPrayerTimesSettings settings) loading,
    required TResult Function(
      List<PrayerDisplayModel> prayers,
      UserPrayerTimesSettings settings,
      Duration? timeRemaining,
      SunnahTimes? sunnahTimes,
      PrayerTimes? originPrayerTimes,
      ReligiousEventModel? currentEvent,
      bool isEventToday,
      PrayerTimeStatus? currentStatus,
    )
    success,
    required TResult Function(UserPrayerTimesSettings settings, Failure failure)
    failure,
  }) {
    return success(
      prayers,
      settings,
      timeRemaining,
      sunnahTimes,
      originPrayerTimes,
      currentEvent,
      isEventToday,
      currentStatus,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserPrayerTimesSettings settings)? initial,
    TResult? Function(UserPrayerTimesSettings settings)? loading,
    TResult? Function(
      List<PrayerDisplayModel> prayers,
      UserPrayerTimesSettings settings,
      Duration? timeRemaining,
      SunnahTimes? sunnahTimes,
      PrayerTimes? originPrayerTimes,
      ReligiousEventModel? currentEvent,
      bool isEventToday,
      PrayerTimeStatus? currentStatus,
    )?
    success,
    TResult? Function(UserPrayerTimesSettings settings, Failure failure)?
    failure,
  }) {
    return success?.call(
      prayers,
      settings,
      timeRemaining,
      sunnahTimes,
      originPrayerTimes,
      currentEvent,
      isEventToday,
      currentStatus,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserPrayerTimesSettings settings)? initial,
    TResult Function(UserPrayerTimesSettings settings)? loading,
    TResult Function(
      List<PrayerDisplayModel> prayers,
      UserPrayerTimesSettings settings,
      Duration? timeRemaining,
      SunnahTimes? sunnahTimes,
      PrayerTimes? originPrayerTimes,
      ReligiousEventModel? currentEvent,
      bool isEventToday,
      PrayerTimeStatus? currentStatus,
    )?
    success,
    TResult Function(UserPrayerTimesSettings settings, Failure failure)?
    failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(
        prayers,
        settings,
        timeRemaining,
        sunnahTimes,
        originPrayerTimes,
        currentEvent,
        isEventToday,
        currentStatus,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PrayerTimesInitial value) initial,
    required TResult Function(PrayerTimesLoading value) loading,
    required TResult Function(PrayerTimesLoaded value) success,
    required TResult Function(PrayerTimesError value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PrayerTimesInitial value)? initial,
    TResult? Function(PrayerTimesLoading value)? loading,
    TResult? Function(PrayerTimesLoaded value)? success,
    TResult? Function(PrayerTimesError value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PrayerTimesInitial value)? initial,
    TResult Function(PrayerTimesLoading value)? loading,
    TResult Function(PrayerTimesLoaded value)? success,
    TResult Function(PrayerTimesError value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class PrayerTimesLoaded extends PrayerTimesState {
  const factory PrayerTimesLoaded({
    required final List<PrayerDisplayModel> prayers,
    required final UserPrayerTimesSettings settings,
    final Duration? timeRemaining,
    final SunnahTimes? sunnahTimes,
    final PrayerTimes? originPrayerTimes,
    final ReligiousEventModel? currentEvent,
    final bool isEventToday,
    final PrayerTimeStatus? currentStatus,
  }) = _$PrayerTimesLoadedImpl;
  const PrayerTimesLoaded._() : super._();

  List<PrayerDisplayModel> get prayers;
  @override
  UserPrayerTimesSettings get settings;
  Duration? get timeRemaining;
  SunnahTimes? get sunnahTimes;
  PrayerTimes? get originPrayerTimes;
  ReligiousEventModel? get currentEvent;
  bool get isEventToday;
  PrayerTimeStatus? get currentStatus;

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrayerTimesLoadedImplCopyWith<_$PrayerTimesLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PrayerTimesErrorImplCopyWith<$Res>
    implements $PrayerTimesStateCopyWith<$Res> {
  factory _$$PrayerTimesErrorImplCopyWith(
    _$PrayerTimesErrorImpl value,
    $Res Function(_$PrayerTimesErrorImpl) then,
  ) = __$$PrayerTimesErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserPrayerTimesSettings settings, Failure failure});

  @override
  $UserPrayerTimesSettingsCopyWith<$Res> get settings;
  $FailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$PrayerTimesErrorImplCopyWithImpl<$Res>
    extends _$PrayerTimesStateCopyWithImpl<$Res, _$PrayerTimesErrorImpl>
    implements _$$PrayerTimesErrorImplCopyWith<$Res> {
  __$$PrayerTimesErrorImplCopyWithImpl(
    _$PrayerTimesErrorImpl _value,
    $Res Function(_$PrayerTimesErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? settings = null, Object? failure = null}) {
    return _then(
      _$PrayerTimesErrorImpl(
        settings: null == settings
            ? _value.settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as UserPrayerTimesSettings,
        failure: null == failure
            ? _value.failure
            : failure // ignore: cast_nullable_to_non_nullable
                  as Failure,
      ),
    );
  }

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FailureCopyWith<$Res> get failure {
    return $FailureCopyWith<$Res>(_value.failure, (value) {
      return _then(_value.copyWith(failure: value));
    });
  }
}

/// @nodoc

class _$PrayerTimesErrorImpl extends PrayerTimesError {
  const _$PrayerTimesErrorImpl({required this.settings, required this.failure})
    : super._();

  @override
  final UserPrayerTimesSettings settings;
  @override
  final Failure failure;

  @override
  String toString() {
    return 'PrayerTimesState.failure(settings: $settings, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrayerTimesErrorImpl &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, settings, failure);

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrayerTimesErrorImplCopyWith<_$PrayerTimesErrorImpl> get copyWith =>
      __$$PrayerTimesErrorImplCopyWithImpl<_$PrayerTimesErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(UserPrayerTimesSettings settings) initial,
    required TResult Function(UserPrayerTimesSettings settings) loading,
    required TResult Function(
      List<PrayerDisplayModel> prayers,
      UserPrayerTimesSettings settings,
      Duration? timeRemaining,
      SunnahTimes? sunnahTimes,
      PrayerTimes? originPrayerTimes,
      ReligiousEventModel? currentEvent,
      bool isEventToday,
      PrayerTimeStatus? currentStatus,
    )
    success,
    required TResult Function(UserPrayerTimesSettings settings, Failure failure)
    failure,
  }) {
    return failure(settings, this.failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(UserPrayerTimesSettings settings)? initial,
    TResult? Function(UserPrayerTimesSettings settings)? loading,
    TResult? Function(
      List<PrayerDisplayModel> prayers,
      UserPrayerTimesSettings settings,
      Duration? timeRemaining,
      SunnahTimes? sunnahTimes,
      PrayerTimes? originPrayerTimes,
      ReligiousEventModel? currentEvent,
      bool isEventToday,
      PrayerTimeStatus? currentStatus,
    )?
    success,
    TResult? Function(UserPrayerTimesSettings settings, Failure failure)?
    failure,
  }) {
    return failure?.call(settings, this.failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(UserPrayerTimesSettings settings)? initial,
    TResult Function(UserPrayerTimesSettings settings)? loading,
    TResult Function(
      List<PrayerDisplayModel> prayers,
      UserPrayerTimesSettings settings,
      Duration? timeRemaining,
      SunnahTimes? sunnahTimes,
      PrayerTimes? originPrayerTimes,
      ReligiousEventModel? currentEvent,
      bool isEventToday,
      PrayerTimeStatus? currentStatus,
    )?
    success,
    TResult Function(UserPrayerTimesSettings settings, Failure failure)?
    failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(settings, this.failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PrayerTimesInitial value) initial,
    required TResult Function(PrayerTimesLoading value) loading,
    required TResult Function(PrayerTimesLoaded value) success,
    required TResult Function(PrayerTimesError value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PrayerTimesInitial value)? initial,
    TResult? Function(PrayerTimesLoading value)? loading,
    TResult? Function(PrayerTimesLoaded value)? success,
    TResult? Function(PrayerTimesError value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PrayerTimesInitial value)? initial,
    TResult Function(PrayerTimesLoading value)? loading,
    TResult Function(PrayerTimesLoaded value)? success,
    TResult Function(PrayerTimesError value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class PrayerTimesError extends PrayerTimesState {
  const factory PrayerTimesError({
    required final UserPrayerTimesSettings settings,
    required final Failure failure,
  }) = _$PrayerTimesErrorImpl;
  const PrayerTimesError._() : super._();

  @override
  UserPrayerTimesSettings get settings;
  Failure get failure;

  /// Create a copy of PrayerTimesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrayerTimesErrorImplCopyWith<_$PrayerTimesErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
