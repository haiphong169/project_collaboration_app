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
  Future<void> assignUserToTask(
    String projectUid,
    String taskListUid,
    String taskUid,
    String userUid,
  );
  Future<void> unassignUserFromTask(
    String projectUid,
    String taskListUid,
    String taskUid,
    String userUid,
  );

  Future<List<Task>> fetchUserInbox(String userUid);
  Future<void> addTodo(
    String projectUid,
    String taskListUid,
    String taskUid,
    Todo todo,
  );

  Future<void> removeTodo(
    String projectUid,
    String taskListUid,
    String taskUid,
    String todoUid,
  );

  Future<void> checkTodo(
    String projectUid,
    String taskListUid,
    String taskUid,
    String todoUid,
    bool newValue,
  );
}
