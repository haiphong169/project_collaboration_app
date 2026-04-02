import 'package:equatable/equatable.dart';

class TaskList extends Equatable {
  final String uid;
  final String projectUid;
  final String name;
  final Map<String, TaskHeader> taskHeaders;

  const TaskList({
    required this.uid,
    required this.projectUid,
    required this.name,
    required this.taskHeaders,
  });

  @override
  List<Object?> get props => [uid, projectUid, name, taskHeaders];
}

class TaskHeader extends Equatable {
  final String taskUid;
  final String name;
  final bool isCompleted;

  const TaskHeader({
    required this.taskUid,
    required this.name,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [taskUid, name, isCompleted];
}
