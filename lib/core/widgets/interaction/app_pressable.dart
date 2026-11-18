import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_constants.dart';

class AppPressable extends StatefulWidget {
  const AppPressable({
    required this.onPressed,
    required this.child,
    super.key,
    this.onLongPress,
    this.enabled = true,
    this.semanticButton = true,
    this.semanticLabel,
    this.excludeChildSemantics = false,
    this.disabledOpacity = AppConstants.opacityFull,
    this.fadeOpacity = AppConstants.opacityPressed,
    this.fadeIn = AppConstants.pressFadeIn70ms,
    this.fadeOut = AppConstants.pressFadeOut150ms,
    this.minVisible = AppConstants.pressMinVisible100ms,
    this.tapCooldown = Duration.zero,
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget child;
  final bool enabled;
  final bool semanticButton;
  final String? semanticLabel;
  final bool excludeChildSemantics;
  final double disabledOpacity;
  final double fadeOpacity;
  final Duration fadeIn;
  final Duration fadeOut;
  final Duration minVisible;
  final Duration tapCooldown;

  @override
  State<AppPressable> createState() => _AppPressableState();
}

class _AppPressableState extends State<AppPressable> {
  bool _pressed = false;
  DateTime? _pressStart;
  Timer? _pendingTimer;
  Timer? _cooldownTimer;
  final Set<int> _pointers = {};
  bool _multiTouch = false;
  bool _coolingDown = false;
  bool _blockedByCooldown = false;

  bool get _canTap => widget.enabled && widget.onPressed != null;
  bool get _canLongPress => widget.enabled && widget.onLongPress != null;
  bool get _isEnabled => _canTap || _canLongPress;

  @override
  void dispose() {
    _pendingTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (_pointers.isEmpty && _pressStart == null && _pendingTimer == null) {
      _multiTouch = false;
    }
    _pointers.add(event.pointer);
    if (_pointers.length > 1) _multiTouch = true;
  }

  void _handlePointerUp(PointerEvent event) {
    _pointers.remove(event.pointer);
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_canTap) return;

    // A new tap arrived while the previous one is still in its minimum
    // visible window — fire it now so rapid taps are never lost (counter).
    _flushPending();

    _blockedByCooldown = _coolingDown;
    _pressStart = DateTime.now();
    setState(() => _pressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_canTap || _pressStart == null) return;

    final elapsed = DateTime.now().difference(_pressStart!);
    final remaining = widget.minVisible - elapsed;

    if (remaining <= Duration.zero) {
      _complete();
      return;
    }

    _pendingTimer?.cancel();
    _pendingTimer = Timer(remaining, _complete);
  }

  void _handleTapCancel() {
    if (!_pressed) return;

    _pendingTimer?.cancel();
    _pendingTimer = null;
    _pressStart = null;
    _blockedByCooldown = false;
    setState(() => _pressed = false);
  }

  void _handleLongPress() {
    if (!_canLongPress) return;

    _pendingTimer?.cancel();
    _pendingTimer = null;
    _pressStart = null;

    if (_multiTouch) {
      _multiTouch = false;
      if (mounted) setState(() => _pressed = false);
      return;
    }

    setState(() => _pressed = false);
    (widget.onLongPress ?? widget.onPressed)?.call();
  }

  void _complete() {
    _pendingTimer?.cancel();
    _pendingTimer = null;
    _pressStart = null;

    final blocked = _multiTouch || _blockedByCooldown;
    _multiTouch = false;
    _blockedByCooldown = false;

    if (mounted) setState(() => _pressed = false);
    if (blocked) return;

    _startCooldown();
    widget.onPressed?.call();
  }

  void _startCooldown() {
    if (widget.tapCooldown == Duration.zero) return;

    _cooldownTimer?.cancel();
    _coolingDown = true;
    _cooldownTimer = Timer(widget.tapCooldown, () => _coolingDown = false);
  }

  void _flushPending() {
    if (_pendingTimer == null) return;

    _complete();
  }

  // Screen readers and keyboard activation share this path.
  void _activate() {
    if (!_canTap) return;

    _flushPending();
    _blockedByCooldown = _coolingDown;
    _pressStart = DateTime.now();
    setState(() => _pressed = true);
    _pendingTimer = Timer(widget.minVisible, _complete);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = _isEnabled;
    final opacity = enabled
        ? (_pressed ? widget.fadeOpacity : AppConstants.opacityFull)
        : widget.disabledOpacity;

    return Semantics(
      button: widget.semanticButton,
      enabled: enabled,
      label: widget.semanticLabel,
      onTap: _canTap ? _activate : null,
      onLongPress: _canLongPress ? _handleLongPress : null,
      child: FocusableActionDetector(
        enabled: enabled,
        mouseCursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) {
              _activate();
              return null;
            },
          ),
        },
        child: Listener(
          onPointerDown: _handlePointerDown,
          onPointerUp: _handlePointerUp,
          onPointerCancel: _handlePointerUp,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            excludeFromSemantics: true,
            onTapDown: _canTap ? _handleTapDown : null,
            onTapUp: _canTap ? _handleTapUp : null,
            onTapCancel: _canTap ? _handleTapCancel : null,
            onLongPress: _canLongPress ? _handleLongPress : null,
            child: AnimatedOpacity(
              opacity: opacity,
              duration: _pressed ? widget.fadeIn : widget.fadeOut,
              curve: Curves.easeOut,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: AppConstants.minTapTarget,
                  minHeight: AppConstants.minTapTarget,
                ),
                child: widget.excludeChildSemantics
                    ? ExcludeSemantics(child: widget.child)
                    : widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
