import 'package:project_collaboration_app/features/project/domain/entities/task.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/task_repository.dart';

class GetTaskUseCase {
  final TaskRepository _taskRepository;

  const GetTaskUseCase({required TaskRepository taskRepository})
    : _taskRepository = taskRepository;

  Future<Task> call(String projectUid, String taskListUid, String taskUid) {
    return _taskRepository.getTask(projectUid, taskListUid, taskUid);
  }
}
