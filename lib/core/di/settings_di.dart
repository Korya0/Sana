import 'package:get_it/get_it.dart';
import 'package:sana/features/settings/presentation/cubit/settings_cubit.dart';

void setupSettingsDependencies(GetIt sl) {
  sl.registerFactory<SettingsCubit>(SettingsCubit.new);
}
