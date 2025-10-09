import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  /// The same of [MediaQuery.of(context).size]
  Size get mediaQuerySize => MediaQuery.of(this).size;

  /// The same of [MediaQuery.of(context).size.height]
  /// Note: updates when you rezise your screen (like on a browser or
  /// desktop window)
  double get height => mediaQuerySize.height;

  /// The same of [MediaQuery.of(context).size.width]
  /// Note: updates when you rezise your screen (like on a browser or
  /// desktop window)
  double get width => mediaQuerySize.width;
}

extension StringExtensions on String {
  /// Appends an asterisk to the string if [canBeNull] is false.
  String asteriskIfCantBeNull(bool canBeNull) {
    return canBeNull ? this : '$this *';
  }
}
