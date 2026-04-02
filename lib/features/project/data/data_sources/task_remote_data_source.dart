import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_collaboration_app/features/project/data/models/task_model.dart';

class TaskRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _projectCollection = 'projects';
  static const String _taskListCollection = 'task_lists';
  static const String _taskCollection = 'tasks';

  Future<void> createTask(TaskModel task) {
    final batch = _db.batch();

    final taskListRef = _db
        .collection(_projectCollection)
        .doc(task.projectUid)
        .collection(_taskListCollection)
        .doc(task.taskListUid);

    final taskRef = taskListRef.collection(_taskCollection).doc(task.uid);

    batch.set(taskRef, task.toJson());
    batch.update(taskListRef, {
      'taskHeaders.${task.uid}': {
        'name': task.name,
        'isCompleted': task.isCompleted,
      },
    });

    return batch.commit();
  }

  Future<void> updateTask(
    String projectUid,
    String taskListUid,
    String taskUid,
    Map<String, dynamic> fields,
  ) {
    final batch = _db.batch();

    final taskListRef = _db
        .collection(_projectCollection)
        .doc(projectUid)
        .collection(_taskListCollection)
        .doc(taskListUid);

    final taskRef = taskListRef.collection(_taskCollection).doc(taskUid);

    batch.update(taskRef, fields);

    final headerFields = {
      if (fields.containsKey('name'))
        'taskHeaders.$taskUid.name': fields['name'],
      if (fields.containsKey('isCompleted'))
        'taskHeaders.$taskUid.isCompleted': fields['isCompleted'],
    };

    batch.update(taskListRef, headerFields);

    return batch.commit();
  }

  Future<TaskModel> getTask(
    String projectUid,
    String taskListUid,
    String taskUid,
  ) async {
    final docSnapshot =
        await _db
            .collection(_projectCollection)
            .doc(projectUid)
            .collection(_taskListCollection)
            .doc(taskListUid)
            .collection(_taskCollection)
            .doc(taskUid)
            .get();
    return TaskModel.fromJson(
      docSnapshot.data()!,
      taskUid,
      taskListUid,
      projectUid,
    );
  }
}
