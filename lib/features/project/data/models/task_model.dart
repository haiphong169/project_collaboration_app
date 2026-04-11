import 'package:cloud_firestore/cloud_firestore.dart';
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
  @HiveField(6)
  final String? description;
  @HiveField(7)
  final DateTime? dueDate;
  @HiveField(8)
  final List<TodoModel> todos;

  const TaskModel({
    required this.uid,
    required this.taskListUid,
    required this.projectUid,
    required this.name,
    required this.isCompleted,
    required this.assignees,
    this.description,
    this.dueDate,
    required this.todos,
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
      description: map['description'] as String?,
      dueDate: (map['dueDate'] as Timestamp?)?.toDate(),
      todos:
          List<Map<String, dynamic>>.from(
            map['todos'] as List<dynamic>,
          ).map((m) => TodoModel.fromJson(m)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isCompleted': isCompleted,
      'assignees': assignees,
      'description': description,
      if (dueDate != null) 'dueDate': Timestamp.fromDate(dueDate!),
      'todos': todos.map((t) => t.toJson()).toList(),
    };
  }

  Task toEntity() {
    return Task(
      uid: uid,
      taskListUid: taskListUid,
      projectUid: projectUid,
      name: name,
      isCompleted: isCompleted,
      assignees: assignees,
      description: description,
      dueDate: dueDate,
      todos: todos.map((t) => t.toEntity()).toList(),
    );
  }
}

@HiveType(typeId: 8)
class TodoModel {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final bool isCompleted;

  const TodoModel({
    required this.uid,
    required this.name,
    required this.isCompleted,
  });

  factory TodoModel.fromJson(Map<String, dynamic> map) {
    return TodoModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'isCompleted': isCompleted};
  }

  Todo toEntity() {
    return Todo(uid: uid, name: name, isCompleted: isCompleted);
  }
}
