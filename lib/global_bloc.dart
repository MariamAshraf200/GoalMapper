import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_imports.dart';

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
        // ─────────────────────────────── AUTH ───────────────────────────────
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            signInWithGoogle: sl<SignInWithGoogle>(),
            signOut: sl<SignOut>(),
            getCurrentUser: sl<GetCurrentUser>(),
          )..add(CheckSignInEvent()),
        ),

        // ─────────────────────────────── TASK ───────────────────────────────
        BlocProvider<TaskBloc>(
          create: (_) => sl<TaskBloc>(),
        ),

        // ─────────────────────────────── HOME ───────────────────────────────
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(
            computeWeeklyProgress: sl<ComputeWeeklyProgressUsecase>(),
            updateDailyProgress: sl<UpdateDailyProgressUsecase>(),
             getAllTasksUseCase: sl<GetAllTasksUseCase>()
          )..add(HomeStarted()),
        ),

        // ─────────────────────────────── CATEGORY ───────────────────────────────
        BlocProvider<CategoryBloc>(
          create: (_) => sl<CategoryBloc>()..add(LoadCategoriesEvent()),
        ),

        // ─────────────────────────────── PLAN ───────────────────────────────
        BlocProvider<PlanBloc>(
          create: (_) => sl<PlanBloc>()..add(GetAllPlansEvent()),
        ),
      ],
      child: Builder(builder: (ctx) => builder(ctx, null)),
    );
  }
}
