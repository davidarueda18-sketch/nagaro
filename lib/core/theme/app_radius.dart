import 'package:flutter/material.dart';

abstract final class AppRadius {
  static const double sm   = 6.0;
  static const double md   = 8.0;
  static const double lg   = 12.0;
  static const double full = 999.0;

  static const BorderRadius smAll   = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll   = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll   = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius fullAll = BorderRadius.all(Radius.circular(full));
}
