import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/common/widgets/islamic_divider.dart';
import 'package:sana/core/common/widgets/share_buttons.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/widget_to_image.dart';
import 'package:sana/features/asma_ul_husna/data/models/asmaul_husna_model.dart';
import 'package:sana/features/asma_ul_husna/presentation/widgets/asma_ul_husna_share_card.dart';

class AsmaUlHusnaCard extends StatefulWidget {
  const AsmaUlHusnaCard({required this.name, super.key});
  final AsmaulHusnaModel name;

  @override
  State<AsmaUlHusnaCard> createState() => _AsmaUlHusnaCardState();
}

class _AsmaUlHusnaCardState extends State<AsmaUlHusnaCard> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Future<void> _shareCard() async {
    await WidgetToImage.shareWidget(
      context: context,
      widget: AsmaUlHusnaShareCard(name: widget.name),
      imageName: 'share_asma_${widget.name.id}',
    );
  }

  Future<void> _copyToClipboard() async {
    final textToCopy =
        '${widget.name.name}\n${widget.name.meaningBrief}\n\n${widget.name.meaningDetailed}';
    await Clipboard.setData(ClipboardData(text: textToCopy)).then((_) {
      if (mounted) {
        AppToast.show(context, 'تم نسخ اسم الله ${widget.name.name}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _isExpanded
              ? const Color(0x4DFFD700) // accentColor with 0.3 opacity
              : const Color(0x1AFFD700), // accentColor with 0.1 opacity
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _toggleExpand,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header Row (Always visible)
                Row(
                  children: [
                    // 1. The ID Circle (Minimalist)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackground,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0x80FFD700),
                        ), // 0.5 opacity
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${widget.name.id}',
                        style: AppTextStyles.font16W500Grey(context),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // 2. The Name
                    Text(
                      widget.name.name,
                      style: AppTextStyles.font26W700GoldQuran(context),
                    ),

                    const SizedBox(width: 16),

                    // 3. Brief Meaning (Expanded to take remaining space)
                    Expanded(
                      child: Text(
                        widget.name.meaningBrief,
                        style: AppTextStyles.font14W500Grey(
                          context,
                        ).copyWith(height: 1.4),
                        maxLines: _isExpanded ? null : 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ),

                    // 4. Action Buttons (Always Visible)
                    CombinedShareCopyButton(
                      onSharePressed: _shareCard,
                      onCopyPressed: _copyToClipboard,
                      iconSize: 22,
                    ),
                  ],
                ),

                // Expanded Content (Detailed Meaning)
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: _isExpanded
                      ? Column(
                          children: [
                            const SizedBox(height: 16),
                            const CustomAppDivider(),
                            const SizedBox(height: 16),
                            Text(
                              widget.name.meaningDetailed,
                              style: AppTextStyles.font14W400WhiteHeight16(
                                context,
                              ),
                              textAlign: TextAlign.justify,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
