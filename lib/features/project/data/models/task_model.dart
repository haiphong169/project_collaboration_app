import 'package:hive/hive.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task.dart';

part 'task_model.g.dart';

@HiveType(typeId: 6)
class TaskModel {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String taskListUid;
  @HiveField(2)
  final String projectUid;
  @HiveField(3)
  final String name;
  @HiveField(4)
  final bool isCompleted;
  @HiveField(5)
  final List<String> assignees;

  const TaskModel({
    required this.uid,
    required this.taskListUid,
    required this.projectUid,
    required this.name,
    required this.isCompleted,
    required this.assignees,
  });

  factory TaskModel.fromJson(
    Map<String, dynamic> map,
    String uid,
    String taskListUid,
    String projectUid,
  ) {
    return TaskModel(
      uid: uid,
      taskListUid: taskListUid,
      projectUid: projectUid,
      name: map['name'] as String,
      isCompleted: map['isCompleted'] as bool,
      assignees: List<String>.from(map['assignees'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'isCompleted': isCompleted, 'assignees': assignees};
  }

  Task toEntity() {
    return Task(
      uid: uid,
      taskListUid: taskListUid,
      projectUid: projectUid,
      name: name,
      isCompleted: isCompleted,
      assignees: assignees,
    );
  }
}
