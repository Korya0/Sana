import 'package:flutter/material.dart';

class AppGap extends StatelessWidget {
  const AppGap.w(this.width, {super.key}) : height = null;
  const AppGap.h(this.height, {super.key}) : width = null;

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    height: height,
  );
}
