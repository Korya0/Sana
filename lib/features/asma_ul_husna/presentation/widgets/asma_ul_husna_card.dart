// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sana/core/common/widgets/share_buttons.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/core/utils/widget_to_image.dart';
import 'package:sana/core/common/widgets/islamic_divider.dart';
import '../../domain/entities/asma_ul_husna.dart';
import 'asma_ul_husna_share_card.dart';

class AsmaUlHusnaCard extends StatefulWidget {
  final AsmaUlHusna name;

  const AsmaUlHusnaCard({super.key, required this.name});

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
    try {
      final imageBytes = await WidgetToImage.capture(
        context: context,
        widget: AsmaUlHusnaShareCard(name: widget.name),
      );

      if (imageBytes == null) return;

      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/share_asma_${widget.name.id}_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: '${widget.name.name} - ${widget.name.meaningBrief}');
    } catch (e) {
      debugPrint('Error sharing card: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = AppColors.gold;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _isExpanded
              ? accentColor.withOpacity(0.3)
              : accentColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _toggleExpand,
          child: Padding(
            padding: EdgeInsets.all(16),
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
                        border: Border.all(color: accentColor.withOpacity(0.5)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${widget.name.id}',
                        style: AppTextStyles.font16W500Grey(context),
                      ),
                    ),
                    SizedBox(width: 16),

                    // 2. The Name
                    Text(
                      widget.name.name,
                      style: AppTextStyles.font26W700GoldQuran(context),
                    ),

                    SizedBox(width: 16),

                    // 3. Brief Meaning (Expanded to take remaining space)
                    Expanded(
                      child: Text(
                        widget.name.meaningBrief,
                        style: AppTextStyles.font14W500Grey(
                          context,
                        ).copyWith(height: 1.4),
                        maxLines: _isExpanded ? 10 : 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ),

                    // 4. Share Button (Always Visible)
                    SizedBox(width: 8),
                    ShareButton(onSharePressed: _shareCard, iconSize: 20),
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
                            SizedBox(height: 16),
                            const CustomAppDivider(),
                            SizedBox(height: 16),
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
