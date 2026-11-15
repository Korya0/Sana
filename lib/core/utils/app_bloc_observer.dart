import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/utils/app_logger.dart';

final class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  final AppLogger logger = const AppLogger();

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    logger.error(
      '${bloc.runtimeType} error',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
