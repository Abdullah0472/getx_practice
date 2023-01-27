import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_practice/models/message_model.dart';

import '../models/user_profile_model.dart';

TextEditingController chatController = TextEditingController();
User? user = FirebaseAuth.instance.currentUser;
CollectionReference userReference =
    FirebaseFirestore.instance.collection("users");

class ChatScreenController extends GetxController {
  // for adding chat user of our conversation

  Future<bool> addChatUser(String email) async {
    final data = await userReference.where("email", isEqualTo: email).get();

    if (data.docs.isNotEmpty && data.docs.first.id != user!.uid) {
      userReference
          .doc(user!.uid)
          .collection("my_users")
          .doc(data.docs.first.id)
          .set({});
      return true;
    } else {
      false;
    }
    return false;
  }

  /// Useful for getting conversation id
  static String getConversationID(String id) =>
      user!.uid.hashCode <= id.hashCode
          ? '${user!.uid}_$id'
          : '${id}_${user?.uid}';

  /// for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserProfileModel user) {
    return FirebaseFirestore.instance
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  /// for sending message

  static Future<void> sendMessage(UserProfileModel userdetail, String msg) async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    // message to send
    final Message message = Message(
        toId: userdetail.id,
        msg: msg,
        read: "",
        type: Type.text,
        fromId: user!.uid,
        sent: time);
    final ref = FirebaseFirestore.instance
        .collection('chats/${getConversationID(userdetail.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }
}
