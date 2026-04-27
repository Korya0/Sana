import 'package:sana/core/networking/api_result.dart';
import 'package:sana/features/quran/data/repos/quran_repo.dart';

class InitializeQuranUseCase {
  const InitializeQuranUseCase(this._repository);
  final IQuranRepo _repository;

  Future<ApiResult<void>> call() async {
    return _repository.initialize();
  }
}
