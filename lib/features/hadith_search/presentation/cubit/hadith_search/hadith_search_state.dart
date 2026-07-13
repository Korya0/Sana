import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';

@immutable
sealed class HadithSearchState {
  const HadithSearchState();
}

class HadithSearchInitial extends HadithSearchState {
  const HadithSearchInitial();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is HadithSearchInitial;

  @override
  int get hashCode => 0;
}

class HadithSearchLoading extends HadithSearchState {
  const HadithSearchLoading();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is HadithSearchLoading;

  @override
  int get hashCode => 1;
}

class HadithSearchSuccess extends HadithSearchState {
  const HadithSearchSuccess({
    required this.ahadith,
    required this.page,
    required this.query,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  final List<HadithEntity> ahadith;
  final int page;
  final String query;
  final bool hasReachedMax;
  final bool isLoadingMore;

  HadithSearchSuccess copyWith({
    List<HadithEntity>? ahadith,
    int? page,
    String? query,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return HadithSearchSuccess(
      ahadith: ahadith ?? this.ahadith,
      page: page ?? this.page,
      query: query ?? this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HadithSearchSuccess &&
        other.page == page &&
        other.query == query &&
        other.hasReachedMax == hasReachedMax &&
        other.isLoadingMore == isLoadingMore &&
        const ListEquality<HadithEntity>().equals(other.ahadith, ahadith);
  }

  @override
  int get hashCode =>
      page.hashCode ^
      query.hashCode ^
      hasReachedMax.hashCode ^
      isLoadingMore.hashCode ^
      const ListEquality<HadithEntity>().hash(ahadith);
}

class HadithSearchError extends HadithSearchState {
  const HadithSearchError(this.message);
  final String message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HadithSearchError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
