import 'package:flutter/material.dart';
import 'package:sana/core/common/widgets/smart_support_card.dart';
import 'package:sana/core/constants/app_spacing.dart';

class SmartSupportCardInHomeView extends StatelessWidget {
  const SmartSupportCardInHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.betweenSections18),
      child: SmartSupportCard(),
    );
  }
}
