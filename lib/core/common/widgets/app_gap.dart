import 'package:flutter/material.dart';

class AppGap extends StatelessWidget {
  const AppGap({
    super.key,
    this.w,
    this.h,
  });

  const AppGap.w(double width, {super.key}) : w = width, h = null;
  const AppGap.h(double height, {super.key}) : w = null, h = height;

  final double? w;
  final double? h;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      height: h,
    );
  }
}
