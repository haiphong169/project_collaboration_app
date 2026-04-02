import 'package:hive/hive.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task_list.dart';
import 'package:project_collaboration_app/utils/logger.dart';

part 'task_list_model.g.dart';

@HiveType(typeId: 5)
class TaskListModel {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String projectUid;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final Map<String, TaskHeaderModel> taskHeaders;

  const TaskListModel({
    required this.uid,
    required this.projectUid,
    required this.name,
    required this.taskHeaders,
  });

  factory TaskListModel.fromJson(
    Map<String, dynamic> map,
    String uid,
    String projectUid,
  ) {
    return TaskListModel(
      uid: uid,
      projectUid: projectUid,
      name: map['name'] as String,
      taskHeaders: (map['taskHeaders'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          TaskHeaderModel.fromJson(value as Map<String, dynamic>),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'taskHeaders': taskHeaders.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
    };
  }

  TaskList toEntity() {
    return TaskList(
      uid: uid,
      projectUid: projectUid,
      name: name,
      taskHeaders: taskHeaders.map(
        (key, value) => MapEntry(key, value.toEntity()),
      ),
    );
  }
}

@HiveType(typeId: 7)
class TaskHeaderModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final bool isCompleted;

  const TaskHeaderModel({required this.name, required this.isCompleted});

  factory TaskHeaderModel.fromJson(Map<String, dynamic> map) {
    return TaskHeaderModel(
      name: map['name'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'isCompleted': isCompleted};
  }

  TaskHeader toEntity() {
    return TaskHeader(name: name, isCompleted: isCompleted);
  }
}
