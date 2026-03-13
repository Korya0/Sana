// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'religious_event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ReligiousEventModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get month => throw _privateConstructorUsedError;
  List<int> get days => throw _privateConstructorUsedError;
  String? get hadithText => throw _privateConstructorUsedError;
  String? get bookInfo => throw _privateConstructorUsedError;

  /// Create a copy of ReligiousEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReligiousEventModelCopyWith<ReligiousEventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReligiousEventModelCopyWith<$Res> {
  factory $ReligiousEventModelCopyWith(
    ReligiousEventModel value,
    $Res Function(ReligiousEventModel) then,
  ) = _$ReligiousEventModelCopyWithImpl<$Res, ReligiousEventModel>;
  @useResult
  $Res call({
    int id,
    String title,
    int month,
    List<int> days,
    String? hadithText,
    String? bookInfo,
  });
}

/// @nodoc
class _$ReligiousEventModelCopyWithImpl<$Res, $Val extends ReligiousEventModel>
    implements $ReligiousEventModelCopyWith<$Res> {
  _$ReligiousEventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReligiousEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? month = null,
    Object? days = null,
    Object? hadithText = freezed,
    Object? bookInfo = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            month: null == month
                ? _value.month
                : month // ignore: cast_nullable_to_non_nullable
                      as int,
            days: null == days
                ? _value.days
                : days // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            hadithText: freezed == hadithText
                ? _value.hadithText
                : hadithText // ignore: cast_nullable_to_non_nullable
                      as String?,
            bookInfo: freezed == bookInfo
                ? _value.bookInfo
                : bookInfo // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReligiousEventModelImplCopyWith<$Res>
    implements $ReligiousEventModelCopyWith<$Res> {
  factory _$$ReligiousEventModelImplCopyWith(
    _$ReligiousEventModelImpl value,
    $Res Function(_$ReligiousEventModelImpl) then,
  ) = __$$ReligiousEventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    int month,
    List<int> days,
    String? hadithText,
    String? bookInfo,
  });
}

/// @nodoc
class __$$ReligiousEventModelImplCopyWithImpl<$Res>
    extends _$ReligiousEventModelCopyWithImpl<$Res, _$ReligiousEventModelImpl>
    implements _$$ReligiousEventModelImplCopyWith<$Res> {
  __$$ReligiousEventModelImplCopyWithImpl(
    _$ReligiousEventModelImpl _value,
    $Res Function(_$ReligiousEventModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReligiousEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? month = null,
    Object? days = null,
    Object? hadithText = freezed,
    Object? bookInfo = freezed,
  }) {
    return _then(
      _$ReligiousEventModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        month: null == month
            ? _value.month
            : month // ignore: cast_nullable_to_non_nullable
                  as int,
        days: null == days
            ? _value._days
            : days // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        hadithText: freezed == hadithText
            ? _value.hadithText
            : hadithText // ignore: cast_nullable_to_non_nullable
                  as String?,
        bookInfo: freezed == bookInfo
            ? _value.bookInfo
            : bookInfo // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ReligiousEventModelImpl extends _ReligiousEventModel {
  const _$ReligiousEventModelImpl({
    required this.id,
    required this.title,
    required this.month,
    required final List<int> days,
    this.hadithText,
    this.bookInfo,
  }) : _days = days,
       super._();

  @override
  final int id;
  @override
  final String title;
  @override
  final int month;
  final List<int> _days;
  @override
  List<int> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  @override
  final String? hadithText;
  @override
  final String? bookInfo;

  @override
  String toString() {
    return 'ReligiousEventModel(id: $id, title: $title, month: $month, days: $days, hadithText: $hadithText, bookInfo: $bookInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReligiousEventModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.month, month) || other.month == month) &&
            const DeepCollectionEquality().equals(other._days, _days) &&
            (identical(other.hadithText, hadithText) ||
                other.hadithText == hadithText) &&
            (identical(other.bookInfo, bookInfo) ||
                other.bookInfo == bookInfo));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    month,
    const DeepCollectionEquality().hash(_days),
    hadithText,
    bookInfo,
  );

  /// Create a copy of ReligiousEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReligiousEventModelImplCopyWith<_$ReligiousEventModelImpl> get copyWith =>
      __$$ReligiousEventModelImplCopyWithImpl<_$ReligiousEventModelImpl>(
        this,
        _$identity,
      );
}

abstract class _ReligiousEventModel extends ReligiousEventModel {
  const factory _ReligiousEventModel({
    required final int id,
    required final String title,
    required final int month,
    required final List<int> days,
    final String? hadithText,
    final String? bookInfo,
  }) = _$ReligiousEventModelImpl;
  const _ReligiousEventModel._() : super._();

  @override
  int get id;
  @override
  String get title;
  @override
  int get month;
  @override
  List<int> get days;
  @override
  String? get hadithText;
  @override
  String? get bookInfo;

  /// Create a copy of ReligiousEventModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReligiousEventModelImplCopyWith<_$ReligiousEventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
