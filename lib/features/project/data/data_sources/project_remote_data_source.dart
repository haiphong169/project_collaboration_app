import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_collaboration_app/utils/firebase_path.dart';
import 'package:project_collaboration_app/features/project/data/models/project_model.dart';

class ProjectRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ProjectModel>> getProjectsStream(String userUid) {
    final projectStream = _db
        .collection(FirebasePath.projects)
        .where('members', arrayContains: userUid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ProjectModel.fromJson(doc.data(), doc.id);
          }).toList();
        });
    return projectStream;
  }

  Future<void> addProject(ProjectModel project) async {
    await _db
        .collection(FirebasePath.projects)
        .doc(project.uid)
        .set(project.toJson());
  }

  Future<void> deleteProject(String projectUid) async {
    await _db.collection(FirebasePath.projects).doc(projectUid).delete();
  }
}
