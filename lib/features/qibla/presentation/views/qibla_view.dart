import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/app_error_widget.dart';
import 'package:sana/core/common/widgets/common_sliver_app_bar.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/qibla/presentation/controller/qibla_cubit.dart';
import 'package:sana/features/qibla/presentation/widgets/loaded/qibla_view_loaded_widget.dart';
import 'package:sana/features/qibla/presentation/widgets/qibla_help_dialog.dart';
import 'package:sana/features/qibla/presentation/widgets/skeletonizer_qiblaview.dart';

class QiblaView extends StatefulWidget {
  const QiblaView({super.key});

  @override
  State<QiblaView> createState() => _QiblaViewState();
}

class _QiblaViewState extends State<QiblaView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<QiblaCubit>()..initQibla(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            CommonSliverAppBar(
              title: 'اتجاه القبلة',
              actions: [
                IconButton(
                  onPressed: () async {
                    await showQiblaHelpDialog(context);
                  },
                  icon: const Icon(
                    Icons.help_outline_rounded,
                    color: AppColors.iconWhite,
                  ),
                ),
              ],
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: BlocBuilder<QiblaCubit, QiblaState>(
                builder: (context, state) {
                  if (state is QiblaLoading) {
                    return const SkeletonizerQiblaview();
                  } else if (state is QiblaError) {
                    return AppErrorWidget(
                      title: 'عذراً، حدث خطأ',
                      message:
                          'لم نتمكن من تحميل مواقيت الصلاة. ساعدنا في تحسين التطبيق بإرسال بلاغ عن المشكلة، جزاك الله خيراً',
                      onRetry: () => context.read<QiblaCubit>().initQibla(),
                      technicalMessage: state.message,
                    );
                  } else if (state is QiblaLoaded) {
                    return QiblaViewLoadedWidget(state: state);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
