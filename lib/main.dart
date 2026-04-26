// import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sana/core/common/layout/responsive_wrapper.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_router.dart';
import 'package:sana/core/theme/style/app_theme.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/features/app_date/presentation/controller/app_date_cubit.dart';
import 'package:sana/features/app_update/presentation/controller/app_update_cubit.dart';
import 'package:sana/features/app_update/presentation/widgets/update_overlay.dart';
import 'package:sana/features/location_manager/presentation/controller/location_permission/location_cubit.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(
    // DevicePreview(
    //   builder: (context) => const SanaApp(),
    // ),
    const SanaApp(),
  );
  await initializeAppPostFrame();
}

class SanaApp extends StatelessWidget {
  const SanaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LocationCubit>()),
        BlocProvider(create: (_) => sl<AppDateCubit>()),
        BlocProvider(create: (_) => sl<AppUpdateCubit>()),
        BlocProvider(create: (_) => sl<PrayerTimesCubit>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: AppRouter.router,

        //Localization
        locale: const Locale(AppConstants.locale, AppConstants.country),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale(AppConstants.locale, AppConstants.country),
        ],

        //builder
        builder: (context, child) {
          return GestureDetector(
            onTap: context.unfocus,
            child: MediaQuery(
              data: context.noScalingMediaQuery,
              child: ResponsiveWrapper(
                child: Stack(children: [child!, const UpdateOverlay()]),
              ),
            ),
          );
        },
      ),
    );
  }
}
