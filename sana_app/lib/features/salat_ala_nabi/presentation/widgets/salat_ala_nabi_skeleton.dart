import 'package:flutter/material.dart';
import 'package:sana/core/common/slivers/common_sliver_app_bar.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/features/salat_ala_nabi/data/models/reminder_settings.dart';
import 'package:sana/features/salat_ala_nabi/data/salawat_constants.dart';
import 'package:sana/features/salat_ala_nabi/presentation/widgets/salat_ala_nabi_view_content.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SalatAlaNabiSkeleton extends StatelessWidget {
  const SalatAlaNabiSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Skeletonizer(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            CommonSliverAppBar(title: AppStrings.salawatReminderTitle),
            SalatAlaNabiViewContent(
              isSkeleton: true,
              settings: ReminderSettingsModel(
                isEnabled: true,
                intervalMinutes: 15,
                startHour: 10,
                startMinute: 0,
                endHour: 22,
                endMinute: 0,
                workingHoursMode: WorkingHoursMode.allDay,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
