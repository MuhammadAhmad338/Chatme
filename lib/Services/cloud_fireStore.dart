// ignore_for_file: file_names, unused_local_variable, await_only_futures
import 'package:chat_app/Models/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/messages.dart';
import '../Models/useModel.dart';

class CloudFireStore {
  final String uid;
  CloudFireStore({required this.uid});
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  //Saving/Set the user in the collection
  //Setting the user in the firebasefirestore collection
  Future<void> addUser(UserModel user) async {
    await firebaseFirestore.collection("Users").doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await firebaseFirestore.collection("Users").doc(uid).get();
    return doc.exists ? UserModel.fromMap(doc.data()!) : null;
  }

  Stream<List<UserModel>> getAllUsers() {
    return firebaseFirestore
        .collection("Users")
        .snapshots()
        .map((snapshots) => snapshots.docs.map((event) {
              final singleDoc = event.data();
              final singleUserFromJson = UserModel.fromMap(singleDoc);
              return singleUserFromJson;
            }).toList());
  }

  Future<String> startChats(
      String myUid, String otherUid, String otherName) async {
    final uid = await getUser(myUid);
    final docId = firebaseFirestore.collection("Chats").doc().id;
    await firebaseFirestore.collection("Chats").doc(docId).set(Chat(
            myUid: myUid,
            myName: uid?.name ?? "",
            otherUid: otherUid,
            otherName: otherName,
            chatId: docId)
        .toMap());
    return docId;
  }

  Stream<List<Chat?>> getChats() {
    return firebaseFirestore
        .collection("Chats")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((event) {
              final docdata = event.data();
              final chat = Chat.fromMap(docdata);
              if (chat.myUid == uid || chat.otherUid == uid) {
                return chat;
              }
              return null;
            }).toList());
  }

  Future<void> sendMessage(String chatId, Message message) async {
    await firebaseFirestore
        .collection("Chats")
        .doc(chatId)
        .collection("Messages")
        .add(message.toMap());
  }

  Stream<List<Message>> getAllMessages(String chatId) {
    return firebaseFirestore
        .collection("Chats")
        .doc(chatId)
        .collection("Messages")
        .orderBy("time", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((event) {
              final docdata = event.data();
              final messages = Message.fromMap(docdata);
              return messages;
            }).toList());
  }

  Future<String> getChatStarted(String myUid, String otherUid) async {
    final doc = await firebaseFirestore
        .collection("Chats")
        .where("myUid", isEqualTo: myUid)
        .where("otherUid", isEqualTo: otherUid)
        .get();
    if (doc.docs.isNotEmpty) {
      return doc.docs[0].id;
    }
    final doc1 = await firebaseFirestore
        .collection("Chats")
        .where("otherUid", isEqualTo: otherUid)
        .where("myUid", isEqualTo: myUid)
        .get();
    if (doc1.docs.isNotEmpty) {
      return doc1.docs[0].id;
    }
    return "";
  }
}
