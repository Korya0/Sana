import 'package:quran_library/quran_library.dart';
import 'package:sana/core/networking/api_error_handler.dart';
import 'package:sana/core/networking/api_result.dart';

abstract class IQuranRepo {
  Future<ApiResult<void>> initialize();
}

class QuranRepoImpl implements IQuranRepo {
  @override
  Future<ApiResult<void>> initialize() async {
    try {
      await QuranLibrary.init();
      return const ApiResult.success(null);
    } on Exception catch (e) {
      return ApiResult.failure(handleApiError(e));
    }
  }
}
