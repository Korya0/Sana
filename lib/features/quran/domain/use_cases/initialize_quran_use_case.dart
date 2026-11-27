import 'package:quran_library/quran_library.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/failure.dart';
import 'package:sana/core/error/result.dart';

class InitializeQuranUseCase {
  const InitializeQuranUseCase();

  // Initialize once for the app session
  Future<Result<void>> call() async {
    try {
      await QuranLibrary.init();
      return const Success<void>(null);
    } catch (_) {
      return const FailureResult<void>(
        GeneralFailure(message: AppStrings.quranInitError),
      );
    }
  }
}
