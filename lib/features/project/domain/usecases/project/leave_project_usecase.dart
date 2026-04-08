import 'package:project_collaboration_app/features/project/domain/repositories/project_repository.dart';

class LeaveProjectUseCase {
  final ProjectRepository repository;

  LeaveProjectUseCase(this.repository);

  Future<void> call({required String userUid, required String projectUid}) {
    return repository.leaveProject(userUid: userUid, projectUid: projectUid);
  }
}
