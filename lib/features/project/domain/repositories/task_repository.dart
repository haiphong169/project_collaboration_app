import 'package:project_collaboration_app/features/project/domain/entities/task.dart';

abstract class TaskRepository {
  Future<Task> getTask(String projectUid, String taskListUid, String taskUid);
  Future<void> createTask(Task task);
  Future<void> updateTaskFields(
    String projectUid,
    String taskListUid,
    String taskUid,
    Map<String, dynamic> fields,
  );
  Future<void> deleteTask(String projectUid, String taskListUid, String uid);
}
