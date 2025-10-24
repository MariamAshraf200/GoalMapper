import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
  void pop([result]) => Navigator.of(this).pop(result);
  void push(Widget page) => Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));
}

extension AdditionalContextExtensions on BuildContext {
  /// The same of [MediaQuery.of(context).size]
  Size get mediaQuerySize => MediaQuery.of(this).size;

  /// The same of [MediaQuery.of(context).size.height]
  /// Note: updates when you resize your screen (like on a browser or
  /// desktop window)
  double get height => mediaQuerySize.height;

  /// The same of [MediaQuery.of(context).size.width]
  /// Note: updates when you resize your screen (like on a browser or
  /// desktop window)
  double get width => mediaQuerySize.width;
}

extension StringExtensions on String {
  /// Appends an asterisk to the string if [canBeNull] is false.
  String asteriskIfCantBeNull(bool canBeNull) {
    return canBeNull ? this : '$this *';
  }
}
