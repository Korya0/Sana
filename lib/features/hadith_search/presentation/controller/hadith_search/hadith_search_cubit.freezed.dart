// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hadith_search_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HadithState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<HadithEntity> ahadith,
      int page,
      String query,
      bool hasReachedMax,
      bool isLoadingMore,
    )
    success,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<HadithEntity> ahadith,
      int page,
      String query,
      bool hasReachedMax,
      bool isLoadingMore,
    )?
    success,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<HadithEntity> ahadith,
      int page,
      String query,
      bool hasReachedMax,
      bool isLoadingMore,
    )?
    success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HadithInitial value) initial,
    required TResult Function(HadithLoading value) loading,
    required TResult Function(HadithSuccess value) success,
    required TResult Function(HadithError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HadithInitial value)? initial,
    TResult? Function(HadithLoading value)? loading,
    TResult? Function(HadithSuccess value)? success,
    TResult? Function(HadithError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HadithInitial value)? initial,
    TResult Function(HadithLoading value)? loading,
    TResult Function(HadithSuccess value)? success,
    TResult Function(HadithError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HadithStateCopyWith<$Res> {
  factory $HadithStateCopyWith(
    HadithState value,
    $Res Function(HadithState) then,
  ) = _$HadithStateCopyWithImpl<$Res, HadithState>;
}

/// @nodoc
class _$HadithStateCopyWithImpl<$Res, $Val extends HadithState>
    implements $HadithStateCopyWith<$Res> {
  _$HadithStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HadithState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$HadithInitialImplCopyWith<$Res> {
  factory _$$HadithInitialImplCopyWith(
    _$HadithInitialImpl value,
    $Res Function(_$HadithInitialImpl) then,
  ) = __$$HadithInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HadithInitialImplCopyWithImpl<$Res>
    extends _$HadithStateCopyWithImpl<$Res, _$HadithInitialImpl>
    implements _$$HadithInitialImplCopyWith<$Res> {
  __$$HadithInitialImplCopyWithImpl(
    _$HadithInitialImpl _value,
    $Res Function(_$HadithInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HadithState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$HadithInitialImpl implements HadithInitial {
  const _$HadithInitialImpl();

  @override
  String toString() {
    return 'HadithState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HadithInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<HadithEntity> ahadith,
      int page,
      String query,
      bool hasReachedMax,
      bool isLoadingMore,
    )
    success,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<HadithEntity> ahadith,
      int page,
      String query,
      bool hasReachedMax,
      bool isLoadingMore,
    )?
    success,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<HadithEntity> ahadith,
      int page,
      String query,
      bool hasReachedMax,
      bool isLoadingMore,
    )?
    success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HadithInitial value) initial,
    required TResult Function(HadithLoading value) loading,
    required TResult Function(HadithSuccess value) success,
    required TResult Function(HadithError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HadithInitial value)? initial,
    TResult? Function(HadithLoading value)? loading,
    TResult? Function(HadithSuccess value)? success,
    TResult? Function(HadithError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HadithInitial value)? initial,
    TResult Function(HadithLoading value)? loading,
    TResult Function(HadithSuccess value)? success,
    TResult Function(HadithError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class HadithInitial implements HadithState {
  const factory HadithInitial() = _$HadithInitialImpl;
}

/// @nodoc
abstract class _$$HadithLoadingImplCopyWith<$Res> {
  factory _$$HadithLoadingImplCopyWith(
    _$HadithLoadingImpl value,
    $Res Function(_$HadithLoadingImpl) then,
  ) = __$$HadithLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HadithLoadingImplCopyWithImpl<$Res>
    extends _$HadithStateCopyWithImpl<$Res, _$HadithLoadingImpl>
    implements _$$HadithLoadingImplCopyWith<$Res> {
  __$$HadithLoadingImplCopyWithImpl(
    _$HadithLoadingImpl _value,
    $Res Function(_$HadithLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HadithState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$HadithLoadingImpl implements HadithLoading {
  const _$HadithLoadingImpl();

  @override
  String toString() {
    return 'HadithState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HadithLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<HadithEntity> ahadith,
      int page,
      String query,
      bool hasReachedMax,
      bool isLoadingMore,
    )
    success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<HadithEntity> ahadith,
      int page,
      String query,
      bool hasReachedMax,
      bool isLoadingMore,
    )?
    success,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<HadithEntity> ahadith,
      int page,
      String query,
      bool hasReachedMax,
      bool isLoadingMore,
    )?
    success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HadithInitial value) initial,
    required TResult Function(HadithLoading value) loading,
    required TResult Function(HadithSuccess value) success,
    required TResult Function(HadithError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HadithInitial value)? initial,
    TResult? Function(HadithLoading value)? loading,
    TResult? Function(HadithSuccess value)? success,
    TResult? Function(HadithError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HadithInitial value)? initial,
    TResult Function(HadithLoading value)? loading,
    TResult Function(HadithSuccess value)? success,
    TResult Function(HadithError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class HadithLoading implements HadithState {
  const factory HadithLoading() = _$HadithLoadingImpl;
}

/// @nodoc
abstract class _$$HadithSuccessImplCopyWith<$Res> {
  factory _$$HadithSuccessImplCopyWith(
    _$HadithSuccessImpl value,
    $Res Function(_$HadithSuccessImpl) then,
  ) = __$$HadithSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<HadithEntity> ahadith,
    int page,
    String query,
    bool hasReachedMax,
    bool isLoadingMore,
  });
}

/// @nodoc
class __$$HadithSuccessImplCopyWithImpl<$Res>
    extends _$HadithStateCopyWithImpl<$Res, _$HadithSuccessImpl>
    implements _$$HadithSuccessImplCopyWith<$Res> {
  __$$HadithSuccessImplCopyWithImpl(
    _$HadithSuccessImpl _value,
    $Res Function(_$HadithSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HadithState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ahadith = null,
    Object? page = null,
    Object? query = null,
    Object? hasReachedMax = null,
    Object? isLoadingMore = null,
  }) {
    return _then(
      _$HadithSuccessImpl(
        ahadith: null == ahadith
            ? _value._ahadith
            : ahadith // ignore: cast_nullable_to_non_nullable
                  as List<HadithEntity>,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        query: null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
        hasReachedMax: null == hasReachedMax
            ? _value.hasReachedMax
            : hasReachedMax // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoadingMore: null == isLoadingMore
            ? _value.isLoadingMore
            : isLoadingMore // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$HadithSuccessImpl implements HadithSuccess {
  const _$HadithSuccessImpl({
    required final List<HadithEntity> ahadith,
    required this.page,
    required this.query,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  }) : _ahadith = ahadith;

  final List<HadithEntity> _ahadith;
  @override
  List<HadithEntity> get ahadith {
    if (_ahadith is EqualUnmodifiableListView) return _ahadith;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ahadith);
  }

  @override
  final int page;
  @override
  final String query;
  @override
  @JsonKey()
  final bool hasReachedMax;
  @override
  @JsonKey()
  final bool isLoadingMore;

  @override
  String toString() {
    return 'HadithState.success(ahadith: $ahadith, page: $page, query: $query, hasReachedMax: $hasReachedMax, isLoadingMore: $isLoadingMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HadithSuccessImpl &&
            const DeepCollectionEquality().equals(other._ahadith, _ahadith) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.hasReachedMax, hasReachedMax) ||
                other.hasReachedMax == hasReachedMax) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_ahadith),
    page,
    query,
    hasReachedMax,
    isLoadingMore,
  );

  /// Create a copy of HadithState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HadithSuccessImplCopyWith<_$HadithSuccessImpl> get copyWith =>
      __$$HadithSuccessImplCopyWithImpl<_$HadithSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<HadithEntity> ahadith,
      int page,
      String query,
      bool hasReachedMax,
      bool isLoadingMore,
    )
    success,
    required TResult Function(String message) error,
  }) {
    return success(ahadith, page, query, hasReachedMax, isLoadingMore);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<HadithEntity> ahadith,
      int page,
      String query,
      bool hasReachedMax,
      bool isLoadingMore,
    )?
    success,
    TResult? Function(String message)? error,
  }) {
    return success?.call(ahadith, page, query, hasReachedMax, isLoadingMore);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<HadithEntity> ahadith,
      int page,
      String query,
      bool hasReachedMax,
      bool isLoadingMore,
    )?
    success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(ahadith, page, query, hasReachedMax, isLoadingMore);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HadithInitial value) initial,
    required TResult Function(HadithLoading value) loading,
    required TResult Function(HadithSuccess value) success,
    required TResult Function(HadithError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HadithInitial value)? initial,
    TResult? Function(HadithLoading value)? loading,
    TResult? Function(HadithSuccess value)? success,
    TResult? Function(HadithError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HadithInitial value)? initial,
    TResult Function(HadithLoading value)? loading,
    TResult Function(HadithSuccess value)? success,
    TResult Function(HadithError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class HadithSuccess implements HadithState {
  const factory HadithSuccess({
    required final List<HadithEntity> ahadith,
    required final int page,
    required final String query,
    final bool hasReachedMax,
    final bool isLoadingMore,
  }) = _$HadithSuccessImpl;

  List<HadithEntity> get ahadith;
  int get page;
  String get query;
  bool get hasReachedMax;
  bool get isLoadingMore;

  /// Create a copy of HadithState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HadithSuccessImplCopyWith<_$HadithSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HadithErrorImplCopyWith<$Res> {
  factory _$$HadithErrorImplCopyWith(
    _$HadithErrorImpl value,
    $Res Function(_$HadithErrorImpl) then,
  ) = __$$HadithErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$HadithErrorImplCopyWithImpl<$Res>
    extends _$HadithStateCopyWithImpl<$Res, _$HadithErrorImpl>
    implements _$$HadithErrorImplCopyWith<$Res> {
  __$$HadithErrorImplCopyWithImpl(
    _$HadithErrorImpl _value,
    $Res Function(_$HadithErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HadithState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$HadithErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$HadithErrorImpl implements HadithError {
  const _$HadithErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'HadithState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HadithErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of HadithState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HadithErrorImplCopyWith<_$HadithErrorImpl> get copyWith =>
      __$$HadithErrorImplCopyWithImpl<_$HadithErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<HadithEntity> ahadith,
      int page,
      String query,
      bool hasReachedMax,
      bool isLoadingMore,
    )
    success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<HadithEntity> ahadith,
      int page,
      String query,
      bool hasReachedMax,
      bool isLoadingMore,
    )?
    success,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<HadithEntity> ahadith,
      int page,
      String query,
      bool hasReachedMax,
      bool isLoadingMore,
    )?
    success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HadithInitial value) initial,
    required TResult Function(HadithLoading value) loading,
    required TResult Function(HadithSuccess value) success,
    required TResult Function(HadithError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HadithInitial value)? initial,
    TResult? Function(HadithLoading value)? loading,
    TResult? Function(HadithSuccess value)? success,
    TResult? Function(HadithError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HadithInitial value)? initial,
    TResult Function(HadithLoading value)? loading,
    TResult Function(HadithSuccess value)? success,
    TResult Function(HadithError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class HadithError implements HadithState {
  const factory HadithError(final String message) = _$HadithErrorImpl;

  String get message;

  /// Create a copy of HadithState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HadithErrorImplCopyWith<_$HadithErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
