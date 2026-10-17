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

class SanaApp extends StatelessWidget {
  const SanaApp({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<ThemeCubit>.value(
    value: sl<ThemeCubit>(),
    child: BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) => MaterialApp.router(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: switch (state) {
          ThemeInitial() => ThemeMode.system,
          ThemeChanged(:final mode) => mode,
        },
        locale: const Locale(AppConstants.arLocaleCode),
        supportedLocales: const [Locale(AppConstants.arLocaleCode)],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: AppRouter.router,
        builder: (context, child) {
          AppSize.init(context);
          return child ?? const SizedBox.shrink();
        },
      ),
    ),
  );
}
