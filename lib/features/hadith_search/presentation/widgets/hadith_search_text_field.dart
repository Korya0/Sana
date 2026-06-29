import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/utils/utils.dart';

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
      style: AppTextStyles.font16W500(context).copyWith(color: context.color.textPrimary),
      onChanged: onSearchChanged,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => context.unfocus(),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(arabicLettersAndSpacesPattern),
        ),
      ],
      decoration: InputDecoration(
        hintText: AppStrings.searchSearchHint,
        hintStyle: AppTextStyles.font14W500(context).copyWith(color: context.color.textSecondary),
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(Icons.close, color: context.color.textPrimary),
          onPressed: () {
            unawaited(playVibrate());
            onToggleSearch();
          },
        ),
      ),
    );
  }
}

