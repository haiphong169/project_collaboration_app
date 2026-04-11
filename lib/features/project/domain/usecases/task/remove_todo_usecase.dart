import 'package:project_collaboration_app/features/project/domain/repositories/task_repository.dart';

class RemoveTodoUseCase {
  final TaskRepository _taskRepository;

  const RemoveTodoUseCase({required TaskRepository taskRepository})
    : _taskRepository = taskRepository;

  Future<void> call(
    String projectUid,
    String taskListUid,
    String taskUid,
    String todoUid,
  ) {
    return _taskRepository.removeTodo(
      projectUid,
      taskListUid,
      taskUid,
      todoUid,
    );
  }
}
