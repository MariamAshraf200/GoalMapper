import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A skeleton placeholder for the main screen, with customizable base color.
class MainScreenSkeleton extends StatelessWidget {
  /// The color used for the skeleton boxes. Defaults to a light theme color.
  final Color? baseColor;
  const MainScreenSkeleton({super.key, this.baseColor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final skeletonColor = baseColor ?? colorScheme.surface.withAlpha( 20);
    final avatarColor = baseColor ?? colorScheme.surface.withAlpha( 30);
    final lineColor = baseColor ?? colorScheme.surface.withAlpha( 40);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header placeholder (wide bar)
          Container(
            height: 56,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 28),
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          // Status cards row (3 cards)
          Row(
            children: List.generate(3, (i) => Expanded(
              child: Container(
                height: 150,
                margin: EdgeInsets.only(left: i == 0 ? 0 : 10, right: i == 2 ? 0 : 10),
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            )),
          ),
          const SizedBox(height: 28),
          // Weekly progress bar placeholder
          Container(
            height: 20,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 28),
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          ...List.generate(4, (i) => Container(
            height: 64,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                // Leading avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: avatarColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 14),
                // Title and subtitle lines
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: lineColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      Container(
                        height: 10,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color: lineColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                // Trailing icon/button
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

/// A shimmer effect wrapper for loading states, with customizable colors.
class ShimmerLoading extends StatelessWidget {
  /// The widget to apply the shimmer effect to.
  final Widget child;
  /// The base color of the shimmer. Defaults to a light theme color.
  final Color? baseColor;
  /// The highlight color of the shimmer. Defaults to a very light theme color.
  final Color? highlightColor;
  const ShimmerLoading({required this.child, this.baseColor, this.highlightColor, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    // Use a very light color for shimmer base in light mode, surfaceVariant in dark mode
    final shimmerBase = baseColor ?? (brightness == Brightness.light
        ? Colors.grey[200]!
        : colorScheme.surfaceContainerHighest);
    final shimmerHighlight = highlightColor ?? (brightness == Brightness.light
        ? Colors.grey[100]!
        : colorScheme.surface);
    return Shimmer.fromColors(
      baseColor: shimmerBase,
      highlightColor: shimmerHighlight,
      child: child,
    );
  }
}
