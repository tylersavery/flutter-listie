import 'package:flutter/material.dart';

class ThemeColors {
  static const primary = Colors.deepOrange;

  static const text = Colors.black87;
  static const textLight = Colors.black54;
}

class ThemeText {
  static const bodyText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: ThemeColors.text,
    height: 1.2,
  );

  static const heading6 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: ThemeColors.text,
    height: 1.2,
  );

  static const caption = TextStyle(
    fontSize: 12,
    color: ThemeColors.textLight,
    height: 1.2,
  );
}
