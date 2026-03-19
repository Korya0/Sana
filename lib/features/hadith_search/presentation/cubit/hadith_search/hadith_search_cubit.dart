import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';
import 'package:sana/features/hadith_search/domain/use_cases/search_hadith_use_case.dart';

part 'hadith_search_cubit.freezed.dart';
part 'hadith_search_state.dart';

class HadithCubit extends Cubit<HadithState> {
  HadithCubit(this._searchHadithUseCase) : super(const HadithState.initial());
  final SearchHadithUseCase _searchHadithUseCase;

  Future<void> searchHadith(String query) async {
    if (query.isEmpty) {
      emit(const HadithState.initial());
      return;
    }

    emit(const HadithState.loading());

    final result = await _searchHadithUseCase(query);

    result.when(
      success: (ahadith) {
        if (!isClosed) {
          emit(
            HadithState.success(
              ahadith: ahadith,
              hasReachedMax: ahadith.isEmpty,
              page: 1,
              query: query,
            ),
          );
        }
      },
      failure: (failure) {
        if (!isClosed) emit(HadithState.error(failure.message));
      },
    );
  }

  Future<void> loadMoreHadiths() async {
    await state.maybeWhen(
      success: (ahadith, page, query, hasReachedMax, isLoadingMore) async {
        if (hasReachedMax || isLoadingMore) return;

        emit((state as HadithSuccess).copyWith(isLoadingMore: true));
        final nextPage = page + 1;

        final result = await _searchHadithUseCase(query, page: nextPage);

        result.when(
          success: (newHadiths) {
            if (!isClosed) {
              if (newHadiths.isEmpty) {
                emit(
                  (state as HadithSuccess).copyWith(
                    hasReachedMax: true,
                    isLoadingMore: false,
                  ),
                );
              } else {
                emit(
                  (state as HadithSuccess).copyWith(
                    ahadith: [...ahadith, ...newHadiths],
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
              emit((state as HadithSuccess).copyWith(isLoadingMore: false));
            }
          },
        );
      },
      orElse: () {},
    );
  }
}
