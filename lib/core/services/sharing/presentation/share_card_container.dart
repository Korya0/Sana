import 'package:flutter/material.dart';
import 'package:sana/core/utils/utils.dart';

class ShareCardContainer extends StatelessWidget {
  const ShareCardContainer({
    required this.child,
    super.key,
  });
  final Widget child;

  static const double _kDefaultWidth = 500;
  static const double _kMaxHeight = 800;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kDefaultWidth.r(context),
      constraints: BoxConstraints(maxHeight: _kMaxHeight.r(context)),
      child: child,
    );
  }
}
