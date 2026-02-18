import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/hadith_search/domain/use_cases/search_hadith_use_case.dart';
import 'package:sana/features/hadith_search/presentation/controller/hadith_search/hadith_search_state.dart';

class HadithCubit extends Cubit<HadithState> {
  final SearchHadithUseCase _searchHadithUseCase;

  HadithCubit(this._searchHadithUseCase) : super(HadithInitial());

  Future<void> searchHadith(String query) async {
    if (query.isEmpty) {
      emit(HadithInitial());
      return;
    }

    emit(HadithLoading());

    final result = await _searchHadithUseCase(query);

    result.fold(
      (failure) => emit(
        HadithError(
          failure.message,
          technicalMessage: failure.technicalMessage,
        ),
      ),
      (ahadith) {
        emit(
          HadithSuccess(
            ahadith: ahadith,
            hasReachedMax: ahadith.isEmpty,
            page: 1,
            query: query,
          ),
        );
      },
    );
  }

  Future<void> loadMoreHadiths() async {
    final currentState = state;
    if (currentState is HadithSuccess &&
        !currentState.hasReachedMax &&
        !currentState.isLoadingMore) {
      emit(currentState.copyWith(isLoadingMore: true));
      final nextPage = currentState.page + 1;

      final result = await _searchHadithUseCase(
        currentState.query,
        page: nextPage,
      );

      result.fold(
        (failure) {
          emit(currentState.copyWith(isLoadingMore: false));
        },
        (newHadiths) {
          if (newHadiths.isEmpty) {
            emit(
              currentState.copyWith(hasReachedMax: true, isLoadingMore: false),
            );
          } else {
            emit(
              currentState.copyWith(
                ahadith: List.of(currentState.ahadith)..addAll(newHadiths),
                page: nextPage,
                isLoadingMore: false,
                hasReachedMax: false,
              ),
            );
          }
        },
      );
    }
  }
}
