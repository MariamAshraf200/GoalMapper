import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapperapp/feature/Home/presentation/screen/homeScreen.dart';
import 'package:mapperapp/core/widgets/skeletons.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) return const _LoadingView();
        if (state is AuthSignedOut) return const _SignInView();
        if (state is AuthSignedIn) return HomeScreen();
        if (state is AuthError) return _ErrorView(message: state.message);
        return const _LoadingView();
      },
    );
  }
}

// ─────────────────────────────────────────────
// 🔹 Sign In View
// ─────────────────────────────────────────────

class _SignInView extends StatelessWidget {
  const _SignInView();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(Icons.lock_outline, size: 90, color: color.primary),
              const SizedBox(height: 24),
              Text(
                'Welcome Back!',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in securely with your Google account to continue.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey[700]),
              ),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.primary,
                  foregroundColor: color.onPrimary,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  elevation: 2,
                ),
                onPressed: () =>
                    context.read<AuthBloc>().add(SignInEvent()),
                icon: FaIcon(
                  FontAwesomeIcons.google,
                  color: color.onPrimary,
                  size: 22,
                ),
                label: const Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────��─
// 🔹 Error View
// ─────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: color.error, size: 70),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  context.read<AuthBloc>().add(SignOutEvent()),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 🔹 Loading View
// ─────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = colorScheme.surfaceContainerHighest;
    final highlightColor = colorScheme.surface;
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest,
      body: ShimmerLoading(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: MainScreenSkeleton(baseColor: baseColor),
      ),
    );
  }
}
