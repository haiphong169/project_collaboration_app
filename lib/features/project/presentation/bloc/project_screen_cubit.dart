import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task_list.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task/add_task_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task/check_task_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task_list/add_task_list_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task_list/delete_task_list_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task_list/get_task_lists_usecase.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class ProjectScreenCubit extends Cubit<UiState<List<TaskList>>> {
  ProjectScreenCubit({
    required GetTaskListsUseCase getTaskListUseCase,
    required AddTaskListUseCase addTaskListUseCase,
    required DeleteTaskListUseCase deleteTaskListUseCase,
    required AddTaskUseCase addTaskUseCase,
    required CheckTaskUseCase checkTaskUseCase,
    required this.projectUid,
  }) : _getTaskList = getTaskListUseCase,
       _addTaskList = addTaskListUseCase,
       _deleteTaskList = deleteTaskListUseCase,
       _addTask = addTaskUseCase,
       _checkTask = checkTaskUseCase,
       super(UiState.idle());

  final GetTaskListsUseCase _getTaskList;
  final AddTaskListUseCase _addTaskList;
  final DeleteTaskListUseCase _deleteTaskList;
  final AddTaskUseCase _addTask;
  final CheckTaskUseCase _checkTask;
  StreamSubscription? _taskListSubscription;
  final String projectUid;

  void fetchTaskLists() async {
    emit(UiState.loading());
    try {
      final taskListsStream = _getTaskList(projectUid);
      _taskListSubscription?.cancel();
      _taskListSubscription = taskListsStream.listen(
        (taskLists) => emit(UiState.success(taskLists)),
        onError: (e) => emit(UiState.error(e.toString())),
      );
    } on Exception catch (e) {
      emit(UiState.error(e.toString()));
    }
  }

  void addTaskList(String name) {
    try {
      _addTaskList(projectUid, name);
    } on Exception catch (e) {
      emit(UiState.error(e.toString()));
    }
  }

  void deleteTaskList(String taskListUid) {
    try {
      _deleteTaskList(taskListUid, projectUid);
    } on Exception catch (e) {
      emit(UiState.error(e.toString()));
    }
  }

  void addTask(String taskListUid, String name) {
    try {
      _addTask(projectUid, taskListUid, name);
    } on Exception catch (e) {
      emit(UiState.error(e.toString()));
    }
  }

  void checkTask(String taskListUid, String taskUid, bool newValue) {
    try {
      _checkTask(projectUid, taskListUid, taskUid, newValue);
    } on Exception catch (e) {
      emit(UiState.error(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _taskListSubscription?.cancel();
    return super.close();
  }
}
