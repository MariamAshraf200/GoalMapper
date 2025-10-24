import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DisposableBloc {
  Future<void> disposeValues();
}

class BlocDisposer implements DisposableBloc {
  final BlocBase bloc;
  BlocDisposer(this.bloc);

  @override
  Future<void> disposeValues() async {
    await bloc.close();
  }
}

class AppBlocs {
  static final List<BlocBase> _activeBlocs = [];

  /// Register a bloc when it's created (usually inside GlobalBloc)
  static void register(BlocBase bloc) {
    _activeBlocs.add(bloc);
  }

  /// Dispose all active blocs safely
  static Future<void> disposeAll() async {
    for (final bloc in _activeBlocs) {
      await bloc.close();
    }
    _activeBlocs.clear();
  }
}
