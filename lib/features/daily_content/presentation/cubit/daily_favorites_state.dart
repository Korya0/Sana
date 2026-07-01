import 'package:flutter/foundation.dart';
import 'package:sana/features/daily_content/data/models/daily_content_model.dart';

@immutable
class DailyFavoritesState {
  const DailyFavoritesState({this.favorites = const []});
  final List<DailyContentModel> favorites;
}
