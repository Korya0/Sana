import '../../domain/entities/asma_ul_husna.dart';
import '../../domain/repositories/asma_ul_husna_repository.dart';
import '../datasources/asma_ul_husna_local_data_source.dart';

class AsmaUlHusnaRepositoryImpl implements AsmaUlHusnaRepository {
  final AsmaUlHusnaLocalDataSource localDataSource;

  AsmaUlHusnaRepositoryImpl({required this.localDataSource});

  @override
  Future<List<AsmaUlHusna>> getNames() async {
    return await localDataSource.getNames();
  }
}
