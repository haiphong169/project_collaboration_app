import 'package:project_collaboration_app/features/project/data/data_sources/task_remote_data_source.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/task_repository.dart';
import 'package:project_collaboration_app/utils/mapper_extension.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _taskRemoteDataSource;

  TaskRepositoryImpl({required TaskRemoteDataSource taskRemoteDataSource})
    : _taskRemoteDataSource = taskRemoteDataSource;

  @override
  Future<void> createTask(Task task) {
    return _taskRemoteDataSource.createTask(task.toModel());
  }

  @override
  Future<void> deleteTask(String projectUid, String taskListUid, String uid) {
    return _taskRemoteDataSource.deleteTask(projectUid, taskListUid, uid);
  }

  @override
  Future<Task> getTask(
    String projectUid,
    String taskListUid,
    String taskUid,
  ) async {
    final model = await _taskRemoteDataSource.getTask(
      projectUid,
      taskListUid,
      taskUid,
    );
    return model.toEntity();
  }

  @override
  Future<void> updateTaskFields(
    String projectUid,
    String taskListUid,
    String taskUid,
    Map<String, dynamic> fields,
  ) {
    return _taskRemoteDataSource.updateTask(
      projectUid,
      taskListUid,
      taskUid,
      fields,
    );
  }

  @override
  Future<void> assignUserToTask(
    String projectUid,
    String taskListUid,
    String taskUid,
    String userUid,
  ) {
    return _taskRemoteDataSource.assignUserToTask(
      projectUid,
      taskListUid,
      taskUid,
      userUid,
    );
  }

  @override
  Future<void> unassignUserFromTask(
    String projectUid,
    String taskListUid,
    String taskUid,
    String userUid,
  ) {
    return _taskRemoteDataSource.unassignUserFromTask(
      projectUid,
      taskListUid,
      taskUid,
      userUid,
    );
  }

  @override
  Future<List<Task>> fetchUserInbox(String userUid) async {
    final modelList = await _taskRemoteDataSource.fetchUserInbox(userUid);
    return modelList.map((model) => model.toEntity()).toList();
  }
}
