import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/utils/context_extension.dart';

/// Full rounded border shared by the Zakat money fields and the currency
/// selector, so every input in the flow keeps the same soft-card vocabulary.
OutlineInputBorder zakatFieldBorder(BuildContext context, {Color? color}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSize.r16),
    borderSide: BorderSide(
      color: color ?? context.color.dividerColor,
      width: AppSize.borderWidth,
    ),
  );
}
