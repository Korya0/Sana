import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/splash/presentation/cubit/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashInitial());

  Future<void> startSplash() async {
    emit(const SplashLoading());
    // Simulate initialization or just wait for the animation
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!isClosed) {
      emit(const SplashFinished());
    }
  }
}
