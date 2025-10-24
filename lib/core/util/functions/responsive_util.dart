import 'package:flutter/material.dart';
import '../../extensions/context_extensions.dart';



double calculateHorizontalPaddingFromScreenWidth(
  BuildContext context, {
  required double maxAllowedWidth,
  required double defaultPadding,
}) {
  final screenWidth = context.width;

  if (screenWidth <= maxAllowedWidth) {
    return defaultPadding;
  }

  return (screenWidth - maxAllowedWidth) / 2 + defaultPadding;
}

double calculateHorizontalPaddingFromConstraints(
  BoxConstraints constraints, {
  required double maxAllowedWidth,
  required double defaultPadding,
}) {
  final constraintsMaxWidth = constraints.maxWidth;

  if (constraintsMaxWidth <= maxAllowedWidth) {
    return defaultPadding;
  }

  return (constraintsMaxWidth - maxAllowedWidth) / 2 + defaultPadding;
}
