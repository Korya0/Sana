import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sana/core/app_cubit/theme/theme_cubit.dart';
import 'package:sana/core/app_cubit/theme/theme_state.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/router/app_router.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/utils/context_extension.dart';

class SanaApp extends StatelessWidget {
  const SanaApp({super.key});

  // Builds app
  @override
  Widget build(BuildContext context) => BlocProvider<ThemeCubit>.value(
    value: sl<ThemeCubit>(),

    // App shell (theme state)
    child: BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) => MaterialApp.router(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,

        // Theme
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: switch (state) {
          ThemeInitial() => ThemeMode.system,
          ThemeChanged(:final mode) => mode,
        },

        // Locale
        locale: const Locale(AppConstants.arLocaleCode),
        supportedLocales: const [Locale(AppConstants.arLocaleCode)],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        // Router
        routerConfig: AppRouter.router,

        // App wrapper
        builder: (context, child) {
          // Init sizes
          AppSize.init(context);

          // System navigation bar style
          return context.systemUiOverlay(child ?? const SizedBox.shrink());
        },
      ),
    ),
  );
}
