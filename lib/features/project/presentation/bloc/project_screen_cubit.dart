import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task_list.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/project/delete_project_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/project/leave_project_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task/add_task_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task/check_task_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task_list/add_task_list_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task_list/archive_task_list_usecase.dart';
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
    required ArchiveTaskListUseCase archiveTaskListUseCase,
    required DeleteProjectUsecase deleteProjectUsecase,
    required LeaveProjectUseCase leaveProjectUsecase,
    required SessionProvider sessionProvider,
    required this.projectUid,
    required this.ownerUid,
  }) : _getTaskList = getTaskListUseCase,
       _addTaskList = addTaskListUseCase,
       _deleteTaskList = deleteTaskListUseCase,
       _addTask = addTaskUseCase,
       _checkTask = checkTaskUseCase,
       _archiveTaskList = archiveTaskListUseCase,
       _deleteProject = deleteProjectUsecase,
       _leaveProject = leaveProjectUsecase,
       _session = sessionProvider,
       super(UiState.idle());

  final GetTaskListsUseCase _getTaskList;
  final AddTaskListUseCase _addTaskList;
  final DeleteTaskListUseCase _deleteTaskList;
  final AddTaskUseCase _addTask;
  final CheckTaskUseCase _checkTask;
  final ArchiveTaskListUseCase _archiveTaskList;
  final DeleteProjectUsecase _deleteProject;
  final LeaveProjectUseCase _leaveProject;
  final SessionProvider _session;
  StreamSubscription? _taskListSubscription;
  final String projectUid;
  final String ownerUid;
  late final bool isOwner;

  void fetchTaskLists() async {
    emit(UiState.loading());
    try {
      _fetchOwnership();
      final taskListsStream = _getTaskList(projectUid);
      _taskListSubscription?.cancel();
      _taskListSubscription = taskListsStream.listen(
        (taskLists) => emit(
          UiState.success(
            taskLists.where((taskList) => !taskList.isArchived).toList(),
          ),
        ),
        onError: (e) {
          emit(UiState.error(e.toString()));
        },
      );
    } on Exception catch (e) {
      emit(UiState.error(e.toString()));
    }
  }

  void _fetchOwnership() {
    final currentUserUid = _session.userUid;
    isOwner = currentUserUid == ownerUid;
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
      _deleteTaskList(projectUid, taskListUid);
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

  void archiveTaskList(String taskListUid) {
    try {
      _archiveTaskList(projectUid, taskListUid, true);
    } on Exception catch (e) {
      emit(UiState.error(e.toString()));
    }
  }

  void deleteProject() async {
    try {
      await _taskListSubscription?.cancel();
      _taskListSubscription = null;
      await _deleteProject(projectUid);
      emit(UiState.onNavigationPop());
    } on Exception catch (e) {
      emit(UiState.error(e.toString()));
    }
  }

  void leaveProject() async {
    try {
      await _taskListSubscription?.cancel();
      _taskListSubscription = null;
      await _leaveProject(userUid: _session.userUid!, projectUid: projectUid);
      emit(UiState.onNavigationPop());
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
