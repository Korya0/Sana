import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sana/core/di/app_providers.dart';
import 'package:sana/core/common/widgets/responsive_wrapper.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_router.dart';
import 'package:sana/core/theme/style/app_theme.dart';
import 'package:sana/features/app_update/presentation/widgets/update_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(const SanaApp());
  await initializeAppPostFrame();
}

class SanaApp extends StatelessWidget {
  const SanaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: AppRouter.router,
        locale: const Locale(AppConstants.locale, AppConstants.country),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale(AppConstants.locale, AppConstants.country),
        ],

        // Builder
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.noScaling),
            child: ResponsiveWrapper(
              child: Stack(children: [child!, const UpdateOverlay()]),
            ),
          );
        },
      ),
    );
  }
}
