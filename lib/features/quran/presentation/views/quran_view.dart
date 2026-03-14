import 'package:flutter/material.dart';
import 'package:quran_library/quran_library.dart';
import 'package:sana/core/common/widgets/app_error_widget.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/app_logger.dart';

class QuranView extends StatefulWidget {
  const QuranView({super.key});

  @override
  State<QuranView> createState() => _QuranViewState();
}

class _QuranViewState extends State<QuranView> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeQuran();
  }

  Future<void> _initializeQuran() async {
    try {
      await QuranLibrary.init();
    } on Exception catch (e, stack) {
      await AppLogger.error(
        'Failed to initialize QuranLibrary',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: AppColors.quranBackground,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: AppColors.quranBackground,
            body: AppErrorWidget(
              onRetry: () {
                setState(() {
                  _initFuture = _initializeQuran();
                });
              },
            ),
          );
        }

        return Stack(
          children: [
            QuranLibraryScreen(
              parentContext: context,
              isDark: true,
              backgroundColor: AppColors.quranBackground,
              textColor: AppColors.textWhite,
              ayahSelectedBackgroundColor: AppColors.gold.withValues(
                alpha: 0.3,
              ),
              ayahIconColor: AppColors.gold,
              topBottomQuranStyle: const TopBottomQuranStyle(
                juzTextColor: AppColors.gold,
                hizbTextColor: AppColors.gold,
                sajdaNameColor: AppColors.gold,
                surahNameColor: AppColors.gold,
                pageNumberColor: AppColors.gold,
              ),
            ),
            Positioned(
              top: 5,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    shape: const StadiumBorder(),
                    child: InkWell(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        child: Text(
                          AppStrings.azkarExitDialogConfirmText,
                          style: AppTextStyles.font16W600White(context)
                              .copyWith(
                                color: AppColors.red,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
