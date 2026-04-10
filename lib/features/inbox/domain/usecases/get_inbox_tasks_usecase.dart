import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/task_repository.dart';

class GetInboxTasksUsecase {
  final TaskRepository _taskRepository;
  final SessionProvider _session;

  GetInboxTasksUsecase({
    required TaskRepository taskRepository,
    required SessionProvider sessionProvider,
  }) : _taskRepository = taskRepository,
       _session = sessionProvider;

  Future<List<Task>> call() {
    final userUid = _session.userUid!;
    return _taskRepository.fetchUserInbox(userUid);
  }
}
