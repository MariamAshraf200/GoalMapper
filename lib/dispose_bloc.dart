import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart';
import 'injection_imports.dart';

abstract class DisposableBloc {
  void disposeValues();
}

class BlocDisposer implements DisposableBloc {
  final BlocBase _bloc;
  BlocDisposer(this._bloc);

  @override
  void disposeValues() {
    _bloc.close();
  }
}

class AppBlocs {

  static List<DisposableBloc> get allDisposableBlocs {
    return mainBlocs + taskBlocs + categoryBlocs + planBlocs;
  }

  static List<DisposableBloc> get mainBlocs {
    return [
      BlocDisposer(sl<MainTaskBloc>()),
    ];
  }

  static List<DisposableBloc> get taskBlocs {
    return [
      BlocDisposer(sl<TaskBloc>()),
    ];
  }

  static List<DisposableBloc> get categoryBlocs {
    return [
      BlocDisposer(sl<CategoryBloc>()),
    ];
  }

  static List<DisposableBloc> get planBlocs {
    return [
      BlocDisposer(sl<PlanBloc>()),
    ];
  }
}

extension DisposeBlocs on List<DisposableBloc> {
  void dispose() {
    forEach((disposable) => disposable.disposeValues());
  }
}

/// Convenience method to dispose all registered blocs.
void disposeAllBlocs() {
  AppBlocs.allDisposableBlocs.dispose();
}
