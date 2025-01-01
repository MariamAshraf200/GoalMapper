import 'package:flutter/material.dart';

import '../util/functions/responsive_util.dart';



class AppSpaces {
  static const vertical5 = SizedBox(height: 5);
  static const vertical10 = SizedBox(height: 10);
  static const vertical15 = SizedBox(height: 15);
  static const vertical20 = SizedBox(height: 20);
  static const vertical25 = SizedBox(height: 25);
  static const vertical30 = SizedBox(height: 30);
  static const horizontal5 = SizedBox(width: 5);
  static const horizontal10 = SizedBox(width: 10);
  static const horizontal15 = SizedBox(width: 15);
  static const horizontal20 = SizedBox(width: 20);
  static const horizontal25 = SizedBox(width: 25);
  static const horizontal30 = SizedBox(width: 30);

  // for screens padding
  static const horizontalScreenPadding = 20.0;
  static const verticalScreenPadding = 20.0;

  // for responsive
  static const maxAllowedWidth = 900.0;
  static const minAllowedWidthForReport = 1300.0;

  static int gridCrossAxisCount(double width) {
    if (width >= 1200) {
      return 4;
    }
    if (width >= 800) {
      return 3;
    }
    if (width >= 400) {
      return 2;
    }
    return 1;
  }

  static double gridChildAspectRatio(double width) {
    if (width >= 1200) {
      return 3 / 2;
    }
    if (width >= 800) {
      return 4 / 3;
    }
    return 1 / 1;
  }

  static const double gridCrossAxisSpacing = 10;
  static const double gridMainAxisSpacing = 10;

  static EdgeInsets calculatePaddingFromScreenWidth(
    BuildContext context, {
    double verticalPadding = verticalScreenPadding,
  }) {
    return EdgeInsets.symmetric(
      vertical: verticalPadding,
      horizontal: calculateHorizontalPaddingFromScreenWidth(
        context,
        defaultPadding: horizontalScreenPadding,
        maxAllowedWidth: maxAllowedWidth,
      ),
    );
  }

  static EdgeInsets calculatePaddingFromConstraints(
    BoxConstraints constraints, {
    double verticalPadding = verticalScreenPadding,
  }) {
    return EdgeInsets.symmetric(
      vertical: verticalPadding,
      horizontal: calculateHorizontalPaddingFromConstraints(
        constraints,
        defaultPadding: horizontalScreenPadding,
        maxAllowedWidth: maxAllowedWidth,
      ),
    );
  }

  static EdgeInsets calculatePaddingFroReportFromScreenWidth(
    BuildContext context, {
    double verticalPadding = verticalScreenPadding,
  }) {
    return EdgeInsets.symmetric(
      vertical: verticalPadding,
      horizontal: calculateHorizontalPaddingFromScreenWidth(
        context,
        defaultPadding: horizontalScreenPadding,
        maxAllowedWidth: 1300,
      ),
    );
  }
}
