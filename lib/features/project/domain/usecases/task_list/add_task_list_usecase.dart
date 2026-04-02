import 'package:project_collaboration_app/features/project/domain/entities/task_list.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/task_list_repository.dart';
import 'package:uuid/uuid.dart';

class AddTaskListUseCase {
  final TaskListRepository _taskListRepository;

  const AddTaskListUseCase({required TaskListRepository taskListRepository})
    : _taskListRepository = taskListRepository;

  Future<void> call(String projectUid, String name) {
    final taskList = TaskList(
      uid: Uuid().v4(),
      projectUid: projectUid,
      name: name,
      taskHeaders: {},
    );
    return _taskListRepository.createTaskList(taskList);
  }
}
