import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/services/volume_buttons/volume_buttons_service.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/common/volume_counter_binding.dart';

import 'azkar_widget_test_harness.dart';

void main() {
  testWidgets('attaches when every condition is true and forwards events', (
    tester,
  ) async {
    final service = _FakeVolumeButtonsService();
    final settings = await createLoadedSettingsCubit(
      volumeButtonCountEnabled: true,
    );
    var up = 0;
    var down = 0;

    await pumpAzkarWidget(
      tester,
      BlocProvider<AzkarTasbeehSettingsCubit>.value(
        value: settings,
        child: VolumeCounterBinding(
          service: service,
          canCount: true,
          onUp: () => up++,
          onDown: () => down++,
          child: const SizedBox.shrink(),
        ),
      ),
    );

    expect(service.attachCalls, 1);
    expect(service.handler, isNotNull);

    service.emit(VolumeButtonDirection.up);
    service.emit(VolumeButtonDirection.down);

    expect(up, 1);
    expect(down, 1);
  });

  testWidgets('does not attach when the setting is off or unsupported', (
    tester,
  ) async {
    final offService = _FakeVolumeButtonsService();
    final offSettings = await createLoadedSettingsCubit(
      volumeButtonCountEnabled: false,
    );

    await pumpAzkarWidget(
      tester,
      BlocProvider<AzkarTasbeehSettingsCubit>.value(
        value: offSettings,
        child: VolumeCounterBinding(
          service: offService,
          canCount: true,
          onUp: () {},
          onDown: () {},
          child: const SizedBox.shrink(),
        ),
      ),
    );

    expect(offService.attachCalls, 0);

    final unsupportedService = _FakeVolumeButtonsService(isSupported: false);
    final onSettings = await createLoadedSettingsCubit(
      volumeButtonCountEnabled: true,
    );

    await pumpAzkarWidget(
      tester,
      BlocProvider<AzkarTasbeehSettingsCubit>.value(
        value: onSettings,
        child: VolumeCounterBinding(
          service: unsupportedService,
          canCount: true,
          onUp: () {},
          onDown: () {},
          child: const SizedBox.shrink(),
        ),
      ),
    );

    expect(unsupportedService.attachCalls, 0);
  });

  testWidgets('detaches when the setting is turned off', (tester) async {
    final service = _FakeVolumeButtonsService();
    final settings = await createLoadedSettingsCubit(
      volumeButtonCountEnabled: true,
    );
    var up = 0;

    await pumpAzkarWidget(
      tester,
      BlocProvider<AzkarTasbeehSettingsCubit>.value(
        value: settings,
        child: VolumeCounterBinding(
          service: service,
          canCount: true,
          onUp: () => up++,
          onDown: () {},
          child: const SizedBox.shrink(),
        ),
      ),
    );
    expect(service.attachCalls, 1);

    await settings.setVolumeButtonCountEnabled(false);
    await tester.pumpAndSettle();

    expect(service.detachCalls, 1);
    service.emit(VolumeButtonDirection.up);
    expect(up, 0);
  });

  testWidgets('detaches when the counter is no longer ready', (tester) async {
    final service = _FakeVolumeButtonsService();
    final settings = await createLoadedSettingsCubit(
      volumeButtonCountEnabled: true,
    );
    var canCount = true;
    late StateSetter setHostState;

    await pumpAzkarWidget(
      tester,
      BlocProvider<AzkarTasbeehSettingsCubit>.value(
        value: settings,
        child: StatefulBuilder(
          builder: (context, setState) {
            setHostState = setState;
            return VolumeCounterBinding(
              service: service,
              canCount: canCount,
              onUp: () {},
              onDown: () {},
              child: const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
    expect(service.attachCalls, 1);

    canCount = false;
    setHostState(() {});
    await tester.pumpAndSettle();

    expect(service.detachCalls, 1);
  });

  testWidgets('detaches while another route covers the screen', (tester) async {
    final service = _FakeVolumeButtonsService();
    final settings = await createLoadedSettingsCubit(
      volumeButtonCountEnabled: true,
    );
    final observer = RouteObserver<ModalRoute<dynamic>>();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        navigatorObservers: [observer],
        builder: (context, child) {
          AppSize.init(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: BlocProvider<AzkarTasbeehSettingsCubit>.value(
          value: settings,
          child: VolumeCounterBinding(
            service: service,
            routeObserver: observer,
            canCount: true,
            onUp: () {},
            onDown: () {},
            child: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const Scaffold(body: Text('next')),
                    ),
                  ),
                  child: const Text('push'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(service.attachCalls, 1);

    await tester.tap(find.text('push'));
    await tester.pumpAndSettle();

    expect(service.detachCalls, 1);

    Navigator.of(tester.element(find.text('next'))).pop();
    await tester.pumpAndSettle();

    expect(service.attachCalls, 2);
  });

  testWidgets('detaches when the app leaves the foreground', (tester) async {
    final service = _FakeVolumeButtonsService();
    final settings = await createLoadedSettingsCubit(
      volumeButtonCountEnabled: true,
    );

    await pumpAzkarWidget(
      tester,
      BlocProvider<AzkarTasbeehSettingsCubit>.value(
        value: settings,
        child: VolumeCounterBinding(
          service: service,
          canCount: true,
          onUp: () {},
          onDown: () {},
          child: const SizedBox.shrink(),
        ),
      ),
    );
    expect(service.attachCalls, 1);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    expect(service.detachCalls, 1);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(service.attachCalls, 2);
  });

  testWidgets('detaches on dispose', (tester) async {
    final service = _FakeVolumeButtonsService();
    final settings = await createLoadedSettingsCubit(
      volumeButtonCountEnabled: true,
    );

    await pumpAzkarWidget(
      tester,
      BlocProvider<AzkarTasbeehSettingsCubit>.value(
        value: settings,
        child: VolumeCounterBinding(
          service: service,
          canCount: true,
          onUp: () {},
          onDown: () {},
          child: const SizedBox.shrink(),
        ),
      ),
    );
    expect(service.attachCalls, 1);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();

    expect(service.detachCalls, 1);
  });
}

class _FakeVolumeButtonsService implements VolumeButtonsService {
  _FakeVolumeButtonsService({this.isSupported = true});

  @override
  final bool isSupported;

  ValueChanged<VolumeButtonDirection>? handler;
  int attachCalls = 0;
  int detachCalls = 0;

  @override
  void attach(ValueChanged<VolumeButtonDirection> onButton) {
    handler = onButton;
    attachCalls++;
  }

  @override
  void detach(ValueChanged<VolumeButtonDirection> onButton) {
    if (identical(handler, onButton)) handler = null;
    detachCalls++;
  }

  void emit(VolumeButtonDirection direction) => handler?.call(direction);
}
