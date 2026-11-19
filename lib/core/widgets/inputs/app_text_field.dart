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

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.hintText,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.autofocus = false,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.leading,
    this.trailing,
    this.isDisabled = false,
    this.readOnly = false,
    this.isLocked = false,
    this.onTap,
    this.hasError = false,
    this.highlightOnFocus = true,
    this.maxLines = AppConstants.maxOneLine,
    this.isRequired = false,
    this.isOptional = false,
    this.maxLength,
    this.minHeight,
    this.expands = false,
    this.showCharacterCount = false,
  });

  final String? label;
  final String? hint;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Widget? leading;
  final Widget? trailing;
  final bool isDisabled;
  final bool readOnly;
  final bool isLocked;
  final VoidCallback? onTap;
  final bool hasError;
  final bool highlightOnFocus;
  final int? maxLines;
  final bool isRequired;
  final bool isOptional;
  final int? maxLength;
  final double? minHeight;
  final bool expands;
  final bool showCharacterCount;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  FocusNode? _internalFocusNode;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) _internalFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
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
    final fillColor = widget.isDisabled
        ? context.color.surfaceDisabled
        : context.color.secondaryScaffoldBackgroundColor;

    final textStyle = widget.isDisabled
        ? AppTextStyles.font14W500Secondary(context)
        : AppTextStyles.font14W500Primary(context);

    final hintStyle = AppTextStyles.font14W500Secondary(context);
    final errorStyle = AppTextStyles.font12W500Error(context);
    final effectiveHint = widget.hint ?? widget.hintText;

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
          initialValue: widget.controller?.text,
          validator: (value) {
            final current = widget.controller?.text ?? value;
            return widget.validator?.call(current);
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListenableBuilder(
                listenable: _focusNode,
                builder: (context, _) {
                  final borderColor = widget.hasError || field.hasError
                      ? AppColorsCommon.errorColor
                      : _focusNode.hasFocus && widget.highlightOnFocus
                      ? context.color.borderBrand
                      : context.color.dividerColor;

                  final fieldHeight =
                      widget.minHeight ??
                      (widget.maxLines == AppConstants.maxOneLine
                          ? AppSize.h48
                          : null);

                  return Container(
                    height: fieldHeight,
                    constraints: widget.minHeight != null
                        ? BoxConstraints(minHeight: widget.minHeight!)
                        : null,
                    decoration: BoxDecoration(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(AppSize.r12),
                      border: Border.all(
                        color: borderColor,
                        width: AppSize.borderWidth,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: widget.expands
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: [
                        if (widget.leading != null) ...[
                          widget.leading!,
                          AppGap.w(AppSize.p8),
                        ],
                        Expanded(
                          child: Actions(
                            actions: {
                              ExtendSelectionVerticallyToAdjacentPageIntent:
                                  CallbackAction<
                                    ExtendSelectionVerticallyToAdjacentPageIntent
                                  >(
                                    onInvoke: (intent) {
                                      final controller = widget.controller;
                                      if (controller != null) {
                                        final text = controller.text;
                                        final newOffset = intent.forward
                                            ? text.length
                                            : 0;
                                        controller.selection =
                                            TextSelection.collapsed(
                                              offset: newOffset,
                                            );
                                      }
                                      return null;
                                    },
                                  ),
                            },
                            child: Focus(
                              canRequestFocus: !widget.isLocked,
                              onKeyEvent: (node, event) {
                                if (event is KeyDownEvent &&
                                    (event.logicalKey ==
                                            LogicalKeyboardKey.pageDown ||
                                        event.logicalKey ==
                                            LogicalKeyboardKey.pageUp)) {
                                  final controller = widget.controller;
                                  if (controller != null) {
                                    final text = controller.text;
                                    final newOffset =
                                        event.logicalKey ==
                                            LogicalKeyboardKey.pageDown
                                        ? text.length
                                        : 0;
                                    controller.selection =
                                        TextSelection.collapsed(
                                          offset: newOffset,
                                        );
                                  }
                                  return KeyEventResult.handled;
                                }
                                return KeyEventResult.ignored;
                              },
                              child: TextField(
                                controller: widget.controller,
                                focusNode: _focusNode,
                                obscureText: widget.obscureText,
                                autofocus: widget.autofocus,
                                maxLines: widget.maxLines,
                                expands: widget.expands,
                                maxLength: widget.maxLength,
                                maxLengthEnforcement: widget.maxLength != null
                                    ? MaxLengthEnforcement.enforced
                                    : MaxLengthEnforcement.none,
                                buildCounter:
                                    (
                                      context, {
                                      required currentLength,
                                      required isFocused,
                                      required maxLength,
                                    }) => null,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                onChanged: (value) {
                                  field.didChange(value);
                                  widget.onChanged?.call(value);
                                },
                                inputFormatters: widget.inputFormatters,
                                keyboardType: widget.keyboardType,
                                enabled: !widget.isDisabled,
                                readOnly: widget.readOnly || widget.isLocked,
                                canRequestFocus: !widget.isLocked,
                                onTap: widget.onTap,
                                style: textStyle,
                                decoration: InputDecoration(
                                  hintText: effectiveHint,
                                  hintStyle: hintStyle,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: widget.leading == null
                                        ? (widget.expands
                                              ? AppSize.p12
                                              : AppSize.p16)
                                        : 0,
                                    vertical: AppSize.p12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (widget.trailing != null) ...[
                          AppGap.w(AppSize.p8),
                          widget.trailing!,
                          AppGap.w(AppSize.p12),
                        ],
                      ],
                    ),
                  );
                },
              ),
              if (widget.showCharacterCount &&
                  widget.maxLength != null &&
                  widget.controller != null) ...[
                AppGap.h(AppSize.p8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (field.hasError)
                      _FieldErrorText(
                        errorText: field.errorText!,
                        style: errorStyle,
                      )
                    else
                      const SizedBox.shrink(),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: widget.controller!,
                      builder: (context, value, _) => Text(
                        AppStrings.charCounter(
                          value.text.characters.length,
                          widget.maxLength!,
                        ),
                        style: AppTextStyles.font12W500Secondary(context),
                      ),
                    ),
                  ],
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
