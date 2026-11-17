import 'package:flutter/material.dart';

class AppSize {
  AppSize._();

  static late double _shortestSide;

  static void init(BuildContext context) {
    _shortestSide = MediaQuery.sizeOf(context).shortestSide;
  }

  // Keyboard
  static double keyboardHeight(BuildContext context) =>
      MediaQuery.viewInsetsOf(context).bottom;

  // Breakpoints
  static const double bpMobile = 600;
  static const double bpTablet = 900;
  static const double bpDesktop = 1200;

  // Scaling

  /// Scales [value] relative to screen width and clamps to 0.8-1.3 band.
  static double _scaled(double value) {
    final scaled = value * (_shortestSide / 375);
    final min = value < 0 ? value * 1.3 : value * 0.8;
    final max = value < 0 ? value * 0.8 : value * 1.3;
    return scaled.clamp(min, max);
  }

  // Icons
  static double get icon16 => _scaled(16);
  static double get icon24 => _scaled(24);
  static double get icon32 => _scaled(32);
  static double get icon48 => _scaled(48);

  // Padding
  static double get p4 => _scaled(4);
  static double get p8 => _scaled(8);
  static double get p12 => _scaled(12);
  static double get p16 => _scaled(16);
  static double get p20 => _scaled(20);
  static double get p24 => _scaled(24);
  static double get p32 => _scaled(32);
  static double get p40 => _scaled(40);
  static double get p48 => _scaled(48);

  // Screen padding
  static EdgeInsets get shp => EdgeInsets.symmetric(horizontal: p16);
  static double get stp => p16;
  static double get sbp => p40;

  // Fonts
  static double get f11 => _scaled(11);
  static double get f12 => _scaled(12);
  static double get f14 => _scaled(14);
  static double get f16 => _scaled(16);
  static double get f20 => _scaled(20);
  static double get f24 => _scaled(24);
  static double get f32 => _scaled(32);
  static double get f48 => _scaled(48);

  // Heights
  static double get h18 => _scaled(18);
  static double get h40 => _scaled(40);
  static double get h48 => _scaled(48);
  static double get h56 => _scaled(56);
  static double get h64 => _scaled(64);
  static double get h150 => _scaled(150);
  static double get h200 => _scaled(200);

  // Widths
  static double get w4 => _scaled(4);
  static double get w24 => _scaled(24);
  static double get w40 => _scaled(40);
  static double get w48 => _scaled(48);

  // Radii
  static double get r4 => _scaled(4);
  static double get r8 => _scaled(8);
  static double get r12 => _scaled(12);
  static double get r16 => _scaled(16);
  static double get r18 => _scaled(18);
  static double get r24 => _scaled(24);
  static double get r26 => _scaled(26);

  static double get circularRadius => _scaled(99);

  // Borders
  static double get borderWidth => _scaled(1);
  static double get dividerThickness => _scaled(1);
  static double get progressStrokeWidth => _scaled(4);
  static double get progressStrokeWidthLarge => _scaled(8);

  // Layout
  static const double contentMaxWidth = 640;
  static const double categoryTileMaxExtent = 100;
}
