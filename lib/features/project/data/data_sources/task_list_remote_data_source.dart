import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_collaboration_app/features/project/data/models/task_list_model.dart';

class TaskListRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _projectCollection = 'projects';
  static const String _taskListCollection = 'task_lists';

  Stream<List<TaskListModel>> getTaskListStream(String projectUid) {
    // todo add order by position
    final taskListStream = _db
        .collection(_projectCollection)
        .doc(projectUid)
        .collection(_taskListCollection)
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
        .collection(_projectCollection)
        .doc(taskList.projectUid)
        .collection(_taskListCollection)
        .doc(taskList.uid)
        .set(taskList.toJson());
  }

  Future<void> deleteTaskList(String taskListUid, String projectUid) {
    return _db
        .collection(_projectCollection)
        .doc(projectUid)
        .collection(_taskListCollection)
        .doc(taskListUid)
        .delete();
  }

  Future<void> updateTaskListFields(
    String projectUid,
    String taskListUid,
    Map<String, dynamic> fields,
  ) {
    return _db
        .collection(_projectCollection)
        .doc(projectUid)
        .collection(_taskListCollection)
        .doc(taskListUid)
        .update(fields);
  }
}
