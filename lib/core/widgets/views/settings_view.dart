import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/app_cubit/theme/theme_cubit.dart';
import 'package:sana/core/app_cubit/theme/theme_state.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/theme/icons/app_icons.dart';
import 'package:sana/core/utils/context_extension.dart';
import 'package:sana/core/widgets/cards/app_section_card.dart';
import 'package:sana/core/widgets/interaction/app_pressable.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, _) {
          final mode = context.read<ThemeCubit>().currentMode;

          return Scaffold(
            // Settings
            body: CustomScrollView(
              slivers: [
                const CommonSliverAppBar(
                  title: AppStrings.settingsTab,
                  showBack: false,
                ),
                SliverToBoxAdapter(
                  child: ListTile(
                    title: const Text(AppStrings.generalAppearance),
                    trailing: DropdownButton<ThemeMode>(
                      value: mode,
                      items: const <DropdownMenuItem<ThemeMode>>[
                        DropdownMenuItem<ThemeMode>(
                          value: ThemeMode.system,
                          child: Text(AppStrings.themeSystem),
                        ),
                        DropdownMenuItem<ThemeMode>(
                          value: ThemeMode.light,
                          child: Text(AppStrings.themeLight),
                        ),
                        DropdownMenuItem<ThemeMode>(
                          value: ThemeMode.dark,
                          child: Text(AppStrings.themeDark),
                        ),
                      ],
                      onChanged: (ThemeMode? newMode) {
                        if (newMode == null) return;
                        context.read<ThemeCubit>().changeTheme(newMode);
                      },
                    ),
                  ),
                ),
                // Qibla
                SliverToBoxAdapter(
                  child: AppSectionCard(
                    padding: EdgeInsets.zero,
                    child: AppPressable(
                      onPressed: () => context.push(AppRoutes.qiblaView),
                      semanticLabel: AppStrings.qiblaHeader,
                      excludeChildSemantics: true,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.p16,
                          vertical: AppSize.p12,
                        ),
                        child: Row(
                          children: [
                            const Text(AppStrings.qiblaHeader),
                            const Spacer(),
                            Icon(
                              AppIcons.compass,
                              size: AppSize.icon24,
                              color: context.color.iconNeutral,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
}
