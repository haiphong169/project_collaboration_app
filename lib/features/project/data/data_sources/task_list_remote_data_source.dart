import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_collaboration_app/features/project/data/models/task_list_model.dart';
import 'package:project_collaboration_app/utils/firebase_path.dart';

class TaskListRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<TaskListModel>> getTaskListStream(String projectUid) {
    // todo add order by position
    final taskListStream = _db
        .collection(FirebasePath.projects)
        .doc(projectUid)
        .collection(FirebasePath.taskLists)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TaskListModel.fromJson(doc.data(), doc.id, projectUid);
          }).toList();
        });
    return taskListStream;
  }

  Future<void> createTaskList(TaskListModel taskList) {
    return _db
        .collection(FirebasePath.projects)
        .doc(taskList.projectUid)
        .collection(FirebasePath.taskLists)
        .doc(taskList.uid)
        .set(taskList.toJson());
  }

  Future<void> deleteTaskList(String taskListUid, String projectUid) {
    return _db
        .collection(FirebasePath.projects)
        .doc(projectUid)
        .collection(FirebasePath.taskLists)
        .doc(taskListUid)
        .delete();
  }

  Future<void> updateTaskListFields(
    String projectUid,
    String taskListUid,
    Map<String, dynamic> fields,
  ) {
    return _db
        .collection(FirebasePath.projects)
        .doc(projectUid)
        .collection(FirebasePath.taskLists)
        .doc(taskListUid)
        .update(fields);
  }
}
