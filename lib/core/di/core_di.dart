import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:sana/core/networking/dio_factory.dart';
import 'package:sana/core/services/analytics/analytics_service.dart';
import 'package:sana/core/services/analytics/dummy_analytics_service.dart';
import 'package:sana/core/services/analytics/firebase_analytics_service.dart';
import 'package:sana/core/services/database/firestore_database_client.dart';
import 'package:sana/core/services/database/i_nosql_database_client.dart';
import 'package:sana/core/services/local_storage/i_local_storage_service.dart';
import 'package:sana/core/services/local_storage/local_storage_service_impl.dart';
import 'package:sana/core/services/location_manager/data/datasources/remote/location_api_client.dart';
import 'package:sana/core/utils/utils.dart';

Future<void> setupCoreDependencies(GetIt sl) async {
  try {
    await Hive.initFlutter().timeout(const Duration(seconds: 2));
  } on Exception catch (e, stack) {
    unawaited(
      AppLogger.reportToFirebase(
        'Hive.initFlutter delayed or failed',
        error: e,
        stackTrace: stack,
      ),
    );
  }

  late Box<dynamic> settingsBox;
  try {
    settingsBox = await Hive.openBox<dynamic>('app_settings').timeout(
      const Duration(seconds: 5),
      onTimeout: () async {
        unawaited(
          AppLogger.warn('Hive openBox timeout, attempting recovery...'),
        );
        await Hive.deleteBoxFromDisk('app_settings');
        return Hive.openBox<dynamic>('app_settings').timeout(
          const Duration(seconds: 2),
          onTimeout: () =>
              throw Exception('Critical: Hive completely unresponsive.'),
        );
      },
    );
  } on Exception catch (e, stack) {
    unawaited(
      AppLogger.reportToFirebase(
        'Failed to open app_settings box, attempting recovery...',
        error: e,
        stackTrace: stack,
      ),
    );
    try {
      await Hive.deleteBoxFromDisk('app_settings');
      settingsBox = await Hive.openBox<dynamic>('app_settings');
    } on Exception catch (e2, stack2) {
      unawaited(
        AppLogger.reportToFirebase(
          'Failed to recover app_settings box',
          error: e2,
          stackTrace: stack2,
        ),
      );
      rethrow;
    }
  }

  final localStorageService = LocalStorageServiceImpl(settingsBox);

  sl
    ..registerLazySingleton<Box<dynamic>>(() => settingsBox)
    ..registerLazySingleton<ILocalStorageService>(() => localStorageService)
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton<FirebaseRemoteConfig>(
      () => FirebaseRemoteConfig.instance,
    )
    ..registerLazySingleton<IAnalyticsService>(
      () => Firebase.apps.isNotEmpty
          ? FirebaseAnalyticsServiceImpl(FirebaseAnalytics.instance)
          : DummyAnalyticsService(),
    )
    ..registerLazySingleton<Dio>(DioFactory.getDio)
    ..registerLazySingleton<LocationApiClient>(
      () => LocationApiClient(
        sl<Dio>(),
        baseUrl: 'https://nominatim.openstreetmap.org/',
      ),
    )
    ..registerLazySingleton<INoSqlDatabaseClient>(
      () => FirestoreDatabaseClient(sl<FirebaseFirestore>()),
    )
    ..registerLazySingleton<IDateTimeProvider>(DateTimeProviderImpl.new);
}
