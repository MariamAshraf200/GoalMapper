import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/task_usecase/filter_usecase.dart';
import 'main_event.dart';
import 'main_state.dart';
import '../../../taskHome/domain/entity/taskEntity.dart';
 import '../../../taskHome/domain/entity/task_filters.dart';
class MainTaskBloc extends Bloc<MainTaskEvent, MainState> {
  final FilterMainTasksUseCase filterTasksUseCase;

  MainTaskBloc({required this.filterTasksUseCase}) : super(MainInitial()) {
    on<GetMainTasksEvent>(_onGetMainTasks);
  }

  Future<void> _onGetMainTasks(
      GetMainTasksEvent event,
      Emitter<MainState> emit,
      ) async {
    emit(MainTaskLoading());
    try {
      final currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      final filters = TaskFilters(date: currentDate, priority: null, status: null);
      final List<TaskDetails> tasks = await filterTasksUseCase(filters);
      emit(MainTaskLoaded(tasks));
    } catch (e) {
      emit(MainTaskError("Failed to load tasks: $e"));
    }
  }
}
