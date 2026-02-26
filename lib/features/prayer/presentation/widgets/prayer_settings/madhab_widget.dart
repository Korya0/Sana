import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/custom_bottom_sheet.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/prayer/presentation/widgets/prayer_settings/settings_tile_widget.dart';

class MadhabWidget extends StatefulWidget {
  const MadhabWidget({
    required this.selectedMadhab,
    required this.onMadhabSelected,
    super.key,
  });
  final Madhab selectedMadhab;
  final ValueChanged<Madhab> onMadhabSelected;

  @override
  State<MadhabWidget> createState() => _MadhabWidgetState();
}

class _MadhabWidgetState extends State<MadhabWidget> {
  String _getMadhabArabicName(Madhab madhab) {
    return madhab == Madhab.shafi ? 'الشافعي' : 'الحنفي';
  }

  Future<void> _showMadhabBottomSheet(BuildContext context) async {
    await showCustomBottomSheet(
      context,
      title: 'المذهب الفقهي',
      child: Column(
        children: [
          Divider(
            height: 1,
            color: AppColors.gold.withValues(alpha: 0.1),
          ),
          ...Madhab.values.map((madhab) {
            final isSelected = madhab == widget.selectedMadhab;
            return ListTile(
              title: Text(
                _getMadhabArabicName(madhab),
                style: AppTextStyles.font16W600White(context).copyWith(
                  color: isSelected ? AppColors.primary : AppColors.iconWhite,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                widget.onMadhabSelected(madhab);
                context.pop();
              },
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsTileWidget(
      icon: Icons.book_outlined,
      title: _getMadhabArabicName(widget.selectedMadhab),
      onTap: () => _showMadhabBottomSheet(context),
    );
  }
}
