import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sana/features/azkar/data/datasources/azkar_local_data_source_impl.dart';
import 'package:sana/features/azkar/data/datasources/i_azkar_local_data_source.dart';
import 'package:sana/features/azkar/data/datasources/reminder_local_data_source.dart';
import 'package:sana/features/azkar/data/datasources/reminder_local_data_source_impl.dart';
import 'package:sana/features/azkar/data/models/reminder_model.dart';
import 'package:sana/features/azkar/data/repositories/azkar_repository_impl.dart';
import 'package:sana/features/azkar/data/repositories/reading_settings_repository_impl.dart';
import 'package:sana/features/azkar/data/repositories/reminder_repository_impl.dart';
import 'package:sana/features/azkar/domain/repositories/i_azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/i_reading_settings_repository.dart';
import 'package:sana/features/azkar/domain/repositories/reminder_repository.dart';
import 'package:sana/features/azkar/domain/usecases/create_reminder_use_case.dart';
import 'package:sana/features/azkar/domain/usecases/delete_reminder_use_case.dart';
import 'package:sana/features/azkar/domain/usecases/get_azkar_by_category_usecase.dart';
import 'package:sana/features/azkar/domain/usecases/get_categories_usecase.dart';
import 'package:sana/features/azkar/domain/usecases/get_reading_settings_usecase.dart';
import 'package:sana/features/azkar/domain/usecases/get_reminders_use_case.dart';
import 'package:sana/features/azkar/domain/usecases/toggle_reminder_use_case.dart';
import 'package:sana/features/azkar/domain/usecases/update_reading_settings_usecase.dart';
import 'package:sana/features/azkar/domain/usecases/update_reminder_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reading_settings/reading_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/reminder/reminder_cubit.dart';

Future<void> setupAzkarDependencies(GetIt sl) async {
  // --- Register Hive Adapter ---
  if (!Hive.isAdapterRegistered(ReminderModel.typeId)) {
    Hive.registerAdapter(ReminderModelAdapter());
  }

  // --- Reminder Hive Box ---
  final remindersBox = await Hive.openBox<ReminderModel>(
    ReminderLocalDataSourceImpl.boxName,
  );

  sl
    // Data Sources
    ..registerLazySingleton<IAzkarLocalDataSource>(
      AzkarLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<ReminderLocalDataSource>(
      () => ReminderLocalDataSourceImpl(remindersBox),
    )
    // Repositories
    ..registerLazySingleton<IAzkarRepository>(
      () => AzkarRepositoryImpl(sl()),
    )
    ..registerLazySingleton<IReadingSettingsRepository>(
      () => ReadingSettingsRepositoryImpl(sl()),
    )
    ..registerLazySingleton<ReminderRepository>(
      () => ReminderRepositoryImpl(sl()),
    )
    // UseCases
    ..registerLazySingleton(
      () => GetCategoriesUseCase(sl()),
    )
    ..registerLazySingleton(
      () => GetAzkarByCategoryUseCase(sl()),
    )
    ..registerLazySingleton(
      () => GetReadingSettingsUseCase(sl()),
    )
    ..registerLazySingleton(
      () => UpdateReadingSettingsUseCase(sl()),
    )
    ..registerLazySingleton(() => GetRemindersUseCase(sl()))
    ..registerLazySingleton(() => CreateReminderUseCase(sl(), sl()))
    ..registerLazySingleton(() => UpdateReminderUseCase(sl(), sl()))
    ..registerLazySingleton(() => DeleteReminderUseCase(sl(), sl()))
    ..registerLazySingleton(() => ToggleReminderUseCase(sl(), sl()))
    // Cubits
    ..registerFactory(() => AzkarCategoriesCubit(sl()))
    ..registerFactory(
      () => AzkarCubit(
        sl(),
        sl(),
      ),
    )
    ..registerFactory(() => ReadingSettingsCubit(sl(), sl()))
    ..registerFactory(
      () => ReminderCubit(
        getReminders: sl(),
        createReminder: sl(),
        updateReminder: sl(),
        deleteReminder: sl(),
        toggleReminder: sl(),
        permissionsManager: sl(),
        notificationService: sl(),
      ),
    );
}
