import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/inbox/domain/usecases/get_inbox_tasks_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task/check_task_usecase.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class InboxCubit extends Cubit<UiState<List<Task>>> {
  InboxCubit({
    required GetInboxTasksUsecase getInboxTasksUsecase,
    required CheckTaskUseCase checkTaskUsecase,
  }) : _getInboxTasks = getInboxTasksUsecase,
       _checkTask = checkTaskUsecase,
       super(UiState.idle());

  final GetInboxTasksUsecase _getInboxTasks;
  final CheckTaskUseCase _checkTask;

  void fetchInboxTasks() async {
    try {
      emit(UiState.loading());
      final tasks = await _getInboxTasks();
      emit(UiState.success(tasks));
    } on Exception {
      emit(UiState.error("Can't load inbox tasks"));
    }
  }

  void checkTask(
    String projectUid,
    String taskListUid,
    String taskUid,
    bool newValue,
  ) async {
    final previousData = state.getData();
    if (previousData == null) return;

    try {
      final newList = [...previousData];
      final index = newList.indexWhere((task) => task.uid == taskUid);

      if (index == -1) return;

      newList[index] = newList[index].copyWith(isCompleted: newValue);
      emit(UiState.success(newList));
      await _checkTask(projectUid, taskListUid, taskUid, newValue);
    } on Exception catch (e) {
      emit(UiState.error(e.toString(), previousData));
    }
  }
}
