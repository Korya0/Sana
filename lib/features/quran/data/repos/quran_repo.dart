import 'package:sana/core/constants/constants.dart';
import 'dart:async';
import 'package:quran_library/quran_library.dart';
import 'package:sana/core/error/error.dart';
import 'package:sana/core/networking/result.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/quran/domain/repos/i_quran_repo.dart';

class QuranRepoImpl implements IQuranRepo {
  @override
  Future<Result<void>> initialize() async {
    try {
      await QuranLibrary.init();
      return const Result.success(null);
    } on Exception catch (e, stack) {
      unawaited(
        AppLogger.error(
          'QuranLibrary Init Error',
          error: e,
          stackTrace: stack,
          report: true,
        ),
      );
      return const Result.failure(
        UnknownFailure(message: AppStrings.quranInitError),
      );
    }
  }
}
