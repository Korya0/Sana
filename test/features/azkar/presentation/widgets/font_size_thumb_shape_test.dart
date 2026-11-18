import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sana/features/azkar/presentation/widgets/common/font_size_thumb_shape.dart';

void main() {
  test('preferred size is twice the radius', () {
    const shape = FontSizeThumbShape(
      min: 14,
      max: 32,
      radius: 18,
      backgroundColor: Colors.green,
      textStyle: TextStyle(fontSize: 14),
    );

    expect(shape.getPreferredSize(true, false), const Size(36, 36));
    expect(shape.getPreferredSize(false, true), const Size(36, 36));
  });
}
