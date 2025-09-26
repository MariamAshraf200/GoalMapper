import 'dart:io';

import 'package:flutter/material.dart';

class SlidePageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  final Offset? beginOffset;
  final Duration duration;

  SlidePageRoute({
    required this.builder,
    required this.beginOffset,
    this.duration = const Duration(milliseconds: 500),
    super.settings,
  });

  @override
  bool get opaque => true;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;

  @override
  Duration get reverseTransitionDuration => duration;

  // iOS swipe back support
  @override
  bool get popGestureEnabled => true;

  @override
  bool get fullscreenDialog => false;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    final screenTransitionDirection =
    Directionality.of(context) == TextDirection.rtl ? -1.0 : 1.0;

    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset ?? Offset(screenTransitionDirection, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

/// Navigates to a new [screen] with slide transition animation.
///
/// This function pushes a new route onto the navigator stack with a customizable
/// slide transition. The slide direction automatically adjusts based on the text
/// direction (RTL or LTR).
///
/// - [context]: The build context from which to navigate.
/// - [screen]: The widget to display as the new screen.
/// - [beginOffset]: The starting offset for the slide transition. If null, defaults
///   to horizontal slide based on text direction (left-to-right for LTR, right-to-left for RTL).
/// - [transitionDuration]: Duration of the forward transition animation. Defaults to 300ms.
///
/// Returns a [Future] that completes with the result of the pushed route, if any.
///
/// Example:
/// ```dart
/// navigateToScreenWithSlideTransition(
///   context,
///   MyNewScreen(),
///   beginOffset: Offset(0, 1), // Slide from bottom
///   transitionDuration: Duration(milliseconds: 500),
/// );
/// ```
Future<T?> navigateToScreenWithSlideTransition<T>(
    BuildContext context,
    Widget screen, {
      Offset? beginOffset,
      Duration transitionDuration = const Duration(milliseconds: 500),
    }) {
  return Navigator.push<T>(
    context,
    Platform.isIOS
        ? MaterialPageRoute(builder: (context) => screen)
        : SlidePageRoute<T>(
      builder: (_) => screen,
      beginOffset: beginOffset,
      duration: transitionDuration,
    ),
  );
}

/// Navigates to a new [screen] with slide transition and replaces the current route in the navigation stack.
///
/// This function provides slide transition animation when replacing the current route.
///
/// - [context]: The build context from which to navigate.
/// - [screen]: The widget to display as the new screen.
/// - [result]: An optional value to return to the previous route when this new route is popped.
/// - [beginOffset]: The starting offset for the slide transition. If null, defaults to horizontal slide based on text direction.
/// - [transitionDuration]: Duration of the forward transition animation.
/// - [reverseTransitionDuration]: Duration of the reverse transition animation.
///
/// Returns a [Future] that completes to the `result` value when the pushed route is popped.
Future<T?> navigateWithReplacementAndSlideTransition<T, TO extends Object?>(
    BuildContext context,
    Widget screen, {
      TO? result,
      Offset? beginOffset,
      Duration transitionDuration = const Duration(milliseconds: 500),
      // Duration reverseTransitionDuration = const Duration(milliseconds: 500),
    }) {
  return Navigator.pushReplacement<T, TO>(
    context,
    Platform.isIOS
        ? MaterialPageRoute(builder: (context) => screen)
        : SlidePageRoute<T>(
      builder: (_) => screen,
      beginOffset: beginOffset,
      duration: transitionDuration,
    ),
    result: result,
  );
}

Future<T?> navigateTo<T>(BuildContext context, Widget widget) =>
    Navigator.push<T>(context, MaterialPageRoute(builder: (context) => widget));

/// Navigates to a new [screen] and replaces the current route in the navigation stack.
///
/// This function provides an option to navigate with or without a transition animation.
///
/// - [context]: The build context from which to navigate.
/// - [screen]: The widget to display as the new screen.
/// - [result]: An optional value to return to the previous route when this new route is popped.
/// - [withOutAnimation]: If true, the navigation will occur without any transition animation.
///   Defaults to true.
///
/// Returns a [Future] that completes to the `result` value when the pushed route is popped.
Future<T?> navigateWithReplacement<T, TO extends Object?>(
    BuildContext context,
    Widget screen, {
      TO? result,
      bool withOutAnimation = true,
    }) {
  final route =
  withOutAnimation
      ? Platform.isIOS
      ? MaterialPageRoute(builder: (context) => screen) as PageRoute<T>
      : SlidePageRoute<T>(
    builder: (context) => screen,
    beginOffset: const Offset(0, 0), // No slide effect
    duration: const Duration(milliseconds: 10),
  )
      :
  // Use the default MaterialPageRoute for animation
  // This will give you the default transition animation
  // You can customize it further if needed
  MaterialPageRoute<T>(builder: (context) => screen);

  return Navigator.pushReplacement<T, TO>(context, route, result: result);
}

/// Navigates to a new screen and optionally removes previous routes from the stack.
///
/// This function pushes a new route onto the navigator stack and removes routes
/// based on the `removeUntil` parameter. If `removeUntil` is `true`, all previous
/// routes will be removed. If `removeUntil` is `false`, only the current route
/// will be removed, leaving the first route in the stack.
///
/// - [context]: The `BuildContext` used to find the `Navigator` for navigation.
/// - [widget]: The widget representing the new screen to navigate to.
/// - [removeUntil]: A boolean flag indicating whether to remove all previous
///   routes (`true`) or only the current route (`false`). Defaults to `false`.
///
/// Returns a `Future` that completes with the result of the pushed route, if any.
///
/// Example:
/// ```dart
/// navigateToAndFinish(
///   context,
///   MyNewScreen(),
///   removeUntil: true,
/// );
/// ```
Future<T?> navigateToAndFinish<T>(
    BuildContext context,
    Widget widget, {
      bool removeUntil = false,
    }) {
  return Navigator.pushAndRemoveUntil<T>(
    context,
    MaterialPageRoute(builder: (context) => widget),
        (route) => removeUntil ? false : route.isFirst,
  );
}




////////  Use it in `SlidePageRoute<T>` if you want to enable swipe back gesture support for all platforms.///
///////

// @override
// Widget buildPage(
//   BuildContext context,
//   Animation<double> animation,
//   Animation<double> secondaryAnimation,
// ) {
//   return GestureDetector(
//     onHorizontalDragUpdate: (details) {
//       final delta = details.primaryDelta ?? 0;
//       final isRtl = Directionality.of(context) == TextDirection.rtl;

//       // LTR: swipe right (positive delta)
//       // RTL: swipe left (negative delta)
//       final shouldPop = isRtl ? delta < -20 : delta > 20;

//       if (shouldPop) {
//         Navigator.of(context).maybePop();
//       }
//     },
//     child: builder(context),
//   );
// }