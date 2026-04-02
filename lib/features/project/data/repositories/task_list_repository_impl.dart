import 'package:project_collaboration_app/features/project/data/data_sources/task_list_remote_data_source.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task_list.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/task_list_repository.dart';
import 'package:project_collaboration_app/utils/mapper_extension.dart';

class TaskListRepositoryImpl implements TaskListRepository {
  final TaskListRemoteDataSource _taskListRemoteDataSource;

  TaskListRepositoryImpl({
    required TaskListRemoteDataSource taskListRemoteDataSource,
  }) : _taskListRemoteDataSource = taskListRemoteDataSource;

  @override
  Future<void> createTaskList(TaskList taskList) {
    return _taskListRemoteDataSource.createTaskList(taskList.toModel());
  }

  @override
  Future<void> deleteTaskList(String taskListUid, String projectUid) {
    return _taskListRemoteDataSource.deleteTaskList(taskListUid, projectUid);
  }

  @override
  Stream<List<TaskList>> getTaskLists(String projectUid) async* {
    final modelStream = _taskListRemoteDataSource.getTaskListStream(projectUid);

    yield* modelStream.map(
      (modelList) => modelList.map((model) => model.toEntity()).toList(),
    );
  }
}
