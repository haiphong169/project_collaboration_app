import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/project/get_project_by_uid_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task/assign_user_to_task_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task/check_task_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task/delete_task_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task/get_task_usecase.dart';
import 'package:project_collaboration_app/features/project/presentation/ui_models/task_ui_model.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/get_users_by_uids_usecase.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class TaskCubit extends Cubit<UiState<TaskUiModel>> {
  TaskCubit({
    required GetTaskUseCase getTaskUseCase,
    required CheckTaskUseCase checkTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
    required AssignUserToTaskUsecase assignUserToTaskUseCase,
    required GetUsersByUidsUseCase getUsersByUidsUseCase,
    required SessionProvider sessionProvider,
    required GetProjectByUidUseCase getProjectByUidUsecase,
  }) : _getTaskUseCase = getTaskUseCase,
       _checkTaskUseCase = checkTaskUseCase,
       _deleteTaskUseCase = deleteTaskUseCase,
       _assignUserToTaskUsecase = assignUserToTaskUseCase,
       _getUsersByUidsUseCase = getUsersByUidsUseCase,
       _session = sessionProvider,
       _getProjectByUid = getProjectByUidUsecase,
       super(UiState.idle());

  final GetTaskUseCase _getTaskUseCase;
  final CheckTaskUseCase _checkTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final AssignUserToTaskUsecase _assignUserToTaskUsecase;
  final GetUsersByUidsUseCase _getUsersByUidsUseCase;
  final SessionProvider _session;
  final GetProjectByUidUseCase _getProjectByUid;

  Future<void> fetchTask(
    String projectUid,
    String taskListUid,
    String taskUid,
  ) async {
    emit(UiState.loading());
    try {
      final task = await _getTaskUseCase(projectUid, taskListUid, taskUid);
      final project = await _getProjectByUid(projectUid);
      final collaborators = await _getUsersByUidsUseCase(project.members);
      final assignees = await _getUsersByUidsUseCase(task.assignees);
      final userUid = _session.userUid!;
      final uiModel = TaskUiModel(
        task: task,
        assignees: assignees,
        collaborators: collaborators,
        isOwner: userUid == project.ownerUid,
        currentUser: _session.user!,
      );
      emit(UiState.success(uiModel));
    } on Exception catch (e) {
      emit(UiState.error(e.toString()));
    }
  }

  void checkTask(
    String projectUid,
    String taskListUid,
    String taskUid,
    bool newValue,
  ) async {
    if (state is! Success<TaskUiModel>) return;

    final previousState = state;
    final currentUiModel = (state as Success<TaskUiModel>).data;

    emit(
      UiState.success(
        currentUiModel.copyWith(
          task: currentUiModel.task.copyWith(isCompleted: newValue),
        ),
      ),
    );

    try {
      await _checkTaskUseCase(projectUid, taskListUid, taskUid, newValue);
    } on Exception catch (e) {
      emit(previousState);
      emit(UiState.error(e.toString()));
    }
  }

  void deleteTask(String projectUid, String taskListUid, String taskUid) async {
    emit(UiState.loading());
    try {
      await _deleteTaskUseCase(projectUid, taskListUid, taskUid);
      emit(UiState.onNavigationPop());
    } on Exception catch (e) {
      emit(UiState.error(e.toString()));
    }
  }

  void assignTaskToUser(
    String projectUid,
    String taskListUid,
    String taskUid,
    String userUid,
    bool isAssign,
  ) async {
    try {
      await _assignUserToTaskUsecase(
        projectUid,
        taskListUid,
        taskUid,
        userUid,
        isAssign,
      );
      // todo fix here
    } on Exception catch (e) {
      emit(UiState.error(e.toString()));
    }
  }

  void assignTaskToMyself(
    String projectUid,
    String taskListUid,
    String taskUid,
    bool isAssign,
  ) async {
    if (state is! Success<TaskUiModel>) return;
    final previousState = state as Success<TaskUiModel>;
    try {
      final userUid = _session.userUid!;
      await _assignUserToTaskUsecase(
        projectUid,
        taskListUid,
        taskUid,
        userUid,
        isAssign,
      );
      await fetchTask(projectUid, taskListUid, taskUid);
    } on Exception catch (e) {
      emit(UiState.error(e.toString()));
      emit(previousState);
    }
  }
}
