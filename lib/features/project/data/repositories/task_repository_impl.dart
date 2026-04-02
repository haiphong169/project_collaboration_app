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
    // TODO: implement deleteTask
    throw UnimplementedError();
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
}
