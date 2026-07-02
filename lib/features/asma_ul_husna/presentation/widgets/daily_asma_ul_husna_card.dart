import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/services/sharing/presentation/utils/app_share.dart';
import 'package:sana/features/asma_ul_husna/domain/entities/asma_ul_husna_entity.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/daily_asma_ul_husna_cubit.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/daily_asma_ul_husna_state.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/asma_ul_husna_share_card.dart';

class DailyAsmaUlHusnaCard extends StatelessWidget {
  const DailyAsmaUlHusnaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<DailyAsmaUlHusnaCubit>();
        unawaited(cubit.loadDailyName());
        return cubit;
      },
      child: BlocBuilder<DailyAsmaUlHusnaCubit, DailyAsmaUlHusnaState>(
        builder: (context, state) {
          return state.maybeWhen(
            loaded: (name) => DailyAsmaUlHusnaCardContent(
              name: name,
              onSharePressed: () async {
                if (!context.mounted) return;
                try {
                  await AppShare.shareWidgetAsImage(
                    context: context,
                    widget: AsmaUlHusnaShareCard(name: name),
                    imageName: 'share_asma_${name.id}',
                  );
                } on Exception catch (e) {
                  debugPrint('Share Error: $e');
                }
              },
              onCopyPressed: () async {
                if (!context.mounted) return;
                try {
                  final text = '${name.name}\n${name.meaningBrief}\n\n${name.meaningDetailed}';
                  await Clipboard.setData(ClipboardData(text: text.trim()));
                  if (context.mounted) {
                    AppToast.show(context, 'تم النسخ بنجاح');
                  }
                } on Exception catch (e) {
                  debugPrint('Copy Error: $e');
                }
              },
            ),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

class DailyAsmaUlHusnaCardContent extends StatelessWidget {
  const DailyAsmaUlHusnaCardContent({
    required this.name,
    required this.onSharePressed,
    required this.onCopyPressed,
    super.key,
  });

  final AsmaUlHusnaEntity name;
  final VoidCallback onSharePressed;
  final VoidCallback onCopyPressed;

  @override
  Widget build(BuildContext context) {
    return DailyContentBaseCard(
      title: name.name,
      content: name.meaningDetailed,
      icon: FlutterIslamicIcons.solidAllah,
      footerText: AppStrings.pressHereToSeeMore,
      onTap: () => context.pushNamed(AppRoutes.asmaUlHusna),
      onSharePressed: onSharePressed,
      onCopyPressed: onCopyPressed,
    );
  }
}
