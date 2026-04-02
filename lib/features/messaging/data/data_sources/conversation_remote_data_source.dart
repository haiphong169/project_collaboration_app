import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_collaboration_app/features/messaging/data/models/conversation_model.dart';
import 'package:project_collaboration_app/features/messaging/data/models/message_model.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/firebase_path.dart';
import 'package:project_collaboration_app/utils/result.dart';

class ConversationRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Result<Stream<List<ConversationModel>>>> getConversations(
    String userUid,
  ) async {
    try {
      final conversationStream = _db
          .collection(FirebasePath.conversations)
          .where('participants', arrayContains: userUid)
          .orderBy('lastMessageAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return ConversationModel.fromJson(doc.data(), doc.id);
            }).toList();
          });
      return Result.ok(conversationStream);
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }

  Future<VoidResult> addConversation(ConversationModel conversation) async {
    try {
      await _db
          .collection(FirebasePath.conversations)
          .doc(conversation.uid)
          .set(conversation.toJson());
      return Result.ok(null);
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }

  Future<VoidResult> deleteConversation(String conversationUid) async {
    try {
      await _db
          .collection(FirebasePath.conversations)
          .doc(conversationUid)
          .delete();
      return Result.ok(null);
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }

  Future<VoidResult> updateConversation(
    String conversationUid,
    MessageModel message,
  ) async {
    try {
      await _db
          .collection(FirebasePath.conversations)
          .doc(conversationUid)
          .update({
            'lastMessage': message.text,
            'lastMessageAt': Timestamp.fromDate(message.createdAt),
            'lastMessageSenderUid': message.senderUid,
          });
      return Result.ok(null);
    } on Exception {
      return Result.failure(FirestoreException());
    }
  }

  Future<Result<String?>> checkExistingConversation(
    String partnerUid,
    String userUid,
  ) async {
    try {
      final snapshot =
          await _db
              .collection(FirebasePath.conversations)
              .where('participants', arrayContains: userUid)
              .get();

      for (final doc in snapshot.docs) {
        final participants = List<String>.from(doc['participants']);

        if (participants.contains(partnerUid)) {
          return Result.ok(doc.id);
        }
      }

      return Result.ok(null);
    } catch (e) {
      return Result.failure(FirestoreException());
    }
  }
}
