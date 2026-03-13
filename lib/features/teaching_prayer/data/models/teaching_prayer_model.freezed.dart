// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teaching_prayer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TeachingPrayerSection {
  String get category => throw _privateConstructorUsedError;
  List<TeachingPrayerTopic> get topics => throw _privateConstructorUsedError;

  /// Create a copy of TeachingPrayerSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeachingPrayerSectionCopyWith<TeachingPrayerSection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeachingPrayerSectionCopyWith<$Res> {
  factory $TeachingPrayerSectionCopyWith(
    TeachingPrayerSection value,
    $Res Function(TeachingPrayerSection) then,
  ) = _$TeachingPrayerSectionCopyWithImpl<$Res, TeachingPrayerSection>;
  @useResult
  $Res call({String category, List<TeachingPrayerTopic> topics});
}

/// @nodoc
class _$TeachingPrayerSectionCopyWithImpl<
  $Res,
  $Val extends TeachingPrayerSection
>
    implements $TeachingPrayerSectionCopyWith<$Res> {
  _$TeachingPrayerSectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeachingPrayerSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null, Object? topics = null}) {
    return _then(
      _value.copyWith(
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            topics: null == topics
                ? _value.topics
                : topics // ignore: cast_nullable_to_non_nullable
                      as List<TeachingPrayerTopic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeachingPrayerSectionImplCopyWith<$Res>
    implements $TeachingPrayerSectionCopyWith<$Res> {
  factory _$$TeachingPrayerSectionImplCopyWith(
    _$TeachingPrayerSectionImpl value,
    $Res Function(_$TeachingPrayerSectionImpl) then,
  ) = __$$TeachingPrayerSectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String category, List<TeachingPrayerTopic> topics});
}

/// @nodoc
class __$$TeachingPrayerSectionImplCopyWithImpl<$Res>
    extends
        _$TeachingPrayerSectionCopyWithImpl<$Res, _$TeachingPrayerSectionImpl>
    implements _$$TeachingPrayerSectionImplCopyWith<$Res> {
  __$$TeachingPrayerSectionImplCopyWithImpl(
    _$TeachingPrayerSectionImpl _value,
    $Res Function(_$TeachingPrayerSectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeachingPrayerSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? category = null, Object? topics = null}) {
    return _then(
      _$TeachingPrayerSectionImpl(
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        topics: null == topics
            ? _value._topics
            : topics // ignore: cast_nullable_to_non_nullable
                  as List<TeachingPrayerTopic>,
      ),
    );
  }
}

/// @nodoc

class _$TeachingPrayerSectionImpl implements _TeachingPrayerSection {
  const _$TeachingPrayerSectionImpl({
    required this.category,
    required final List<TeachingPrayerTopic> topics,
  }) : _topics = topics;

  @override
  final String category;
  final List<TeachingPrayerTopic> _topics;
  @override
  List<TeachingPrayerTopic> get topics {
    if (_topics is EqualUnmodifiableListView) return _topics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topics);
  }

  @override
  String toString() {
    return 'TeachingPrayerSection(category: $category, topics: $topics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeachingPrayerSectionImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._topics, _topics));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    category,
    const DeepCollectionEquality().hash(_topics),
  );

  /// Create a copy of TeachingPrayerSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeachingPrayerSectionImplCopyWith<_$TeachingPrayerSectionImpl>
  get copyWith =>
      __$$TeachingPrayerSectionImplCopyWithImpl<_$TeachingPrayerSectionImpl>(
        this,
        _$identity,
      );
}

abstract class _TeachingPrayerSection implements TeachingPrayerSection {
  const factory _TeachingPrayerSection({
    required final String category,
    required final List<TeachingPrayerTopic> topics,
  }) = _$TeachingPrayerSectionImpl;

  @override
  String get category;
  @override
  List<TeachingPrayerTopic> get topics;

  /// Create a copy of TeachingPrayerSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeachingPrayerSectionImplCopyWith<_$TeachingPrayerSectionImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TeachingPrayerTopic {
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  /// Create a copy of TeachingPrayerTopic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeachingPrayerTopicCopyWith<TeachingPrayerTopic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeachingPrayerTopicCopyWith<$Res> {
  factory $TeachingPrayerTopicCopyWith(
    TeachingPrayerTopic value,
    $Res Function(TeachingPrayerTopic) then,
  ) = _$TeachingPrayerTopicCopyWithImpl<$Res, TeachingPrayerTopic>;
  @useResult
  $Res call({String title, String content});
}

/// @nodoc
class _$TeachingPrayerTopicCopyWithImpl<$Res, $Val extends TeachingPrayerTopic>
    implements $TeachingPrayerTopicCopyWith<$Res> {
  _$TeachingPrayerTopicCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeachingPrayerTopic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? title = null, Object? content = null}) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeachingPrayerTopicImplCopyWith<$Res>
    implements $TeachingPrayerTopicCopyWith<$Res> {
  factory _$$TeachingPrayerTopicImplCopyWith(
    _$TeachingPrayerTopicImpl value,
    $Res Function(_$TeachingPrayerTopicImpl) then,
  ) = __$$TeachingPrayerTopicImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String content});
}

/// @nodoc
class __$$TeachingPrayerTopicImplCopyWithImpl<$Res>
    extends _$TeachingPrayerTopicCopyWithImpl<$Res, _$TeachingPrayerTopicImpl>
    implements _$$TeachingPrayerTopicImplCopyWith<$Res> {
  __$$TeachingPrayerTopicImplCopyWithImpl(
    _$TeachingPrayerTopicImpl _value,
    $Res Function(_$TeachingPrayerTopicImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeachingPrayerTopic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? title = null, Object? content = null}) {
    return _then(
      _$TeachingPrayerTopicImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$TeachingPrayerTopicImpl implements _TeachingPrayerTopic {
  const _$TeachingPrayerTopicImpl({required this.title, required this.content});

  @override
  final String title;
  @override
  final String content;

  @override
  String toString() {
    return 'TeachingPrayerTopic(title: $title, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeachingPrayerTopicImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, content);

  /// Create a copy of TeachingPrayerTopic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeachingPrayerTopicImplCopyWith<_$TeachingPrayerTopicImpl> get copyWith =>
      __$$TeachingPrayerTopicImplCopyWithImpl<_$TeachingPrayerTopicImpl>(
        this,
        _$identity,
      );
}

abstract class _TeachingPrayerTopic implements TeachingPrayerTopic {
  const factory _TeachingPrayerTopic({
    required final String title,
    required final String content,
  }) = _$TeachingPrayerTopicImpl;

  @override
  String get title;
  @override
  String get content;

  /// Create a copy of TeachingPrayerTopic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeachingPrayerTopicImplCopyWith<_$TeachingPrayerTopicImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
