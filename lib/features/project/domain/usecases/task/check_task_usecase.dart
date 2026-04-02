import 'package:project_collaboration_app/features/project/domain/repositories/task_list_repository.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/task_repository.dart';

class CheckTaskUseCase {
  final TaskRepository _taskRepository;
  final TaskListRepository _taskListRepository;

  const CheckTaskUseCase({
    required TaskRepository taskRepository,
    required TaskListRepository taskListRepository,
  }) : _taskRepository = taskRepository,
       _taskListRepository = taskListRepository;

  // Future<void> call(
  //   String projectUid,
  //   String taskListUid,
  //   String taskUid,
  //   bool newValue,
  // ) async {
  //   await _taskRepository.updateTaskFields(projectUid, taskListUid, taskUid, {
  //     'isCompleted': newValue,
  //   });
  //   final newHeaders =
  //   return _taskListRepository.updateTaskList(projectUid, taskListUid, newHeaders)
  // }
}
