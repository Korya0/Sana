import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/core/router/app_route_observer.dart';
import 'package:sana/core/services/volume_buttons/volume_buttons_service.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_state.dart';

class VolumeCounterBinding extends StatefulWidget {
  const VolumeCounterBinding({
    required this.canCount,
    required this.onUp,
    required this.onDown,
    required this.child,
    super.key,
    this.service,
    this.routeObserver,
  });

  final bool canCount;
  final VoidCallback onUp;
  final VoidCallback onDown;
  final Widget child;
  final VolumeButtonsService? service;
  final RouteObserver<ModalRoute<dynamic>>? routeObserver;

  @override
  State<VolumeCounterBinding> createState() => _VolumeCounterBindingState();
}

class _VolumeCounterBindingState extends State<VolumeCounterBinding>
    with WidgetsBindingObserver, RouteAware {
  late final ValueChanged<VolumeButtonDirection> _onButton = _handleButton;

  VolumeButtonsService? _service;
  RouteObserver<ModalRoute<dynamic>>? _routeObserver;
  bool _attached = false;
  bool _routeCurrent = true;
  bool _resumed = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _service ??= widget.service ?? sl<VolumeButtonsService>();

    final route = ModalRoute.of(context);
    if (route != null && _routeObserver == null) {
      _routeObserver = widget.routeObserver ?? AppRouteObserver.instance;
      _routeObserver!.subscribe(this, route);
    }

    _sync();
  }

  @override
  void didUpdateWidget(covariant VolumeCounterBinding oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.canCount != widget.canCount) _sync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _resumed = state == AppLifecycleState.resumed;
    _sync();
  }

  @override
  void didChangeMetrics() => _sync();

  @override
  void didPushNext() {
    _routeCurrent = false;
    _sync();
  }

  @override
  void didPopNext() {
    _routeCurrent = true;
    _sync();
  }

  @override
  void didPop() {
    _routeCurrent = false;
    _sync();
  }

  // Routes a native event to the screen callbacks.
  void _handleButton(VolumeButtonDirection direction) {
    if (!_attached || !mounted) return;

    switch (direction) {
      case VolumeButtonDirection.up:
        widget.onUp();
      case VolumeButtonDirection.down:
        widget.onDown();
    }
  }

  // Enables interception only while this counter screen is visibly active.
  void _sync() {
    final service = _service;
    if (service == null || !mounted) return;

    final settingsEnabled = context
        .read<AzkarTasbeehSettingsCubit>()
        .state
        .settingsOrDefault
        .volumeButtonCountEnabled;
    final shouldAttach =
        service.isSupported &&
        settingsEnabled &&
        widget.canCount &&
        _routeCurrent &&
        _resumed;

    if (shouldAttach == _attached) return;
    _attached = shouldAttach;

    if (shouldAttach) {
      service.attach(_onButton);
    } else {
      service.detach(_onButton);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _routeObserver?.unsubscribe(this);
    if (_attached) {
      _attached = false;
      _service?.detach(_onButton);
    }
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocListener<AzkarTasbeehSettingsCubit, AzkarTasbeehSettingsState>(
    listenWhen: (previous, current) =>
        previous.settingsOrDefault.volumeButtonCountEnabled !=
        current.settingsOrDefault.volumeButtonCountEnabled,
    listener: (context, state) => _sync(),
    child: widget.child,
  );
}
