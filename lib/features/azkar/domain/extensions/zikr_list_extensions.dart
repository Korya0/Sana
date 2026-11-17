import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';

// Finds a zikr by id
extension ZikrListExtensions on List<ZikrEntity> {
  ZikrEntity? byId(int id) {
    for (final zikr in this) {
      if (zikr.id == id) return zikr;
    }
    return null;
  }
}
