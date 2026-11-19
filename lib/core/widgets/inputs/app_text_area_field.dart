import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/colors/app_colors_common.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/inputs/field_label.dart';

class AppTextAreaField extends StatefulWidget {
  const AppTextAreaField({
    required this.controller,
    super.key,
    this.label,
    this.hint,
    this.hintText,
    this.focusNode,
    this.validator,
    this.maxLength = AppConstants.zikrTextMaxLength,
    this.onChanged,
    this.enabled = true,
    this.keyboardType = TextInputType.multiline,
    this.inputFormatters,
    this.minHeight,
    this.isRequired = false,
    this.isOptional = false,
  });

  final String? label;
  final String? hint;
  final String? hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final int maxLength;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double? minHeight;
  final bool isRequired;
  final bool isOptional;

  @override
  State<AppTextAreaField> createState() => _AppTextAreaFieldState();
}

class _AppTextAreaFieldState extends State<AppTextAreaField> {
  FocusNode? _internalFocusNode;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) _internalFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant AppTextAreaField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      if (oldWidget.focusNode == null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }
      if (widget.focusNode == null) _internalFocusNode ??= FocusNode();
    }
  }

  @override
  void dispose() {
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fillColor = widget.enabled
        ? context.color.secondaryScaffoldBackgroundColor
        : context.color.surfaceDisabled;

    final textStyle = widget.enabled
        ? AppTextStyles.font14W500Primary(context)
        : AppTextStyles.font14W500Secondary(context);

    final hintStyle = AppTextStyles.font14W500Secondary(context);
    final errorStyle = AppTextStyles.font12W500Error(context);
    final effectiveHint = widget.hint ?? widget.hintText;
    final contentInset = EdgeInsets.all(AppSize.p12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          FieldLabel(
            label: widget.label!,
            isRequired: widget.isRequired,
            isOptional: widget.isOptional,
          ),
          AppGap.h(AppSize.p12),
        ],
        FormField<String>(
          initialValue: widget.controller.text,
          validator: (value) {
            final current = widget.controller.text;
            return widget.validator?.call(current);
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListenableBuilder(
                listenable: _focusNode,
                builder: (context, _) {
                  final borderColor = field.hasError
                      ? AppColorsCommon.errorColor
                      : _focusNode.hasFocus
                      ? context.color.borderBrand
                      : context.color.dividerColor;

                  return Container(
                    constraints: BoxConstraints.tightFor(
                      height: widget.minHeight ?? AppSize.h150,
                    ),
                    decoration: BoxDecoration(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(AppSize.r12),
                      border: Border.all(
                        color: borderColor,
                        width: AppSize.borderWidth,
                      ),
                    ),
                    child: Actions(
                      actions: {
                        ExtendSelectionVerticallyToAdjacentPageIntent:
                            CallbackAction<
                              ExtendSelectionVerticallyToAdjacentPageIntent
                            >(
                              onInvoke: (intent) {
                                final text = widget.controller.text;
                                final newOffset = intent.forward
                                    ? text.length
                                    : 0;
                                widget.controller.selection =
                                    TextSelection.collapsed(offset: newOffset);
                                return null;
                              },
                            ),
                      },
                      child: Focus(
                        onKeyEvent: (node, event) {
                          if (event is KeyDownEvent &&
                              (event.logicalKey ==
                                      LogicalKeyboardKey.pageDown ||
                                  event.logicalKey ==
                                      LogicalKeyboardKey.pageUp)) {
                            final text = widget.controller.text;
                            final newOffset =
                                event.logicalKey == LogicalKeyboardKey.pageDown
                                ? text.length
                                : 0;
                            widget.controller.selection =
                                TextSelection.collapsed(offset: newOffset);
                            return KeyEventResult.handled;
                          }
                          return KeyEventResult.ignored;
                        },
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ValueListenableBuilder<TextEditingValue>(
                                valueListenable: widget.controller,
                                builder: (context, value, _) {
                                  if (effectiveHint == null ||
                                      value.text.isNotEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: contentInset,
                                    child: IgnorePointer(
                                      child: Text(
                                        effectiveHint,
                                        style: hintStyle,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            TextField(
                              controller: widget.controller,
                              focusNode: _focusNode,
                              maxLines: null,
                              minLines: null,
                              expands: true,
                              maxLength: widget.maxLength,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              enabled: widget.enabled,
                              keyboardType: widget.keyboardType,
                              inputFormatters: widget.inputFormatters,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              onChanged: (value) {
                                field.didChange(value);
                                widget.onChanged?.call(value);
                              },
                              style: textStyle,
                              buildCounter:
                                  (
                                    context, {
                                    required currentLength,
                                    required isFocused,
                                    required maxLength,
                                  }) => null,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: contentInset,
                              ),
                              scrollPadding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              AppGap.h(AppSize.p8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: widget.controller,
                    builder: (context, value, _) => Text(
                      AppStrings.charCounter(
                        value.text.characters.length,
                        widget.maxLength,
                      ),
                      style: AppTextStyles.font12W500Secondary(context),
                    ),
                  ),
                ],
              ),
              if (field.hasError) ...[
                AppGap.h(AppSize.p4),
                _FieldErrorText(
                  errorText: field.errorText!,
                  style: errorStyle,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _FieldErrorText extends StatelessWidget {
  const _FieldErrorText({required this.errorText, required this.style});

  final String errorText;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) return Text(errorText, style: style);
    return Text(errorText, style: style)
        .animate(key: ValueKey(errorText))
        .fadeIn(
          duration: AppConstants.animationFast200ms,
          curve: Curves.easeOut,
        )
        .slideY(
          begin: 0.2,
          end: 0,
          duration: AppConstants.animationFast200ms,
          curve: Curves.easeOut,
        );
  }
}
