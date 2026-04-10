import 'package:project_collaboration_app/features/project/domain/entities/task.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';

class TaskUiModel {
  final Task task;
  final List<User> assignees;
  final List<User> collaborators;
  final bool isOwner;
  final User currentUser;

  TaskUiModel({
    required this.task,
    required this.assignees,
    required this.collaborators,
    required this.isOwner,
    required this.currentUser,
  });

  TaskUiModel copyWith({
    Task? task,
    List<User>? assignees,
    List<User>? collaborators,
    bool? isOwner,
    User? currentUser,
  }) => TaskUiModel(
    task: task ?? this.task,
    assignees: assignees ?? this.assignees,
    collaborators: collaborators ?? this.collaborators,
    isOwner: isOwner ?? this.isOwner,
    currentUser: currentUser ?? this.currentUser,
  );
}
