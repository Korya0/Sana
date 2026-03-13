import 'package:freezed_annotation/freezed_annotation.dart';

part 'hadith_entity.freezed.dart';

@freezed
class HadithEntity with _$HadithEntity {
  const factory HadithEntity({
    required String hadithContent,
    String? narrator,
    String? scholar,
    String? source,
    String? page,
    String? judgment,
  }) = _HadithEntity;
}
