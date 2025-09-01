import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_imports.dart';
import 'injection_container.dart';

class GlobalBloc extends StatelessWidget {
  const GlobalBloc({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, Widget? child) builder;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainTaskBloc>(
          create: (context) => sl<MainTaskBloc>(),
        ),
        BlocProvider<TaskBloc>(
          create: (context) => sl<TaskBloc>(),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => sl<CategoryBloc>()..add(LoadCategoriesEvent()),
        ),
        BlocProvider<PlanBloc>(
          create: (context) => sl<PlanBloc>()..add(GetAllPlansEvent()),
        ),
      ],
      child: Builder(builder: (ctx) => builder(ctx, null)),
    );
  }
}
