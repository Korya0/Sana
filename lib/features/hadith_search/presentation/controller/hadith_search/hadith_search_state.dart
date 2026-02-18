import 'package:equatable/equatable.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';

abstract class HadithState extends Equatable {
  const HadithState();
  @override
  List<Object?> get props => [];
}

class HadithInitial extends HadithState {}

class HadithLoading extends HadithState {}

class HadithSuccess extends HadithState {
  final List<HadithEntity> ahadith;
  final bool hasReachedMax;
  final int page;
  final String query;
  final bool isLoadingMore;

  const HadithSuccess({
    required this.ahadith,
    this.hasReachedMax = false,
    required this.page,
    required this.query,
    this.isLoadingMore = false,
  });

  HadithSuccess copyWith({
    List<HadithEntity>? ahadith,
    bool? hasReachedMax,
    int? page,
    String? query,
    bool? isLoadingMore,
  }) {
    return HadithSuccess(
      ahadith: ahadith ?? this.ahadith,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      query: query ?? this.query,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    ahadith,
    hasReachedMax,
    page,
    query,
    isLoadingMore,
  ];
}

class HadithError extends HadithState {
  final String message;
  final String? technicalMessage;

  const HadithError(this.message, {this.technicalMessage});

  @override
  List<Object?> get props => [message, technicalMessage];
}
