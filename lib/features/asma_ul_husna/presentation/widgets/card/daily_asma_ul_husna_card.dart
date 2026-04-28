import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/card/daily_content_base_card.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/services/sharing/presentation/utils/widget_to_image_helper.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_cubit.dart';
import 'package:sana/features/asma_ul_husna/presentation/cubit/asma_ul_husna_state.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/share_card/asma_ul_husna_share_card.dart';

class DailyAsmaUlHusnaCard extends StatelessWidget {
  const DailyAsmaUlHusnaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AsmaUlHusnaCubit, AsmaUlHusnaState>(
      builder: (context, state) {
        AsmaulHusnaModel? name;
        if (state is DailyAsmaUlHusnaLoaded) {
          name = state.name;
        } else if (state is AsmaUlHusnaLoaded) {
          final now = DateTime.now();
          final dayOfYear = now.difference(DateTime(now.year)).inDays;
          name = state.names[dayOfYear % state.names.length];
        }

        if (name == null) return const SizedBox.shrink();

        return DailyContentBaseCard(
          title: name.name,
          content: name.meaningDetailed,
          icon: FlutterIslamicIcons.solidAllah,
          footerText: AppStrings.pressHereToSeeMore,
          onTap: () => context.pushNamed(AppRoutes.asmaUlHusna),
          onSharePressed: () async => WidgetToImageHelper.shareWidget(
            context: context,
            widget: AsmaUlHusnaShareCard(name: name!),
            imageName: 'share_asma_${name.id}',
          ),
          onCopyPressed: () async {
            final text =
                '${name!.name}\n${name.meaningBrief}\n\n${name.meaningDetailed}';
            await Clipboard.setData(ClipboardData(text: text.trim()));
          },
        );
      },
    );
  }
}
