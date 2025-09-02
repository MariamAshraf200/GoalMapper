import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'injection_container.dart';
import 'app_bootstrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: SystemUiOverlay.values,
  );

  await init();
  runApp(const AppBootstrapper());
}
