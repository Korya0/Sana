import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sana/app_providers.dart';
import 'package:sana/core/common/widgets/responsive_wrapper.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_router.dart';
import 'package:sana/core/theme/style/app_theme.dart';
import 'package:sana/features/app_update/presentation/widgets/update_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(const SanaApp());
  // WARNING: Initializing services after runApp can lead to race conditions
  // if a screen depends on these services before they are ready.
  // Consider adding a loading state in the UI if needed.
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
        locale: const Locale('ar', 'EG'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar', 'EG'),
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
