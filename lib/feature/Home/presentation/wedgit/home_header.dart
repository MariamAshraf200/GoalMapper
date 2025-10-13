import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.inversePrimary, colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 👋 Subtle greeting
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Hello 👋",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Welcome back",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),

            // 🎛️ Modern rounded icons
            const SizedBox(width: 12),
            PopupMenuButton<void>(
              icon: Icon(Icons.more_vert_sharp, color: colorScheme.onPrimary, size: 22),
              itemBuilder: (context) => [
                PopupMenuItem<void>(
                  // Use StatefulBuilder so the switch visually updates inside the popup
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      final isDark = AppTheme.instance.isDark;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Dark theme'),
                          Switch(
                            value: isDark,
                            onChanged: (value) {
                              AppTheme.instance.setMode(value ? ThemeMode.dark : ThemeMode.light);
                              // update visual state inside menu
                              setState(() {});
                              // close the popup after toggling
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
