import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String uid;
  final String taskListUid;
  final String projectUid;
  final String name;
  final bool isCompleted;
  final List<String> assignees;
  final String? description;
  final DateTime? dueDate;

  const Task({
    required this.uid,
    required this.taskListUid,
    required this.projectUid,
    required this.name,
    required this.isCompleted,
    required this.assignees,
    this.description,
    this.dueDate,
  });

  @override
  List<Object?> get props => [
    uid,
    taskListUid,
    projectUid,
    name,
    isCompleted,
    assignees,
    if (description != null) description,
    if (dueDate != null) dueDate,
  ];

  Task copyWith({
    String? uid,
    String? taskListUid,
    String? projectUid,
    String? name,
    bool? isCompleted,
    List<String>? assignees,
    String? description,
    DateTime? dueDate,
  }) {
    return Task(
      uid: uid ?? this.uid,
      taskListUid: taskListUid ?? this.taskListUid,
      projectUid: projectUid ?? this.projectUid,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      assignees: assignees ?? this.assignees,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
