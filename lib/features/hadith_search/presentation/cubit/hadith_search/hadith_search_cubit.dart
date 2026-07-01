import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/domain/repos/i_hadith_repository.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/features/hadith_search/utils/hadith_formatter.dart';

part 'hadith_search_state.dart';

class HadithSearchCubit extends Cubit<HadithSearchState> {
  HadithSearchCubit(this._repository) : super(const HadithSearchInitial());
  final IHadithRepository _repository;
  Timer? _debounce;

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  void onSearchQueryChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      unawaited(searchHadith(query));
    });
  }

  Future<void> searchHadith(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      emit(const HadithSearchInitial());
      return;
    }

    if (trimmedQuery.length < 2) return;

    emit(const HadithSearchLoading());

    final result = await _repository.searchHadith(trimmedQuery, page: 1);

    if (isClosed) return;

    switch (result) {
      case Success(data: final ahadith):
        final processedAhadith = _processAhadith(ahadith, trimmedQuery);
        emit(
          HadithSearchSuccess(
            ahadith: processedAhadith,
            hasReachedMax: ahadith.isEmpty,
            page: 1,
            query: trimmedQuery,
          ),
        );
      case FailureResult(:final failure):
        emit(HadithSearchError(failure.message));
    }
  }

  List<HadithEntity> _processAhadith(List<HadithEntity> ahadith, String query) {
    final regex = HadithFormatter.createHighlightRegex(query);
    if (regex == null) return ahadith;

    return ahadith.map((h) {
      return h.copyWith(
        displayContent: HadithFormatter.highlightSearchQuery(
          h.hadithContent,
          regex,
        ),
      );
    }).toList();
  }

  Future<void> loadMoreHadiths() async {
    final currentState = state;
    if (currentState is HadithSearchSuccess) {
      if (currentState.hasReachedMax || currentState.isLoadingMore) return;

      emit(currentState.copyWith(isLoadingMore: true));
      final nextPage = currentState.page + 1;

      final result = await _repository.searchHadith(
        currentState.query,
        page: nextPage,
      );

      if (isClosed) return;

      switch (result) {
        case Success(data: final newHadiths):
          if (newHadiths.isEmpty) {
            emit(
              currentState.copyWith(
                hasReachedMax: true,
                isLoadingMore: false,
              ),
            );
          } else {
            final processedNewHadiths = _processAhadith(
              newHadiths,
              currentState.query,
            );
            emit(
              currentState.copyWith(
                ahadith: [...currentState.ahadith, ...processedNewHadiths],
                page: nextPage,
                isLoadingMore: false,
                hasReachedMax: false,
              ),
            );
          }
        case FailureResult():
          emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }
}
