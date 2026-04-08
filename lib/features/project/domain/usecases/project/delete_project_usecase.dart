import 'package:project_collaboration_app/features/project/domain/repositories/project_repository.dart';

class DeleteProjectUsecase {
  final ProjectRepository _projectRepository;

  DeleteProjectUsecase({required ProjectRepository projectRepository})
    : _projectRepository = projectRepository;

  Future<void> call(String projectUid) {
    return _projectRepository.deleteProject(projectUid);
  }
}
