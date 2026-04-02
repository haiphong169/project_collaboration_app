import 'package:project_collaboration_app/features/project/domain/entities/task.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/task_repository.dart';
import 'package:uuid/uuid.dart';

class AddTaskUseCase {
  final TaskRepository _taskRepository;

  const AddTaskUseCase({required TaskRepository taskRepository})
    : _taskRepository = taskRepository;

  Future<void> call(String projectUid, String taskListUid, String name) async {
    final newTask = Task(
      uid: Uuid().v4(),
      taskListUid: taskListUid,
      projectUid: projectUid,
      name: name,
      isCompleted: false,
    );

    return _taskRepository.createTask(newTask);
  }
}
