import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

typedef ZikrReorderReleaseCallback = void Function(bool dragStarted);
typedef ZikrReorderArmCallback = Future<bool> Function(int index);

class ZikrReorderDragStartListener extends ReorderableDragStartListener {
  const ZikrReorderDragStartListener({
    required super.child,
    required super.index,
    required this.onArm,
    required this.onRelease,
    this.onPointerDown,
    this.onPointerMove,
    this.onPointerUp,
    this.onPointerCancel,
    super.enabled,
    super.key,
  });

  final ZikrReorderArmCallback onArm;
  final ZikrReorderReleaseCallback onRelease;
  final PointerDownEventListener? onPointerDown;
  final PointerMoveEventListener? onPointerMove;
  final PointerUpEventListener? onPointerUp;
  final PointerCancelEventListener? onPointerCancel;

  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: onPointerDown,
    onPointerMove: onPointerMove,
    onPointerUp: onPointerUp,
    onPointerCancel: onPointerCancel,
    child: super.build(context),
  );

  @override
  MultiDragGestureRecognizer createRecognizer() => _ZikrReorderRecognizer(
    onArm: () => onArm(index),
    onRelease: onRelease,
    debugOwner: this,
  );
}

class _ZikrReorderRecognizer extends MultiDragGestureRecognizer {
  _ZikrReorderRecognizer({
    required this.onArm,
    required this.onRelease,
    required super.debugOwner,
  });

  final Future<bool> Function() onArm;
  final ZikrReorderReleaseCallback onRelease;

  @override
  String get debugDescription => 'zikr reorder';

  @override
  MultiDragPointerState createNewPointerState(PointerDownEvent event) =>
      _ZikrReorderPointerState(
        event.position,
        event.kind,
        gestureSettings,
        onArm: onArm,
        onRelease: onRelease,
      );
}

class _ZikrReorderPointerState extends MultiDragPointerState {
  _ZikrReorderPointerState(
    super.initialPosition,
    super.kind,
    super.gestureSettings, {
    required this.onArm,
    required this.onRelease,
  }) {
    _holdTimer = Timer(kLongPressTimeout, _onHoldElapsed);
  }

  final Future<bool> Function() onArm;
  final ZikrReorderReleaseCallback onRelease;

  Timer? _holdTimer;
  bool _armed = false;
  bool _accepted = false;
  bool _released = false;
  bool _disposed = false;

  // Arms the compact layout, then starts the drag once it is laid out.
  void _onHoldElapsed() {
    _holdTimer = null;
    if (_disposed) return;
    if (pendingDelta!.distance > computeHitSlop(kind, gestureSettings)) {
      resolve(GestureDisposition.rejected);
      return;
    }
    _armed = true;
    unawaited(_armAndStart());
  }

  Future<void> _armAndStart() async {
    final canStart = await onArm();
    if (_disposed || _accepted) return;
    if (!canStart) {
      resolve(GestureDisposition.rejected);
      return;
    }
    _accepted = true;
    resolve(GestureDisposition.accepted);
  }

  @override
  void checkForResolutionAfterMove() {
    if (_armed || _disposed) return;
    if (pendingDelta!.distance > computeHitSlop(kind, gestureSettings)) {
      _holdTimer?.cancel();
      _holdTimer = null;
      resolve(GestureDisposition.rejected);
    }
  }

  @override
  void accepted(GestureMultiDragStartCallback starter) {
    _accepted = true;
    starter(initialPosition);
  }

  @override
  void rejected() {
    _release();
    super.rejected();
  }

  @override
  void dispose() {
    _disposed = true;
    _holdTimer?.cancel();
    _release();
    super.dispose();
  }

  void _release() {
    if (_released || !_armed) return;
    _released = true;
    onRelease(_accepted);
  }
}
