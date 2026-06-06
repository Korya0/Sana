import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomCarouselSlider extends StatelessWidget {
  const CustomCarouselSlider({
    required this.items,
    required this.height,
    super.key,
    this.viewportFraction = 1.0,
    this.autoPlay = true,
    this.enlargeCenterPage = false,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.onPageChanged,
    this.autoPlayCurve = Curves.easeInOut,
  });

  final List<Widget> items;
  final double height;
  final double viewportFraction;
  final bool autoPlay;
  final bool enlargeCenterPage;
  final Duration autoPlayInterval;
  final Curve autoPlayCurve;
  final void Function(int index, CarouselPageChangedReason reason)?
  onPageChanged;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return CarouselSlider(
      items: items,
      options: CarouselOptions(
        height: height,
        viewportFraction: viewportFraction,
        autoPlay: autoPlay,
        autoPlayInterval: autoPlayInterval,
        autoPlayCurve: autoPlayCurve,
        enlargeCenterPage: enlargeCenterPage,
        onPageChanged: onPageChanged,
        enableInfiniteScroll: items.length > 1,
      ),
    );
  }
}
