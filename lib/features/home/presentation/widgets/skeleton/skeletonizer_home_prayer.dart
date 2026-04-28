import 'package:flutter/material.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonizerHomePrayer extends StatelessWidget {
  const SkeletonizerHomePrayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // Wave Mockup
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Container(color: AppColors.scaffoldBackground),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                spacing: 12,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  // Date and City Mockup
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Bone.text(words: 2),
                        Bone.text(words: 1),
                      ],
                    ),
                  ),

                  // Carousel Mockup (Countdown)
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Bone.text(words: 2),
                      SizedBox(height: 4),
                      Bone.text(
                        words: 1,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Prayer Grid Mockup
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        5,
                        (index) => Bone.square(
                          size: 65,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
