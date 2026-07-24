import 'package:sana/core/constants/app_constants.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/splash/presentation/cubits/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashInitial());

  Future<void> startSplash() async {
    emit(const SplashLoading());
    // Simulate initialization or just wait for the animation
    await Future<void>.delayed(AppConstants.splashDelay1500ms);
    if (!isClosed) {
      emit(const SplashFinished());
    }
  }
}
