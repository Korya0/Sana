// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/force_update_widget.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_router.dart';
import 'package:sana/core/services/date_gregorian_and_hijri/cubit/app_date_cubit.dart';
import 'package:sana/core/services/location/cubit/location_name/location_name_cubit.dart';
import 'package:sana/core/services/location/cubit/location_permission/location_cubit.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/theme/style/app_theme.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(
    /* DevicePreview(
      builder: (BuildContext context) {
        return const SanaApp();
      },
    ),*/
    const SanaApp(),
  );
  await initializeAppPostFrame();
}

class SanaApp extends StatelessWidget {
  const SanaApp({super.key});
  //
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<LocationNameCubit>()
                ..loadLocation(locale: AppConstants.locale),
        ),
        BlocProvider(create: (context) => sl<AppDateCubit>()),
        BlocProvider(create: (context) => sl<LocationCubit>()),
        BlocProvider(
          create: (context) => sl<PrayerTimesCubit>()..loadSettings(),
        ),
        BlocProvider(
          create: (context) => sl<DailyContentCubit>()..loadDailyContent(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: AppRouter.router,
        locale: const Locale('ar', 'EG'),
        builder: (context, child) {
          final size = MediaQuery.of(context).size;
          final bool isWideScreen = size.width > 600;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              // تعطيل تكبير الخط وتحديد الحجم الافتراضي للحاوية في المتصفح
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.noScaling),
              child: Scaffold(
                backgroundColor: isWideScreen
                    ? AppColors.secondaryBackground
                    : AppColors.scaffoldBackground,
                body: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWideScreen ? 500 : size.width,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground,
                        boxShadow: isWideScreen
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ]
                            : null,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return MediaQuery(
                            // إخبار التطبيق بالحجم الحقيقي المتاح له داخل الحاوية وليس حجم المتصفح بالكامل
                            data: MediaQuery.of(context).copyWith(
                              size: Size(
                                constraints.maxWidth,
                                constraints.maxHeight,
                              ),
                            ),
                            child: ForceUpdateController(child: child!),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
