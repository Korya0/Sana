part of 'hadith_search_cubit.dart';

sealed class HadithState {
  const HadithState();
}

class HadithInitial extends HadithState {
  const HadithInitial();
}

class HadithLoading extends HadithState {
  const HadithLoading();
}

class HadithSuccess extends HadithState {
  const HadithSuccess({
    required this.ahadith,
    required this.page,
    required this.query,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  final List<HadithModel> ahadith;
  final int page;
  final String query;
  final bool hasReachedMax;
  final bool isLoadingMore;

  HadithSuccess copyWith({
    List<HadithModel>? ahadith,
    int? page,
    String? query,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return HadithSuccess(
      ahadith: ahadith ?? this.ahadith,
      page: page ?? this.page,
      query: query ?? this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class HadithError extends HadithState {
  const HadithError(this.message);
  final String message;
}
