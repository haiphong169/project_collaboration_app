import 'package:project_collaboration_app/features/project/data/data_sources/project_remote_data_source.dart';
import 'package:project_collaboration_app/features/project/domain/entities/project.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/project_repository.dart';
import 'package:project_collaboration_app/utils/mapper_extension.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource _projectRemoteDataSource;

  ProjectRepositoryImpl({
    required ProjectRemoteDataSource projectRemoteDataSource,
  }) : _projectRemoteDataSource = projectRemoteDataSource;

  @override
  Stream<List<Project>> getProjectsStream(String userUid) async* {
    final modelStream = _projectRemoteDataSource.getProjectsStream(userUid);

    yield* modelStream.map(
      (modelList) => modelList.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<void> createProject(Project project) {
    return _projectRemoteDataSource.addProject(project.toModel());
  }

  @override
  Future<void> deleteProject(String projectUid) {
    return _projectRemoteDataSource.deleteProject(projectUid);
  }

  @override
  Future<void> updateProject(Project project) async {
    throw UnimplementedError();
  }

  @override
  Future<void> inviteUser({
    required String userUid,
    required String projectUid,
  }) {
    return _projectRemoteDataSource.inviteUser(
      userUid: userUid,
      projectUid: projectUid,
    );
  }

  @override
  Future<Project> getProjectById(String projectUid) async {
    final model = await _projectRemoteDataSource.getProjectById(projectUid);
    return model.toEntity();
  }

  @override
  Future<void> leaveProject({
    required String userUid,
    required String projectUid,
  }) {
    return _projectRemoteDataSource.leaveProject(
      userUid: userUid,
      projectUid: projectUid,
    );
  }
}
