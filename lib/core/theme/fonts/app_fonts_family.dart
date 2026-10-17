import 'package:flutter/material.dart';

class AppFontsFamily {
  AppFontsFamily._();

  static const String cairo = 'Cairo';
  static const String amiriQuran = 'AmiriQuran';
}

enum CairoFontWeight {
  w500(FontWeight.w500),
  w700(FontWeight.w700);

  final FontWeight weight;

  const CairoFontWeight(this.weight);
}

enum AmiriQuranFontWeight {
  w400(FontWeight.w400);

  final FontWeight weight;

  const AmiriQuranFontWeight(this.weight);
}
