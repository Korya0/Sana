import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/app_feedback.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/utils/regex.dart';

class HadithSearchTextField extends StatelessWidget {
  const HadithSearchTextField({
    required this.searchController,
    required this.onSearchChanged,
    required this.onToggleSearch,
    super.key,
    this.autoFocus = true,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onToggleSearch;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      autofocus: autoFocus,
      style: AppTextStyles.font16W500White(context),
      onChanged: onSearchChanged,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => context.unfocus(),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(Regex.arabicLettersAndSpacesPattern),
        ),
      ],
      decoration: InputDecoration(
        hintText: AppStrings.searchSearchHint,
        hintStyle: AppTextStyles.font14W400Grey(context),
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(Icons.close, color: context.color.textPrimary),
          onPressed: () {
            unawaited(AppFeedback.playVibrate());
            onToggleSearch();
          },
        ),
      ),
    );
  }
}

