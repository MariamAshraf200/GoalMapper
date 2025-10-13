import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../taskHome/domain/entity/taskEntity.dart';
import '../../../taskHome/presintation/bloc/taskBloc/bloc.dart';
import '../../../taskHome/presintation/bloc/taskBloc/state.dart' as taskState;
import '../../domain/entity/week_progress.dart';
import '../../domain/usecase/compute_weekly_progress_usecase.dart';
import '../../domain/usecase/update_daily_progress_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TaskBloc taskBloc;
  final ComputeWeeklyProgressUsecase computeWeeklyProgress;
  final UpdateDailyProgressUsecase updateDailyProgress;
  late final StreamSubscription _taskSub;

  HomeBloc({
    required this.taskBloc,
    required this.computeWeeklyProgress,
    required this.updateDailyProgress,
  }) : super(HomeInitial()) {
    on<HomeStarted>(_onStarted);
    on<HomeTasksUpdated>(_onTasksUpdated);

    _taskSub = taskBloc.stream.listen((s) {
      if (s is taskState.TaskLoaded) add(HomeTasksUpdated(s.tasks));
    });

    // Seed if already loaded
    final cur = taskBloc.state;
    if (cur is taskState.TaskLoaded) add(HomeTasksUpdated(cur.tasks));
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    final cur = taskBloc.state;
    if (cur is taskState.TaskLoaded) {
      _emitProgress(cur.tasks, emit, forceFullRecompute: true);
    } else {
      emit(HomeLoading());
    }
  }

  Future<void> _onTasksUpdated(HomeTasksUpdated event, Emitter<HomeState> emit) async {
    _emitProgress(event.tasks, emit);
  }

  void _emitProgress(List<TaskDetails> allTasks, Emitter<HomeState> emit,
      {bool forceFullRecompute = false}) {
    final now = DateTime.now();
    final daysToSubtract = (now.weekday + 1) % 7;
    final startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: daysToSubtract));
    final days = List.generate(7, (i) {
      final d = startOfWeek.add(Duration(days: i));
      return DateTime(d.year, d.month, d.day);
    });

    if (!forceFullRecompute && state is HomeLoaded) {
      final prev = state as HomeLoaded;
      if (listEquals(prev.days, days)) {
        final updated = updateDailyProgress.update(
          previousProgress: WeeklyProgress(
            days: prev.days,
            dailyProgress: prev.dailyProgress,
            avgProgress: prev.avgProgress,
            bestDayName: prev.bestDayName,
            todayIndex: prev.todayIndex,
          ),
          allTasks: allTasks,
        );

        emit(HomeLoaded(
          days: updated.days,
          dailyProgress: updated.dailyProgress,
          avgProgress: updated.avgProgress,
          bestDayName: updated.bestDayName,
          todayIndex: updated.todayIndex,
        ));
        return;
      }
    }

    final fullProgress = computeWeeklyProgress(allTasks);
    emit(HomeLoaded(
      days: fullProgress.days,
      dailyProgress: fullProgress.dailyProgress,
      avgProgress: fullProgress.avgProgress,
      bestDayName: fullProgress.bestDayName,
      todayIndex: fullProgress.todayIndex,
    ));
  }



  @override
  Future<void> close() {
    _taskSub.cancel();
    return super.close();
  }
}
