import 'package:project_collaboration_app/features/project/domain/repositories/task_repository.dart';

class AssignUserToTaskUsecase {
  final TaskRepository _taskRepository;

  AssignUserToTaskUsecase({required TaskRepository taskRepository})
    : _taskRepository = taskRepository;

  Future<void> call(
    String projectUid,
    String taskListUid,
    String taskUid,
    String userUid,
    bool isAssign,
  ) {
    if (isAssign) {
      return _taskRepository.assignUserToTask(
        projectUid,
        taskListUid,
        taskUid,
        userUid,
      );
    } else {
      return _taskRepository.unassignUserFromTask(
        projectUid,
        taskListUid,
        taskUid,
        userUid,
      );
    }
  }
}
