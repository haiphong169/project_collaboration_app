import 'package:project_collaboration_app/features/project/domain/entities/project.dart';

abstract class ProjectRepository {
  Stream<List<Project>> getProjectsStream(String userUid);
  Future<void> createProject(Project project);
  Future<void> updateProject(Project project);
  Future<void> deleteProject(String projectUid);
  Future<void> inviteUser({
    required String userUid,
    required String projectUid,
  });
  Future<Project> getProjectById(String projectUid);
  Future<void> leaveProject({
    required String userUid,
    required String projectUid,
  });
}
