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
    final repository = AuthRepositoryImpl();
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            signInWithGoogle: SignInWithGoogle(repository),
            signOut: SignOut(repository),
            getCurrentUser: GetCurrentUser(repository),
          )..add(CheckSignInEvent()),
        ),
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
