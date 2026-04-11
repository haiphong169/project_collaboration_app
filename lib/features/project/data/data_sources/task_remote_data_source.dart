import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
    final inboxRef = _db
        .collection(FirebasePath.users)
        .doc(userUid)
        .collection(FirebasePath.inbox);
    final inboxSnapshots = await inboxRef.get();

    final tasks = <TaskModel>[];
    for (final inboxDoc in inboxSnapshots.docs) {
      final inboxData = inboxDoc.data();
      final String projectUid = inboxData['projectUid'];
      final String taskListUid = inboxData['taskListUid'];
      final String taskUid = inboxData['taskUid'];

      final projectRef = _db.collection(FirebasePath.projects).doc(projectUid);
      final projectSnapshot = await projectRef.get();

      if (!projectSnapshot.exists) {
        await inboxRef.doc(inboxDoc.id).delete();
        continue;
      }

      final taskListRef = projectRef
          .collection(FirebasePath.taskLists)
          .doc(taskListUid);
      final taskListSnapshot = await taskListRef.get();

      if (!taskListSnapshot.exists) {
        await inboxRef.doc(inboxDoc.id).delete();
        continue;
      }

      final taskRef = taskListRef.collection(FirebasePath.tasks).doc(taskUid);
      final taskSnapshot = await taskRef.get();

      if (!taskSnapshot.exists) {
        await inboxRef.doc(inboxDoc.id).delete();
        continue;
      }

      tasks.add(
        TaskModel.fromJson(
          taskSnapshot.data()!,
          taskUid,
          taskListUid,
          projectUid,
        ),
      );
    }

    return tasks;
  }

  Future<void> addTodo(
    String projectUid,
    String taskListUid,
    String taskUid,
    TodoModel todo,
  ) {
    return _db
        .collection(FirebasePath.projects)
        .doc(projectUid)
        .collection(FirebasePath.taskLists)
        .doc(taskListUid)
        .collection(FirebasePath.tasks)
        .doc(taskUid)
        .update({
          'todos': FieldValue.arrayUnion([todo.toJson()]),
        });
  }

  Future<void> removeTodo(
    String projectUid,
    String taskListUid,
    String taskUid,
    String todoUid,
  ) async {
    final taskRef = _db
        .collection(FirebasePath.projects)
        .doc(projectUid)
        .collection(FirebasePath.taskLists)
        .doc(taskListUid)
        .collection(FirebasePath.tasks)
        .doc(taskUid);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(taskRef);

      if (!snapshot.exists) return;
      final data = snapshot.data();
      if (data == null || !data.containsKey('todos')) return;

      final todos = List<Map<String, dynamic>>.from(
        (data['todos'] as List<dynamic>).map(
          (e) => Map<String, dynamic>.from(e as Map),
        ),
      );

      todos.removeWhere((t) => t['uid'] == todoUid);

      transaction.update(taskRef, {'todos': todos});
    });
  }

  Future<void> checkTodo(
    String projectUid,
    String taskListUid,
    String taskUid,
    String todoUid,
    bool newValue,
  ) async {
    final taskRef = _db
        .collection(FirebasePath.projects)
        .doc(projectUid)
        .collection(FirebasePath.taskLists)
        .doc(taskListUid)
        .collection(FirebasePath.tasks)
        .doc(taskUid);
    final taskSnapshot = await taskRef.get();

    if (!taskSnapshot.exists) return;

    final data = taskSnapshot.data();
    if (data == null || !data.containsKey('todos')) return;

    final todos =
        (data['todos'] as List<dynamic>)
            .map((json) => TodoModel.fromJson(json))
            .toList();
    final targetIndex = todos.indexWhere((todo) => todo.uid == todoUid);
    todos[targetIndex] = TodoModel(
      uid: todoUid,
      name: todos[targetIndex].name,
      isCompleted: newValue,
    );

    return taskRef.update({
      'todos': todos.map((todo) => todo.toJson()).toList(),
    });
  }
}
