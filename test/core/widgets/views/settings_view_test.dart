import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/app_cubit/theme/theme_cubit.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/services/local_storage/app_local_storage.dart';
import 'package:sana/core/services/local_storage/app_storage_keys.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/core/widgets/views/settings_view.dart';

const _destinationKey = Key('qibla-destination');

void main() {
  testWidgets('the qibla shortcut is one pressable that pushes qibla', (
    tester,
  ) async {
    final cubit = ThemeCubit(_FakeStorage());
    addTearDown(cubit.close);

    await _pump(tester, cubit: cubit);

    expect(find.byType(AppPressable), findsOneWidget);
    expect(find.bySemanticsLabel(AppStrings.qiblaHeader), findsOneWidget);
    expect(find.widgetWithText(ListTile, AppStrings.qiblaHeader), findsNothing);

    final handle = tester.ensureSemantics();
    final node = tester.getSemantics(
      find.bySemanticsLabel(AppStrings.qiblaHeader),
    );
    expect(node.flagsCollection.isButton, isTrue);
    handle.dispose();

    await tester.tap(find.bySemanticsLabel(AppStrings.qiblaHeader));
    await tester.pumpAndSettle();

    expect(find.byKey(_destinationKey), findsOneWidget);
  });

  testWidgets('the theme dropdown changes the mode and saves it', (tester) async {
    final storage = _FakeStorage();
    final cubit = ThemeCubit(storage);
    addTearDown(cubit.close);

    await _pump(tester, cubit: cubit);

    expect(cubit.currentMode, ThemeMode.system);

    await tester.tap(find.byType(DropdownButton<ThemeMode>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.themeDark).last);
    await tester.pumpAndSettle();

    expect(cubit.currentMode, ThemeMode.dark);
    expect(
      storage.read<String>(AppStorageKeys.themeMode),
      AppConstants.themeDark,
    );
  });
}

Future<void> _pump(WidgetTester tester, {required ThemeCubit cubit}) async {
  final router = GoRouter(
    initialLocation: AppRoutes.settingsView,
    routes: [
      GoRoute(
        path: AppRoutes.settingsView,
        builder: (context, state) => BlocProvider<ThemeCubit>.value(
          value: cubit,
          child: const SettingsView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.qiblaView,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('destination', key: _destinationKey)),
        ),
      ),
    ],
  );

  await tester.pumpWidget(
    MaterialApp.router(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
      builder: (context, child) {
        AppSize.init(context);
        return child!;
      },
    ),
  );
}

class _FakeStorage implements AppLocalStorage {
  final Map<String, Object?> _values = {};

  @override
  Future<void> write<T>(String key, T value) async {
    _values[key] = value;
  }

  @override
  T? read<T>(String key) => _values[key] as T?;

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  bool contains(String key) => _values.containsKey(key);

  @override
  Future<void> clear() async {
    _values.clear();
  }
}
