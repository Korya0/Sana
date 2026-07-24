import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:sana/core/common/common.dart';
import 'package:sana/core/constants/constants.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/routing/app_navigator.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/features/sharing/presentation/helpers/app_share.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/features/asma_ul_husna/domain/entities/asma_ul_husna_entity.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubits/daily_asma_ul_husna_cubit.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubits/daily_asma_ul_husna_state.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/asma_ul_husna_share_card.dart';

class DailyAsmaUlHusnaCard extends StatefulWidget {
  const DailyAsmaUlHusnaCard({super.key});

  @override
  State<DailyAsmaUlHusnaCard> createState() => _DailyAsmaUlHusnaCardState();
}

class _DailyAsmaUlHusnaCardState extends State<DailyAsmaUlHusnaCard> {
  late AsyncCallback _onSharePressed;
  late VoidCallback _onCopyPressed;
  AsmaUlHusnaEntity? _lastName;

  void _initCallbacks(AsmaUlHusnaEntity name) {
    if (_lastName == name) return;
    _lastName = name;

    _onSharePressed = () async {
      if (!mounted) return;
      try {
        await AppShare.shareWidgetAsImage(
          context: context,
          widget: AsmaUlHusnaShareCard(name: name),
          imageName: 'share_asma_${name.id}',
        );
      } on Object catch (e, stack) {
        unawaited(AppLogger.localError(
          'AsmaUlHusna: Share Error',
          error: e,
          stackTrace: stack,
        ));
      }
    };

    _onCopyPressed = () async {
      if (!mounted) return;
      try {
        final text = '${name.name}\n${name.meaningBrief}\n\n${name.meaningDetailed}';
        await Clipboard.setData(ClipboardData(text: text.trim()));
      } on Object catch (e, stack) {
        if (mounted) {
          AppToast.show(
            context,
            AppStrings.copyError,
            type: AppToastType.error,
          );
        }
        unawaited(AppLogger.localError(
          'AsmaUlHusna: Copy Error',
          error: e,
          stackTrace: stack,
        ));
      }
    };
  }

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
            loaded: (name) {
              _initCallbacks(name);
              return DailyAsmaUlHusnaCardContent(
                name: name,
                onSharePressed: _onSharePressed,
                onCopyPressed: _onCopyPressed,
              );
            },
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
  final AsyncCallback onSharePressed;
  final VoidCallback onCopyPressed;

  @override
  Widget build(BuildContext context) {
    return DailyContentBaseCard(
      title: name.name,
      content: name.meaningDetailed,
      icon: FlutterIslamicIcons.solidAllah,
      footerText: AppStrings.pressHereToSeeMore,
      onTap: () => AppNavigator.pushNamed(context, AppRoutes.asmaUlHusna),
      onSharePressed: onSharePressed,
      onCopyPressed: onCopyPressed,
    );
  }
}
