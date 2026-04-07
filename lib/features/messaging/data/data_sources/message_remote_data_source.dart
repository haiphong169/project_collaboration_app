import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_collaboration_app/features/messaging/data/models/message_model.dart';
import 'package:project_collaboration_app/utils/firebase_path.dart';

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

  Future<void> sendMessage(MessageModel message) {
    return _db
        .collection(FirebasePath.conversations)
        .doc(message.conversationUid)
        .collection(FirebasePath.messages)
        .doc(message.uid)
        .set(message.toJson());
  }

  Future<void> deleteMessage(String conversationUid, String messageUid) async {
    return _db
        .collection(FirebasePath.conversations)
        .doc(conversationUid)
        .collection(FirebasePath.messages)
        .doc(messageUid)
        .delete();
  }
}
