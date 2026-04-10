import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_collaboration_app/features/project/data/models/task_model.dart';
import 'package:project_collaboration_app/utils/firebase_path.dart';

class TaskRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createTask(TaskModel task) {
    final batch = _db.batch();

    final taskListRef = _db
        .collection(FirebasePath.projects)
        .doc(task.projectUid)
        .collection(FirebasePath.taskLists)
        .doc(task.taskListUid);

    final taskRef = taskListRef.collection(FirebasePath.tasks).doc(task.uid);

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
        .collection(FirebasePath.projects)
        .doc(projectUid)
        .collection(FirebasePath.taskLists)
        .doc(taskListUid);

    final taskRef = taskListRef.collection(FirebasePath.tasks).doc(taskUid);

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
            .collection(FirebasePath.projects)
            .doc(projectUid)
            .collection(FirebasePath.taskLists)
            .doc(taskListUid)
            .collection(FirebasePath.tasks)
            .doc(taskUid)
            .get();
    return TaskModel.fromJson(
      docSnapshot.data()!,
      taskUid,
      taskListUid,
      projectUid,
    );
  }

  Future<void> deleteTask(
    String projectUid,
    String taskListUid,
    String taskUid,
  ) async {
    final batch = _db.batch();

    final taskListRef = _db
        .collection(FirebasePath.projects)
        .doc(projectUid)
        .collection(FirebasePath.taskLists)
        .doc(taskListUid);

    final taskRef = taskListRef.collection(FirebasePath.tasks).doc(taskUid);

    batch.delete(taskRef);
    batch.update(taskListRef, {'taskHeaders.$taskUid': FieldValue.delete()});

    return batch.commit();
  }

  Future<void> assignUserToTask(
    String projectUid,
    String taskListUid,
    String taskUid,
    String userUid,
  ) {
    final batch = _db.batch();

    final taskRef = _db
        .collection(FirebasePath.projects)
        .doc(projectUid)
        .collection(FirebasePath.taskLists)
        .doc(taskListUid)
        .collection(FirebasePath.tasks)
        .doc(taskUid);

    batch.update(taskRef, {
      'assignees': FieldValue.arrayUnion([userUid]),
    });

    final userInboxRef =
        _db
            .collection(FirebasePath.users)
            .doc(userUid)
            .collection(FirebasePath.inbox)
            .doc();

    batch.set(userInboxRef, {
      'projectUid': projectUid,
      'taskListUid': taskListUid,
      'taskUid': taskUid,
    });

    return batch.commit();
  }

  Future<void> unassignUserFromTask(
    String projectUid,
    String taskListUid,
    String taskUid,
    String userUid,
  ) async {
    final batch = _db.batch();

    final taskRef = _db
        .collection(FirebasePath.projects)
        .doc(projectUid)
        .collection(FirebasePath.taskLists)
        .doc(taskListUid)
        .collection(FirebasePath.tasks)
        .doc(taskUid);

    batch.update(taskRef, {
      'assignees': FieldValue.arrayRemove([userUid]),
    });

    final userInboxQuery = _db
        .collection(FirebasePath.users)
        .doc(userUid)
        .collection(FirebasePath.inbox)
        .where('taskUid', isEqualTo: taskUid);

    final snapshot = await userInboxQuery.get();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    return batch.commit();
  }

  Future<List<TaskModel>> fetchUserInbox(String userUid) async {
    final inboxSnapshots =
        await _db
            .collection(FirebasePath.users)
            .doc(userUid)
            .collection(FirebasePath.inbox)
            .get();

    final tasks = await Future.wait(
      inboxSnapshots.docs.map((inboxDoc) async {
        final inboxData = inboxDoc.data();
        final String projectUid = inboxData['projectUid'];
        final String taskListUid = inboxData['taskListUid'];
        final String taskUid = inboxData['taskUid'];

        final taskSnapshot =
            await _db
                .collection(FirebasePath.projects)
                .doc(projectUid)
                .collection(FirebasePath.taskLists)
                .doc(taskListUid)
                .collection(FirebasePath.tasks)
                .doc(taskUid)
                .get();

        return TaskModel.fromJson(
          taskSnapshot.data()!,
          taskUid,
          taskListUid,
          projectUid,
        );
      }),
    );

    return tasks;
  }
}
