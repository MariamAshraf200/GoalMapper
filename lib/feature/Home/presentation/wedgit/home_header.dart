import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/i18n/language_cubit.dart';
import '../../../../core/theme/theme_mode_cubit.dart';
import '../../../../core/theme/palette_cubit.dart';
import '../../../../core/theme/palettes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

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
            // 👋 Subtle greeting + avatar (uses AuthBloc)
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                String displayName = 'Guest';
                String? photoUrl;
                if (state is AuthSignedIn) {
                  displayName = state.user.name.isNotEmpty ? state.user.name : displayName;
                  photoUrl = state.user.photoUrl;
                }
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white24,
                      backgroundImage: (photoUrl != null && photoUrl.isNotEmpty) ? NetworkImage(photoUrl) : null,
                      child: (photoUrl == null || photoUrl.isEmpty)
                          ? Text(
                              displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Localized greeting (reactive)
                        Text(
                          '${l10n.hello} ${displayName.split(' ').first}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

            // 🎛️ Modern rounded icons
            Row(
              children: [
                _buildPopupMenu(context, colorScheme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context, ColorScheme colorScheme) {
    final l10n = context.l10n;
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_sharp, color: colorScheme.onPrimary, size: 22),
      onSelected: (value) async {
        if (value == 'logout') {
          context.read<AuthBloc>().add(SignOutEvent());
        } else if (value == 'toggle_theme') {
          // Toggle theme directly and persist via ThemeModeCubit
          final themeMode = context.read<ThemeModeCubit>().state;
          final newMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
          await context.read<ThemeModeCubit>().setThemeMode(newMode);
        } else if (value == 'toggle_lang') {
          // Toggle language between English and Arabic
          await context.read<LanguageCubit>().toggle();
        } else if (value == 'change_palette') {
          _showPalettePicker(context, colorScheme);
        }
      },
      itemBuilder: (context) {
        final isDark = context.read<ThemeModeCubit>().state == ThemeMode.dark;
        final isArabic = context.read<LanguageCubit>().state.languageCode == 'ar';
        return [

          PopupMenuItem<String>(
            value: 'toggle_lang',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.language, color: colorScheme.inverseSurface),
                const SizedBox(width: 8),
                Text(isArabic ? l10n.arabic : l10n.english),
              ],
            ),
          ),

          PopupMenuItem<String>(
            value: 'change_palette',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.palette, color: colorScheme.inverseSurface),
                const SizedBox(width: 8),
                Text(l10n.chooseThemeColor),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'toggle_theme',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: colorScheme.inverseSurface),
                const SizedBox(width: 8),
                Text(l10n.toggleTheme),
              ],
            ),
          ),

          PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.logout),
                const SizedBox(width: 8),
                Text(l10n.logout),
              ],
            ),
          ),
        ];
      },
    );
  }

  void _showPalettePicker(BuildContext context, ColorScheme colorScheme) {
    final l10n = context.l10n;

    final current = context.read<PaletteCubit>().state;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(l10n.chooseThemeColor, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
              ),
              ...ThemePalette.values.map((p) {
                final palette = kPalettes[p]!;
                final colorNames = {
                  'purple': l10n.palettePurple,
                  'blue': l10n.paletteBlue,
                  'green': l10n.paletteGreen,
                  'red': l10n.paletteRed,
                  'mix': l10n.paletteMix,
                };

                return ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: palette.primary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black12),
                    ),
                  ),
                  title: Text(colorNames[p.name] ?? p.name),
                  trailing: p == current ? Icon(Icons.check, color: palette.secondary) : null,
                  onTap: () async {
                    await context.read<PaletteCubit>().setPalette(p);
                    Navigator.of(ctx).pop();
                  },
                );
              }).toList(),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
