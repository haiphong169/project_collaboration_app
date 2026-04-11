import 'package:project_collaboration_app/features/project/domain/repositories/task_repository.dart';

class CheckTodoUsecase {
  final TaskRepository _taskRepository;

  CheckTodoUsecase({required TaskRepository taskRepository})
    : _taskRepository = taskRepository;

  Future<void> call(
    String projectUid,
    String taskListUid,
    String taskUid,
    String todoUid,
    bool newValue,
  ) {
    return _taskRepository.checkTodo(
      projectUid,
      taskListUid,
      taskUid,
      todoUid,
      newValue,
    );
  }
}
