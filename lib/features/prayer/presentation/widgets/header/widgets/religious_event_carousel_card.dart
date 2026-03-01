import 'package:flutter/material.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/features/prayer/data/models/religious_event_model.dart';
import 'package:sana/features/prayer/data/constants/prayer_strings.dart';
import 'package:sana/features/prayer/data/models/prayer_time_status.dart';
import 'package:sana/features/prayer/presentation/widgets/header/widgets/prayer_status_details_dialog.dart';

class ReligiousEventCarouselCard extends StatelessWidget {
  const ReligiousEventCarouselCard({
    required this.event,
    this.isToday = true,
    super.key,
  });

  final ReligiousEventModel event;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEventDialog(context),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isToday
                    ? PrayerStrings.eventToday
                    : PrayerStrings.upcomingEvent,
                style: AppTextStyles.font12W500White(context).copyWith(
                  color: Colors.white.withAlpha(153),
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                event.displayName,
                style: AppTextStyles.font18W700Gold(
                  context,
                ).copyWith(fontSize: 14),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                PrayerStrings.tapToKnowVirtue,
                style: AppTextStyles.font12W500White(context).copyWith(
                  color: Colors.white.withAlpha(153),
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEventDialog(BuildContext context) {
    final status = PrayerTimeStatus(
      id: 'event_${event.id}',
      status: event.displayName,
      description: event.hadithText ?? PrayerStrings.noVirtueAvailable,
      source: event.bookInfo,
    );
    PrayerStatusDetailsDialog.show(
      context,
      status,
      label: PrayerStrings.hadithLabel,
    );
  }
}
