import 'package:project_collaboration_app/features/project/domain/entities/task_list.dart';

abstract class TaskListRepository {
  Stream<List<TaskList>> getTaskLists(String projectUid);
  Future<void> createTaskList(TaskList taskList);
  Future<void> deleteTaskList(String taskListUid, String projectUid);
}
