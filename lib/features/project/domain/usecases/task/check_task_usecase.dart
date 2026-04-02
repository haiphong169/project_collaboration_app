import 'package:project_collaboration_app/features/project/domain/repositories/task_repository.dart';

class CheckTaskUseCase {
  final TaskRepository _taskRepository;

  const CheckTaskUseCase({required TaskRepository taskRepository})
    : _taskRepository = taskRepository;

  Future<void> call(
    String projectUid,
    String taskListUid,
    String taskUid,
    bool newValue,
  ) {
    return _taskRepository.updateTaskFields(projectUid, taskListUid, taskUid, {
      'isCompleted': newValue,
    });
  }
}
