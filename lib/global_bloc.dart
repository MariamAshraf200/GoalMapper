import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feature/Home/domain/usecase/compute_weekly_progress_usecase.dart';
import 'feature/Home/domain/usecase/update_daily_progress_usecase.dart';
import 'feature/auth/presentation/bloc/auth_bloc.dart';
import 'feature/auth/data/auth_repository_impl.dart';
import 'feature/auth/domain/usecases/sign_in_with_google.dart';
import 'feature/auth/domain/usecases/sign_out.dart';
import 'feature/auth/domain/usecases/get_current_user.dart';
import 'feature/auth/presentation/bloc/auth_event.dart';
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
