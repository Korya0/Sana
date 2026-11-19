import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/utils/app_haptics.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar_tasbeeh_settings/azkar_tasbeeh_settings_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_form_item_tile.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_reorder_card.dart';
import 'package:sana/features/azkar/presentation/widgets/custom_azkar_form/zikr_reorder_drag_listener.dart';

class ZikrReorderList extends StatefulWidget {
  const ZikrReorderList({
    required this.items,
    required this.isBuiltIn,
    required this.onEdit,
    required this.onDelete,
    required this.onReorder,
    required this.topInset,
    super.key,
  });

  final List<ZikrEntity> items;
  final bool isBuiltIn;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onDelete;
  final ReorderCallback onReorder;

  // Height of the pinned app bar above the list viewport
  final double topInset;

  @override
  State<ZikrReorderList> createState() => _ZikrReorderListState();
}

class _ZikrReorderListState extends State<ZikrReorderList>
    with TickerProviderStateMixin {
  final Map<int, GlobalKey> _itemKeys = {};
  bool _isReordering = false;
  bool _compactAll = false;
  int? _pressedIndex;
  Timer? _exitTimer;

  ScrollableState? _scrollable;
  Ticker? _autoScrollTicker;
  Duration _lastTick = Duration.zero;
  bool _gapRefreshScheduled = false;

  int? _pointerId;
  PointerDeviceKind? _pointerKind;
  int? _pointerDevice;
  Offset? _pointerPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollable = Scrollable.of(context);
  }

  @override
  void dispose() {
    _exitTimer?.cancel();
    _stopAutoScroll();
    super.dispose();
  }

  Future<bool> _enterReorderMode(int index) async {
    if (!mounted ||
        _isReordering ||
        index < 0 ||
        index >= widget.items.length) {
      return false;
    }

    _exitTimer?.cancel();
    _exitTimer = null;
    final itemId = widget.items[index].id;
    _pressedIndex = index;
    _compactAll = false;
    setState(() => _isReordering = true);
    _playHaptic();

    await _waitForFrame();
    if (!mounted) return false;

    final itemContext = _itemKeys[itemId]?.currentContext;
    if (itemContext == null) {
      _exitReorderMode();
      return false;
    }
    return true;
  }

  void _handleReorderStart() {
    _exitTimer?.cancel();
    if (!_isReordering) return;
    _startAutoScroll();
    if (!_compactAll) setState(() => _compactAll = true);
  }

  void _handleRelease(bool dragStarted) {
    _stopAutoScroll();
    if (!mounted || !_isReordering) return;
    _exitTimer?.cancel();
    if (!dragStarted) {
      _exitReorderMode();
      return;
    }
    // Keeps compact layout until the drop animation settles.
    _exitTimer = Timer(AppConstants.animationNormal300ms, _exitReorderMode);
  }

  void _exitReorderMode() {
    _exitTimer?.cancel();
    _exitTimer = null;
    _stopAutoScroll();
    if (!mounted) return;
    if (!_isReordering && !_compactAll && _pressedIndex == null) return;
    setState(() {
      _isReordering = false;
      _compactAll = false;
      _pressedIndex = null;
    });
  }

  Future<void> _waitForFrame() {
    final completer = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) => completer.complete());
    WidgetsBinding.instance.ensureVisualUpdate();
    return completer.future;
  }

  void _playHaptic() {
    final enabled = context
        .read<AzkarTasbeehSettingsCubit>()
        .state
        .settingsOrDefault
        .hapticFeedbackEnabled;
    if (!enabled) return;
    unawaited(AppHaptics.light());
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (_isReordering) return;
    _pointerId = event.pointer;
    _pointerKind = event.kind;
    _pointerDevice = event.device;
    _pointerPosition = event.position;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (event.pointer != _pointerId) return;
    _pointerPosition = event.position;
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (event.pointer != _pointerId) return;
    _clearPointer();
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (event.pointer != _pointerId) return;
    _clearPointer();
  }

  void _clearPointer() {
    _stopAutoScroll();
    _pointerId = null;
    _pointerKind = null;
    _pointerDevice = null;
    _pointerPosition = null;
  }

  void _startAutoScroll() {
    _autoScrollTicker?.dispose();
    _lastTick = Duration.zero;
    _autoScrollTicker = createTicker(_onAutoScrollTick)..start();
  }

  void _stopAutoScroll() {
    _autoScrollTicker?.dispose();
    _autoScrollTicker = null;
    _lastTick = Duration.zero;
  }

  void _onAutoScrollTick(Duration elapsed) {
    final scrollable = _scrollable;
    final pointer = _pointerPosition;
    if (scrollable == null || pointer == null) return;

    final renderObject = scrollable.context.findRenderObject();
    if (renderObject is! RenderBox) return;

    final viewport =
        renderObject.localToGlobal(Offset.zero) & renderObject.size;
    final visibleTop = viewport.top + widget.topInset;
    final visibleBottom = viewport.bottom;
    final fingerY = pointer.dy;

    final dt = _lastTick == Duration.zero
        ? AppConstants.reorderTickFallback16ms
        : elapsed - _lastTick;
    _lastTick = elapsed;
    final tick = dt > AppConstants.reorderTickMax50ms
        ? AppConstants.reorderTickMax50ms
        : dt;
    final step =
        AppConstants.reorderSpeedPxPerSecond *
        tick.inMicroseconds /
        Duration.microsecondsPerSecond;

    final position = scrollable.position;
    final threshold = AppSize.reorderScrollThreshold;
    final double? target;
    if (fingerY < visibleTop + threshold) {
      final intensity = ((visibleTop + threshold - fingerY) / threshold).clamp(
        0.0,
        1.0,
      );
      target = position.pixels - (step * intensity);
    } else if (fingerY > visibleBottom - threshold) {
      final intensity = ((fingerY - (visibleBottom - threshold)) / threshold)
          .clamp(0.0, 1.0);
      target = position.pixels + (step * intensity);
    } else {
      return;
    }

    final clamped = target
        .clamp(position.minScrollExtent, position.maxScrollExtent)
        .toDouble();
    if ((clamped - position.pixels).abs() < AppConstants.reorderScrollEpsilon) {
      return;
    }

    position.jumpTo(clamped);
    _scheduleGapRefresh();
  }

  // Re-runs the framework's gap calculation after our own scroll, because its
  // edge auto-scroller cannot move while the drag boundary clamps the proxy.
  void _scheduleGapRefresh() {
    if (_gapRefreshScheduled) return;
    _gapRefreshScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gapRefreshScheduled = false;
      _sendSyntheticDragUpdate();
    });
  }

  void _sendSyntheticDragUpdate() {
    if (!mounted) return;
    final pointerId = _pointerId;
    final pointer = _pointerPosition;
    if (pointerId == null || pointer == null || !_isReordering) return;

    GestureBinding.instance.handlePointerEvent(
      PointerMoveEvent(
        pointer: pointerId,
        position: pointer,
        delta: Offset.zero,
        timeStamp: SchedulerBinding.instance.currentSystemFrameTimeStamp,
        kind: _pointerKind ?? PointerDeviceKind.touch,
        device: _pointerDevice ?? 0,
        synthesized: true,
      ),
    );
  }

  DragBoundaryDelegate<Rect> _dragBoundary(BuildContext context) {
    final scrollable = Scrollable.of(context);
    final renderObject = scrollable.context.findRenderObject();
    if (renderObject is! RenderBox) return _FreeDragBoundary();

    final viewport =
        renderObject.localToGlobal(Offset.zero) & renderObject.size;
    final top = viewport.top + widget.topInset;
    if (top >= viewport.bottom) return _FreeDragBoundary();

    return _ZikrDragBoundary(
      Rect.fromLTRB(viewport.left, top, viewport.right, viewport.bottom),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canReorder = widget.items.length > 1;

    return SliverPadding(
      padding: AppSize.shp,
      sliver: SliverReorderableList(
        itemCount: widget.items.length,
        onReorderItem: widget.onReorder,
        onReorderStart: (_) => _handleReorderStart(),
        onReorderEnd: (_) => _handleRelease(true),
        dragBoundaryProvider: _dragBoundary,
        findChildIndexCallback: (key) {
          final childKey = key is GlobalObjectKey ? key.value : key;
          if (childKey is! ValueKey<int>) return null;
          final index = widget.items.indexWhere(
            (zikr) => zikr.id == childKey.value,
          );
          return index < 0 ? null : index;
        },
        itemBuilder: (context, index) {
          final zikr = widget.items[index];
          final showCompact =
              _isReordering && (_compactAll || index == _pressedIndex);
          final itemKey = _itemKeys.putIfAbsent(zikr.id, () => GlobalKey());

          return KeyedSubtree(
            key: ValueKey(zikr.id),
            child: KeyedSubtree(
              key: itemKey,
              child: ZikrReorderDragStartListener(
                index: index,
                enabled: canReorder,
                onArm: _enterReorderMode,
                onRelease: _handleRelease,
                onPointerDown: _handlePointerDown,
                onPointerMove: _handlePointerMove,
                onPointerUp: _handlePointerUp,
                onPointerCancel: _handlePointerCancel,
                child: showCompact
                    ? ZikrReorderCard(zikr: zikr)
                    : ZikrFormItemTile(
                        zikr: zikr,
                        onEdit: () => widget.onEdit(index),
                        onDelete: (!widget.isBuiltIn || zikr.canBeDeleted)
                            ? () => widget.onDelete(index)
                            : null,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FreeDragBoundary extends DragBoundaryDelegate<Rect> {
  _FreeDragBoundary();

  @override
  bool isWithinBoundary(Rect draggedObject) => true;

  @override
  Rect nearestPositionWithinBoundary(Rect draggedObject) => draggedObject;
}

class _ZikrDragBoundary extends DragBoundaryDelegate<Rect> {
  _ZikrDragBoundary(this.boundary);

  final Rect boundary;

  @override
  bool isWithinBoundary(Rect draggedObject) =>
      boundary.contains(draggedObject.topLeft) &&
      boundary.contains(draggedObject.bottomRight);

  @override
  Rect nearestPositionWithinBoundary(Rect draggedObject) {
    if (boundary.width < draggedObject.width ||
        boundary.height < draggedObject.height) {
      return draggedObject;
    }
    return Rect.fromLTWH(
      draggedObject.left
          .clamp(boundary.left, boundary.right - draggedObject.width)
          .toDouble(),
      draggedObject.top
          .clamp(boundary.top, boundary.bottom - draggedObject.height)
          .toDouble(),
      draggedObject.width,
      draggedObject.height,
    );
  }
}
