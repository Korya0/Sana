import 'package:flutter/material.dart';

class AppFontsFamily {
  AppFontsFamily._();

  static const String cairo = 'Cairo';
  static const String amiriQuran = 'AmiriQuran';
}

enum CairoFontWeight {
  w200(FontWeight.w200),
  w300(FontWeight.w300),
  w400(FontWeight.w400),
  w500(FontWeight.w500),
  w600(FontWeight.w600),
  w700(FontWeight.w700),
  w800(FontWeight.w800),
  w900(FontWeight.w900);

  final FontWeight weight;

  const CairoFontWeight(this.weight);
}

enum AmiriQuranFontWeight {
  w400(FontWeight.w400);

  final FontWeight weight;

  const AmiriQuranFontWeight(this.weight);
}
