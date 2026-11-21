import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/app_cubit/theme/theme_cubit.dart';
import 'package:sana/core/app_cubit/theme/theme_state.dart';
import 'package:sana/core/constants/app_strings.dart';

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
        appBar: AppBar(
          title: const Text(AppStrings.settingsTab),
        ),
        body: ListView(
          children: [
            // Theme section
            ListTile(
              title: const Text('المظهر العام'),
              trailing: DropdownButton<ThemeMode>(
                value: mode,
                items: const <DropdownMenuItem<ThemeMode>>[
                  DropdownMenuItem<ThemeMode>(
                    value: ThemeMode.system,
                    child: Text('نظام'),
                  ),
                  DropdownMenuItem<ThemeMode>(
                    value: ThemeMode.light,
                    child: Text('فاتح'),
                  ),
                  DropdownMenuItem<ThemeMode>(
                    value: ThemeMode.dark,
                    child: Text('داكن'),
                  ),
                ],
                onChanged: (ThemeMode? newMode) {
                  if (newMode == null) return;
                  context.read<ThemeCubit>().changeTheme(newMode);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
