import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/app_cubit/theme/theme_cubit.dart';
import 'package:sana/core/app_cubit/theme/theme_state.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/widgets/slivers/common_sliver_app_bar.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final mode = switch (state) {
            ThemeInitial() => ThemeMode.system,
            ThemeChanged(:final mode) => mode,
          };

          return Scaffold(
            // Sliver-only body: no ListView/GridView, and the shared sliver
            // app bar keeps RTL/pinned behaviour consistent. This is a tab
            // root, so it must not offer a back affordance.
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
              ],
            ),
          );
        },
      );
}
