import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/project/domain/entities/project.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/project_repository.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:uuid/uuid.dart';

class AddProjectUseCase {
  final ProjectRepository _projectRepository;
  final SessionProvider _session;

  AddProjectUseCase({
    required ProjectRepository projectRepository,
    required SessionProvider sessionProvider,
  }) : _projectRepository = projectRepository,
       _session = sessionProvider;

  Future<void> call(String name, int backgroundColorValue) {
    final userUid = _session.userUid;
    if (userUid == null) throw UserNotFoundException();

    final project = Project(
      uid: const Uuid().v4(),
      name: name,
      backgroundColorValue: backgroundColorValue,
      members: [userUid],
      ownerUid: userUid,
    );

    return _projectRepository.createProject(project);
  }
}
