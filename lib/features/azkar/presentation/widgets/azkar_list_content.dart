import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_constants.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/core/utils/app_clipboard.dart';
import 'package:sana/core/utils/app_logger.dart';
import 'package:sana/core/widgets/app_gap.dart';
import 'package:sana/core/widgets/overlays/app_toast.dart';
import 'package:sana/core/widgets/views/app_empty_view.dart';
import 'package:sana/core/widgets/views/app_error_view.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_cubit.dart';
import 'package:sana/features/azkar/presentation/cubits/azkar/azkar_state.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_list_skeleton.dart';
import 'package:sana/features/azkar/presentation/widgets/share_card/zikr_share_card.dart';
import 'package:sana/features/azkar/presentation/widgets/zikr_card/zikr_item_card.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

const AppLogger _logger = AppLogger();

class AzkarListContent extends StatelessWidget {
  const AzkarListContent({
    required this.onRetry,
    super.key,
    this.onItemCompleted,
  });

  final VoidCallback onRetry;
  final void Function(int index)? onItemCompleted;

  @override
  Widget build(BuildContext context) => BlocBuilder<AzkarCubit, AzkarState>(
    buildWhen: (previous, current) =>
        previous.runtimeType != current.runtimeType,
    builder: (context, state) => switch (state) {
      AzkarLoading() || AzkarInitial() => const AzkarListSkeleton(),
      AzkarError(:final message) => SliverFillRemaining(
        hasScrollBody: false,
        child: AppErrorView(message: message, onRetry: onRetry),
      ),
      AzkarEmpty() => const SliverFillRemaining(
        hasScrollBody: false,
        child: AppEmptyView(message: AppStrings.azkarEmpty),
      ),
      AzkarLoaded(:final azkar) => SliverMainAxisGroup(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
            sliver: SliverList.builder(
              itemCount: azkar.length,
              itemBuilder: (context, index) {
                final zikr = azkar[index];

                return ZikrItemCard(
                  zikr: zikr,
                  onCompleted: () => onItemCompleted?.call(index),
                  onSharePressed: () => _shareZikr(
                    context: context,
                    text: zikr.text,
                    description: zikr.description,
                  ),
                  onCopyPressed: () => AppClipboard.copy(
                    context: context,
                    text: zikr.text,
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(child: AppGap.h(AppSize.p32)),
        ],
      ),
    },
  );
}

Future<void> _shareZikr({
  required BuildContext context,
  required String text,
  String? description,
}) async {
  try {
    final renderBox = context.findRenderObject() as RenderBox?;
    final shareOrigin = renderBox == null
        ? null
        : renderBox.localToGlobal(Offset.zero) & renderBox.size;

    final screenshotController = ScreenshotController();
    final bytes = await screenshotController.captureFromWidget(
      Theme(
        data: AppTheme.dark,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ZikrShareCard(text: text, subText: description),
        ),
      ),
      delay: AppConstants.shareCaptureDelay200ms,
      context: context,
      pixelRatio: AppConstants.shareImagePixelRatio,
    );

    await Share.shareXFiles(
      [
        XFile.fromData(
          bytes,
          mimeType: 'image/png',
          name: AppConstants.shareFileName,
        ),
      ],
      sharePositionOrigin: shareOrigin,
    );
  } on Object catch (error, stackTrace) {
    _logger.error(
      'Azkar share failed',
      error: error,
      stackTrace: stackTrace,
    );

    if (!context.mounted) return;
    AppToast.show(
      context,
      AppStrings.sharingError,
      type: AppToastType.error,
    );
  }
}
