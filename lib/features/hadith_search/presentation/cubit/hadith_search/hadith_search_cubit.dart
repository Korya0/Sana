import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/hadith_search/data/models/hadith_model.dart';
import 'package:sana/features/hadith_search/data/repos/i_hadith_repository.dart';

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

  Future<void> searchHadith(String query) async {
    final trimmedQuery = query.trim();
    
    if (trimmedQuery.isEmpty) {
      emit(const HadithInitial());
      return;
    }

    if (trimmedQuery.length < 2) return;

    emit(const HadithLoading());

    final result = await _repository.searchHadith(trimmedQuery);

    result.when(
      success: (ahadith) {
        if (!isClosed) {
          emit(
            HadithSuccess(
              ahadith: ahadith,
              hasReachedMax: ahadith.isEmpty,
              page: 1,
              query: trimmedQuery,
            ),
          );
        }
      },
      failure: (failure) {
        if (!isClosed) emit(HadithError(failure.message));
      },
    );
  }

  Future<void> loadMoreHadiths() async {
    final currentState = state;
    if (currentState is HadithSuccess) {
      if (currentState.hasReachedMax || currentState.isLoadingMore) return;

      emit(currentState.copyWith(isLoadingMore: true));
      final nextPage = currentState.page + 1;

      final result = await _repository.searchHadith(currentState.query, page: nextPage);

      result.when(
        success: (newHadiths) {
          if (!isClosed) {
            if (newHadiths.isEmpty) {
              emit(
                currentState.copyWith(
                  hasReachedMax: true,
                  isLoadingMore: false,
                ),
              );
            } else {
              emit(
                currentState.copyWith(
                  ahadith: [...currentState.ahadith, ...newHadiths],
                  page: nextPage,
                  isLoadingMore: false,
                  hasReachedMax: false,
                ),
              );
            }
          }
        },
        failure: (failure) {
          if (!isClosed) {
            emit(currentState.copyWith(isLoadingMore: false));
          }
        },
      );
    }
  }
}
