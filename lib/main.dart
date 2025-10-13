import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart';
import 'app_bootstrapper.dart';
import 'core/theme/theme_mode_cubit.dart';
import 'core/i18n/language_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: SystemUiOverlay.values,
  );

  await init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeModeCubit>(create: (_) => ThemeModeCubit()),
        BlocProvider<LanguageCubit>(create: (_) => LanguageCubit()),
      ],
      child: const AppBootstrapper(),
    ),
  );
}
