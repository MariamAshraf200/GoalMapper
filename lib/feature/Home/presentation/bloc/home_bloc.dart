import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../../taskHome/presintation/bloc/taskBloc/bloc.dart';
import '../../../taskHome/presintation/bloc/taskBloc/state.dart' as taskState;
import 'package:mapperapp/feature/taskHome/domain/entity/taskEntity.dart';
import '../../../../core/util/date_format_util.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TaskBloc taskBloc;
  late final StreamSubscription _taskSub;

  HomeBloc({required this.taskBloc}) : super(HomeInitial()) {
    on<HomeStarted>(_onStarted);
    on<HomeTasksUpdated>(_onTasksUpdated);

    _taskSub = taskBloc.stream.listen((s) {
      if (s is taskState.TaskLoaded) {
        add(HomeTasksUpdated(s.tasks));
      }
    });

    // seed if taskBloc already has data
    final cur = taskBloc.state;
    if (cur is taskState.TaskLoaded) add(HomeTasksUpdated(cur.tasks));
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    final cur = taskBloc.state;
    if (cur is taskState.TaskLoaded) {
      _computeAndEmit(cur.tasks, emit, forceFullRecompute: true);
    } else {
      emit(HomeLoading());
    }
  }

  Future<void> _onTasksUpdated(HomeTasksUpdated event, Emitter<HomeState> emit) async {
    // If we already have a HomeLoaded state and the week window hasn't shifted,
    // update only the current day's value to avoid changing other days.
    _computeAndEmit(event.tasks, emit);
  }

  void _computeAndEmit(List<TaskDetails> allTasks, Emitter<HomeState> emit, {bool forceFullRecompute = false}) {
    final now = DateTime.now();
    final daysToSubtract = (now.weekday + 1) % 7; // Saturday -> 0
    final startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: daysToSubtract));
    final days = List.generate(7, (i) {
      final d = startOfWeek.add(Duration(days: i));
      return DateTime(d.year, d.month, d.day);
    });

    // If we have a previous HomeLoaded and the week window is identical and
    // caller didn't request a full recompute, then do an incremental update for today only.
    if (!forceFullRecompute && state is HomeLoaded) {
      final prev = state as HomeLoaded;
      if (listEquals(prev.days, days)) {
        // Clone previous progress map so we can mutate safely
        final dailyProgress = Map<DateTime, double>.from(prev.dailyProgress);

        // compute today's normalized date
        final todayDate = DateTime(now.year, now.month, now.day);

        final dayTasks = allTasks.where((t) {
          // If a task has an updatedTime (e.g., status changed), attribute it to that date;
          // otherwise fall back to the original task.date.
          final source = (t.updatedTime != null && t.updatedTime!.trim().isNotEmpty) ? t.updatedTime! : t.date;
          final parsed = DateFormatUtil.tryParseFlexible(source) ?? DateFormatUtil.parseDate(source);
          final normalized = DateTime(parsed.year, parsed.month, parsed.day);
          return normalized.isAtSameMomentAs(todayDate);
        }).toList();

        final newProgress = dayTasks.isEmpty ? 0.0 : (dayTasks.where((t) => t.status.toLowerCase().trim() == 'done').length / dayTasks.length);
        dailyProgress[todayDate] = newProgress;

        final avg = dailyProgress.values.isEmpty ? 0.0 : (dailyProgress.values.reduce((a, b) => a + b) / dailyProgress.length);

        final bestEntry = dailyProgress.isNotEmpty ? dailyProgress.entries.reduce((a, b) => a.value > b.value ? a : b) : null;
        final bestDayName = bestEntry != null ? DateFormat('EEEE').format(bestEntry.key) : '';

        final todayIndex = days.indexWhere((d) => d.year == todayDate.year && d.month == todayDate.month && d.day == todayDate.day);

        emit(HomeLoaded(
          days: days,
          dailyProgress: dailyProgress,
          avgProgress: avg,
          bestDayName: bestDayName,
          todayIndex: todayIndex,
        ));
        return;
      }
    }

    // Full recompute path (initial load or week window changed)
    final dailyProgress = <DateTime, double>{};
    for (final day in days) {
      final dayTasks = allTasks.where((t) {
        final source = (t.updatedTime != null && t.updatedTime!.trim().isNotEmpty) ? t.updatedTime! : t.date;
        final parsed = DateFormatUtil.tryParseFlexible(source) ?? DateFormatUtil.parseDate(source);
        final normalized = DateTime(parsed.year, parsed.month, parsed.day);
        return normalized.isAtSameMomentAs(day);
      }).toList();

      dailyProgress[day] = dayTasks.isEmpty ? 0.0 : (dayTasks.where((t) => t.status.toLowerCase().trim() == 'done').length / dayTasks.length);
    }

    final avg = dailyProgress.values.isEmpty ? 0.0 : (dailyProgress.values.reduce((a, b) => a + b) / dailyProgress.length);
    final bestEntry = dailyProgress.isNotEmpty ? dailyProgress.entries.reduce((a, b) => a.value > b.value ? a : b) : null;
    final bestDayName = bestEntry != null ? DateFormat('EEEE').format(bestEntry.key) : '';
    final todayIndex = days.indexWhere((d) => d.year == now.year && d.month == now.month && d.day == now.day);

    emit(HomeLoaded(
      days: days,
      dailyProgress: dailyProgress,
      avgProgress: avg,
      bestDayName: bestDayName,
      todayIndex: todayIndex,
    ));
  }

  @override
  Future<void> close() {
    _taskSub.cancel();
    return super.close();
  }
}
