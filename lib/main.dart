import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/force_update_widget.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_router.dart';
import 'package:sana/core/services/location/cubit/location_cubit.dart';
import 'package:sana/core/services/location/data/location_repo.dart';
import 'package:sana/core/theme/style/app_theme.dart';
import 'package:sana/features/azkar/data/models/azkar_category_model.dart';
import 'package:sana/features/home/data/model/category_item.dart';
import 'package:sana/features/home/presentation/cubit/sortable_category_cubit.dart';
import 'package:sana/features/prayer/presentation/cubit/prayer_times_cubit.dart';

void main() async {
  await initializeApp();
  runApp(
    //DevicePreview(builder: (context) => SanaApp()),
    SanaApp(),
  );
}

class SanaApp extends StatelessWidget {
  const SanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocationCubit(locationRepo: sl<LocationRepo>()),
        ),
        BlocProvider(
          create: (context) => sl<PrayerTimesCubit>()..loadSettings(),
        ),

        BlocProvider(
          create: (context) =>
              sl<SortableCategoryCubit<AzkarCategoryModel>>()..loadFeatures(),
        ),
        BlocProvider(
          create: (context) =>
              sl<SortableCategoryCubit<CategoryItem>>()..loadFeatures(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: AppRouter.router,
        locale: const Locale('ar', 'EG'),
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),

              child: ForceUpdateController(child: child!),
            ),
          );
        },
      ),
    );
  }
}
