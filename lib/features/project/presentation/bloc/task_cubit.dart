import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task/check_task_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task/get_task_usecase.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class TaskCubit extends Cubit<UiState<Task>> {
  TaskCubit({
    required GetTaskUseCase getTaskUseCase,
    required CheckTaskUseCase checkTaskUseCase,
    required this.projectUid,
    required this.taskListUid,
    required this.taskUid,
  }) : _getTaskUseCase = getTaskUseCase,
       _checkTaskUseCase = checkTaskUseCase,
       super(UiState.idle());

  final GetTaskUseCase _getTaskUseCase;
  final CheckTaskUseCase _checkTaskUseCase;
  final String projectUid;
  final String taskListUid;
  final String taskUid;

  Future<void> fetchTask() async {
    emit(UiState.loading());
    try {
      final task = await _getTaskUseCase(projectUid, taskListUid, taskUid);
      emit(UiState.success(task));
    } on Exception catch (e) {
      emit(UiState.error(e.toString()));
    }
  }

  void checkTask(bool newValue) async {
    if (state is! Success<Task>) return;

    final previousState = state;
    final currentTask = (state as Success<Task>).data;

    emit(UiState.success(currentTask.copyWith(isCompleted: newValue)));

    try {
      await _checkTaskUseCase(projectUid, taskListUid, taskUid, newValue);
    } on Exception catch (e) {
      emit(previousState);
      emit(UiState.error(e.toString()));
    }
  }
}
