import 'package:flutter/material.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/widgets/dividers/app_divider.dart';
import 'package:sana/core/widgets/overlays/app_sheet_body.dart';
import 'package:sana/core/widgets/overlays/app_sheet_header.dart';

class AzkarOptionsSheetScaffold extends StatelessWidget {
  const AzkarOptionsSheetScaffold({
    required this.title,
    required this.onDismiss,
    required this.children,
    super.key,
    this.isNested = false,
  });

  final String title;
  final VoidCallback onDismiss;
  final List<Widget> children;
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    // Leave room for the header/divider/padding inside the viewport so the
    // sheet body always gets a bounded height and can scroll instead of clip.
    final maxBodyHeight = AppSize.maxSheetBodyHeight(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(
            start: AppSize.p16,
            end: AppSize.p16,
            top: AppSize.p8,
          ),
          child: AppSheetHeader(
            title: title,
            onDismiss: onDismiss,
            isNested: isNested,
          ),
        ),
        const AppDivider(),
        Flexible(
          fit: FlexFit.loose,
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: AppSize.p16,
              end: AppSize.p16,
              top: AppSize.p16,
              bottom: AppSize.p16,
            ),
            child: AppSheetBody(maxHeight: maxBodyHeight, children: children),
          ),
        ),
      ],
    );
  }
}
