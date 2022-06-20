// System Packages
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Models
import 'package:runx/chat/models/chat_messages.dart';

// Constants
import 'package:runx/chat/constants/firebase_cons.dart';

class ChatProvider {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  ChatProvider(
      {required this.firebaseStorage, required this.firebaseFirestore});

  UploadTask uploadImageFile(File image, String filename) {
    Reference reference = firebaseStorage.ref().child("chat/" + filename);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateFirestoreData(
      String collectionPath, String docPath, Map<String, dynamic> dataUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataUpdate);
  }

  Stream<QuerySnapshot>? getChatMessage(String groupChatId, int limit) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  void sendChatMessage(String content, int type, String groupChatId,
      String currentUserId, String peerId) {
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    ChatMessages chatMessages = ChatMessages(
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        type: type);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, chatMessages.toJson());
    });
  }
}

class MessageType {
  static const text = 0;
  static const image = 1;
}
