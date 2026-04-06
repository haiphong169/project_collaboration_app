import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_collaboration_app/features/messaging/data/models/message_model.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/firebase_path.dart';
import 'package:project_collaboration_app/utils/result.dart';

class MessageRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<MessageModel>> conversationMessages(String conversationUid) {
    return _db
        .collection(FirebasePath.conversations)
        .doc(conversationUid)
        .collection(FirebasePath.messages)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return MessageModel.fromJson(doc.data(), doc.id, conversationUid);
          }).toList();
        });
  }

  Future<VoidResult> sendMessage(MessageModel message) async {
    try {
      await _db
          .collection(FirebasePath.conversations)
          .doc(message.conversationUid)
          .collection(FirebasePath.messages)
          .doc(message.uid)
          .set(message.toJson());
      return Result.ok(null);
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }

  Future<VoidResult> deleteMessage(
    String messageUid,
    String conversationUid,
  ) async {
    try {
      await _db
          .collection(FirebasePath.conversations)
          .doc(conversationUid)
          .collection(FirebasePath.messages)
          .doc(messageUid)
          .delete();
      return Result.ok(null);
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }
}
