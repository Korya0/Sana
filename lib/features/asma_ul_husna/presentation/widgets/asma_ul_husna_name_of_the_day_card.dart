import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/sharing/logic/widget_to_image.dart';
import 'package:sana/core/sharing/presentation/combined_share_copy_button.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/asma_ul_husna_share_card.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_cubit.dart';
import 'package:sana/features/daily_content/presentation/controller/daily_content_state.dart';

class AsmaUlHusnaNameOfTheDayCard extends StatelessWidget {
  const AsmaUlHusnaNameOfTheDayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyContentCubit, DailyContentState>(
      builder: (context, state) {
        final name = state.dailyAsma;
        if (name == null) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [AppColors.green, AppColors.green2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B4332).withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // الأيقونة في الخلفية (تحت العناصر)
              Positioned(
                right: -0,
                bottom: -0,
                child: Icon(
                  FlutterIslamicIcons.solidAllah,
                  size: 150,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              InkWell(
                onTap: () => context.push('/asma-ul-husna'),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              name.name,
                              style: AppTextStyles.font26W700GoldQuran(context)
                                  .copyWith(
                                    fontSize: 28,
                                    height: 1,
                                  ),
                            ),
                          ),
                          CombinedShareCopyButton(
                            isCombined: false,
                            onSharePressed: () async =>
                                WidgetToImage.shareWidget(
                                  context: context,
                                  widget: AsmaUlHusnaShareCard(name: name),
                                  imageName: 'share_asma_${name.id}',
                                ),
                            onCopyPressed: () async =>
                                Clipboard.setData(
                                  ClipboardData(
                                    text:
                                        '${name.name}\n${name.meaningBrief}\n\n${name.meaningDetailed}',
                                  ),
                                ).then((_) {
                                  if (context.mounted) {
                                    AppToast.show(
                                      context,
                                      'تم نسخ اسم الله ${name.name}',
                                    );
                                  }
                                }),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        name.meaningDetailed,
                        style: AppTextStyles.font16W500White(context),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
