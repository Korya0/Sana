import '../../domain/entities/asma_ul_husna.dart';

abstract class AsmaUlHusnaRepository {
  Future<List<AsmaUlHusna>> getNames();
}
