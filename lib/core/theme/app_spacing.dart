import 'package:flutter/material.dart';

/// Design system spacing tokens based on 4px grid.
class AppSpacing {
  AppSpacing._();

  static const double space2xs = 2.0;
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 12.0;
  static const double spaceBase = 16.0;
  static const double spaceLg = 20.0;
  static const double spaceXl = 24.0;
  static const double space2xl = 32.0;
  static const double space3xl = 48.0;
  static const double space4xl = 64.0;
}

/// Design system corner radius tokens.
class AppRadius {
  AppRadius._();

  static const double sm = 6.0;
  static const double base = 10.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double full = 999.0;

  static BorderRadius get smBorder => BorderRadius.circular(sm);
  static BorderRadius get baseBorder => BorderRadius.circular(base);
  static BorderRadius get mdBorder => BorderRadius.circular(md);
  static BorderRadius get lgBorder => BorderRadius.circular(lg);
  static BorderRadius get xlBorder => BorderRadius.circular(xl);
  static BorderRadius get fullBorder => BorderRadius.circular(full);
}
