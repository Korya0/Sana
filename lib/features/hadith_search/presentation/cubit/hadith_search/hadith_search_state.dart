part of 'hadith_search_cubit.dart';

@freezed
class HadithState with _$HadithState {
  const factory HadithState.initial() = HadithInitial;
  const factory HadithState.loading() = HadithLoading;
  const factory HadithState.success({
    required List<HadithEntity> ahadith,
    required int page,
    required String query,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isLoadingMore,
  }) = HadithSuccess;
  const factory HadithState.error(String message) = HadithError;
}
