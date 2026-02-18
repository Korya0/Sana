import 'package:equatable/equatable.dart';
import 'package:sana/features/hadith_search/domain/entities/hadith_entity.dart';

abstract class HadithFavoritesState extends Equatable {
  const HadithFavoritesState();
  @override
  List<Object?> get props => [];
}

class HadithFavoritesInitial extends HadithFavoritesState {}

class HadithFavoritesLoaded extends HadithFavoritesState {
  final List<HadithEntity> favorites;
  const HadithFavoritesLoaded(this.favorites);
  @override
  List<Object?> get props => [favorites];
}
