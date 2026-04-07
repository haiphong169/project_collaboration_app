import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_collaboration_app/features/messaging/data/models/conversation_model.dart';
import 'package:project_collaboration_app/features/messaging/data/models/message_model.dart';
import 'package:project_collaboration_app/utils/app_exception.dart';
import 'package:project_collaboration_app/utils/firebase_path.dart';
import 'package:project_collaboration_app/utils/result.dart';

class ConversationRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ConversationModel>> getConversations(String userUid) {
    return _db
        .collection(FirebasePath.conversations)
        .where('participants', arrayContains: userUid)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ConversationModel.fromJson(doc.data(), doc.id);
          }).toList();
        });
  }

  Future<void> addConversation(ConversationModel conversation) async {
    return _db
        .collection(FirebasePath.conversations)
        .doc(conversation.uid)
        .set(conversation.toJson());
  }

  Future<void> deleteConversation(String conversationUid) {
    return _db
        .collection(FirebasePath.conversations)
        .doc(conversationUid)
        .delete();
  }

  Future<void> updateConversation(
    String conversationUid,
    MessageModel message,
  ) {
    return _db
        .collection(FirebasePath.conversations)
        .doc(conversationUid)
        .update({
          'lastMessage': message.text,
          'lastMessageAt': Timestamp.fromDate(message.createdAt),
          'lastMessageSenderUid': message.senderUid,
        });
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
