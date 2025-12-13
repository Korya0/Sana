import '../entities/asma_ul_husna.dart';
import '../repositories/asma_ul_husna_repository.dart';

class GetAsmaUlHusnaUseCase {
  final AsmaUlHusnaRepository repository;

  GetAsmaUlHusnaUseCase({required this.repository});

  Future<List<AsmaUlHusna>> call() async {
    return await repository.getNames();
  }
}
