import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feature/Home/domain/usecase/compute_weekly_progress_usecase.dart';
import 'feature/Home/domain/usecase/update_daily_progress_usecase.dart';
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
        BlocProvider<TaskBloc>(
          create: (context) => sl<TaskBloc>(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(
            taskBloc: context.read<TaskBloc>(),
            computeWeeklyProgress: sl<ComputeWeeklyProgressUsecase>(),
            updateDailyProgress: sl<UpdateDailyProgressUsecase>(),
          )..add(HomeStarted()),
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
