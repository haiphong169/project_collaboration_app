import 'package:project_collaboration_app/features/project/domain/entities/task.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/task_repository.dart';
import 'package:uuid/uuid.dart';

class AddTodoUseCase {
  final TaskRepository _taskRepository;

  const AddTodoUseCase({required TaskRepository taskRepository})
    : _taskRepository = taskRepository;

  Future<void> call(
    String projectUid,
    String taskListUid,
    String taskUid,
    Todo todo,
  ) {
    return _taskRepository.addTodo(projectUid, taskListUid, taskUid, todo);
  }

  Todo createTodo(String name) {
    return Todo(uid: Uuid().v4(), name: name, isCompleted: false);
  }
}
