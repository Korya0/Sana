import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sana/core/common/widgets/custom_bottom_sheet.dart';
import 'package:sana/core/services/location/cubit/location_permission/location_cubit.dart';
import 'package:sana/core/services/location/cubit/location_permission/location_state.dart';

class LocationGuard extends StatefulWidget {
  final Widget child;
  final bool enforceOnInit;
  final Widget? loadingPlaceholder;

  final bool showCancelButton;

  const LocationGuard({
    super.key,
    required this.child,
    this.enforceOnInit = true,
    this.loadingPlaceholder,
    this.showCancelButton = true,
  });

  @override
  State<LocationGuard> createState() => _LocationGuardState();
}

class _LocationGuardState extends State<LocationGuard>
    with WidgetsBindingObserver {
  bool _isBottomSheetShown = false;
  bool _isAwaitingResolution = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (widget.enforceOnInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<LocationCubit>().enforceLocation();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<LocationCubit>().enforceLocation();
    }
  }

  void _closeScreen() {
    if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Future<void> _showGuardBottomSheet({
    required String title,
    required String message,
    required String primaryButtonText,
    required VoidCallback onPrimaryAction,
    String? secondaryButtonText,
    VoidCallback? onSecondaryAction,
  }) async {
    if (_isBottomSheetShown) return;

    _isBottomSheetShown = true;
    _isAwaitingResolution = false;

    await showModalBottomSheet(
      context: context,
      isDismissible: widget.showCancelButton,
      enableDrag: widget.showCancelButton,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomBottomSheet(
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        onPrimaryAction: () {
          _isAwaitingResolution = true;
          onPrimaryAction();
        },
        secondaryButtonText: widget.showCancelButton
            ? (secondaryButtonText ?? 'إلغاء')
            : null,
        onSecondaryAction: widget.showCancelButton
            ? (onSecondaryAction ?? _closeScreen)
            : null,
      ),
    );
    _isBottomSheetShown = false;

    // If the sheet is closed and we are NOT in success state AND NOT awaiting resolution, close the screen
    if (mounted) {
      final state = context.read<LocationCubit>().state;
      if (state is! LocationSuccess && !_isAwaitingResolution) {
        _closeScreen();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LocationCubit, LocationState>(
        listener: (context, state) async {
          if (state is LocationSuccess) {
            if (_isBottomSheetShown) {
              Navigator.pop(context); // Close the bottom sheet
            }
          } else if (state is LocationNeedsServiceEnable) {
            _showGuardBottomSheet(
              title: 'تفعيل خدمة الموقع',
              message: 'نحتاج إلى تفعيل خدمة الموقع للمتابعة في التطبيق.',
              primaryButtonText: 'تفعيل',
              onPrimaryAction: () {
                context.read<LocationCubit>().enableLocationService();
              },
            );
          } else if (state is LocationNeedsPermission) {
            _showGuardBottomSheet(
              title: 'إذن الموقع',
              message: 'نحتاج إلى إذن الوصول إلى موقعك للحصول على أفضل تجربة.',
              primaryButtonText: 'السماح',
              onPrimaryAction: () {
                context.read<LocationCubit>().requestLocationPermission();
              },
            );
          } else if (state is LocationPermissionPermanentlyDenied) {
            _showGuardBottomSheet(
              title: 'إذن الموقع مرفوض نهائيًا',
              message:
                  'لقد رفضت إذن الموقع عدة مرات، ولن يظهر الطلب مرة أخرى.\nيجب فتح إعدادات التطبيق للسماح بالإذن.',
              primaryButtonText: 'فتح إعدادات التطبيق',
              onPrimaryAction: () async {
                await Geolocator.openAppSettings();
              },
            );
          } else if (state is LocationError) {
            _showGuardBottomSheet(
              title: 'حدث خطأ',
              message: state.message,
              primaryButtonText: 'حاول مرة أخرى',
              onPrimaryAction: () {
                context.read<LocationCubit>().retryFirstTime();
              },
            );
          }
        },
        child: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            if (state is LocationSuccess) {
              return FutureBuilder(
                future: Future.delayed(const Duration(milliseconds: 100)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return widget.child;
                  } else {
                    return widget.loadingPlaceholder ?? const Scaffold();
                  }
                },
              );
            } else {
              return widget.loadingPlaceholder ?? const Scaffold();
            }
          },
        ),
      ),
    );
  }
}
