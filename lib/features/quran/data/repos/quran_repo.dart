import 'package:quran_library/quran_library.dart';
import 'package:sana/core/networking/api_error_handler.dart';
import 'package:sana/core/networking/result.dart';

abstract class IQuranRepo {
  Future<Result<void>> initialize();
}

class QuranRepoImpl implements IQuranRepo {
  @override
  Future<Result<void>> initialize() async {
    try {
      await QuranLibrary.init();
      return const Result.success(null);
    } on Exception catch (e) {
      return Result.failure(handleApiError(e));
    }
  }
}
