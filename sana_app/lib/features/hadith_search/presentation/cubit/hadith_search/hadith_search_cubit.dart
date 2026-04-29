import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';
import 'package:sana/features/hadith_search/data/repos/i_hadith_repository.dart';
import 'package:sana/core/networking/api_result.dart';
import 'package:sana/features/hadith_search/utils/hadith_formatter.dart';

part 'hadith_search_state.dart';

class HadithCubit extends Cubit<HadithState> {
  HadithCubit(this._repository) : super(const HadithInitial());
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

  List<HadithModel> _processAhadith(List<HadithModel> ahadith, String query) {
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

  Future<void> searchHadith(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      emit(const HadithInitial());
      return;
    }

    if (trimmedQuery.length < 2) return;

    emit(const HadithLoading());

    final result = await _repository.searchHadith(trimmedQuery);

    switch (result) {
      case Success(data: final ahadith):
        if (!isClosed) {
          final processedAhadith = _processAhadith(ahadith, trimmedQuery);
          emit(
            HadithSuccess(
              ahadith: processedAhadith,
              hasReachedMax: ahadith.isEmpty,
              page: 1,
              query: trimmedQuery,
            ),
          );
        }
      case ApiFailure(:final failure):
        if (!isClosed) emit(HadithError(failure.message));
    }
  }

  Future<void> loadMoreHadiths() async {
    final currentState = state;
    if (currentState is HadithSuccess) {
      if (currentState.hasReachedMax || currentState.isLoadingMore) return;

      emit(currentState.copyWith(isLoadingMore: true));
      final nextPage = currentState.page + 1;

      final result = await _repository.searchHadith(
        currentState.query,
        page: nextPage,
      );

      switch (result) {
        case Success(data: final newHadiths):
          if (!isClosed) {
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
          }
        case ApiFailure():
          if (!isClosed) {
            emit(currentState.copyWith(isLoadingMore: false));
          }
      }
    }
  }
}
