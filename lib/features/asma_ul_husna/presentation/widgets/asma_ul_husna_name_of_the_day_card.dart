import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/sharing/logic/widget_to_image.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/asma_ul_husna_share_card.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_state.dart';
import 'package:sana/features/daily_content/presentation/widgets/card/daily_content_base_card.dart';

class AsmaUlHusnaNameOfTheDayCard extends StatelessWidget {
  const AsmaUlHusnaNameOfTheDayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyContentCubit, DailyContentState>(
      builder: (context, state) {
        final name = state.dailyAsma;
        if (name == null) return const SizedBox.shrink();

        return DailyContentBaseCard(
          title: name.name,
          content: name.meaningDetailed,
          icon: FlutterIslamicIcons.solidAllah,
          footerText: AppStrings.pressHereToSeeMore,
          onTap: () => context.pushNamed(AppRoutes.asmaUlHusna),
          onSharePressed: () async => WidgetToImage.shareWidget(
            context: context,
            widget: AsmaUlHusnaShareCard(name: name),
            imageName: 'share_asma_${name.id}',
          ),
          onCopyPressed: () async {
            final text =
                '${name.name}\n${name.meaningBrief}\n\n${name.meaningDetailed}';
            await Clipboard.setData(ClipboardData(text: text.trim())).then((_) {
              if (context.mounted) {
                AppToast.show(context, AppStrings.copyAsmaUlHusna(name.name));
              }
            });
          },
        );
      },
    );
  }
}
