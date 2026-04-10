import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/inbox/domain/usecases/get_inbox_tasks_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task/check_task_usecase.dart';
import 'package:project_collaboration_app/utils/logger.dart';
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
      AppLogger().d(tasks);
      emit(UiState.success(tasks));
    } on Exception catch (e) {
      AppLogger().e(e.toString());
      emit(UiState.error("Can't load inbox tasks"));
    }
  }

  void checkTask(bool newValue) async {}
}
