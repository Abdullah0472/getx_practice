import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../Models/user_model.dart';
import '../controller/chatScreenController.dart';
import '../models/message_model.dart';
import 'chat/rooms.dart';
import 'chat_pasge_screen.dart';
import 'chating_screen_pckg.dart';

class ChatUserCardScreen extends StatefulWidget {
  final UsersModel userdetail;
  ChatUserCardScreen({
    Key? key,
    required this.userdetail,
  }) : super(key: key);

  @override
  State<ChatUserCardScreen> createState() => _ChatUserCardScreenState();
}

class _ChatUserCardScreenState extends State<ChatUserCardScreen> {
  CollectionReference uerRefrence =
      FirebaseFirestore.instance.collection("users");

  User? user = FirebaseAuth.instance.currentUser;
  // CollectionReference myuserRef = uerRefrence.doc(user!.uid) as CollectionReference<Object?>

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: uerRefrence.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          // if (snapshot.hasData && !snapshot.data!.exists) {
          //   return const Text("Document does not exist");
          // }
          if (snapshot.connectionState == ConnectionState.done) {
            return GetBuilder<ChatScreenController>(
              init: ChatScreenController(),
              builder: (_) {
                return Scaffold(
                  floatingActionButton: Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: FloatingActionButton(
                      onPressed: () {
                        _showMessageDialoge();
                      },
                      child: const Icon(Icons.add_comment_rounded),
                    ),
                  ),
                  body: Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          //  scrollDirection: Axis.vertical,
                          physics: const ScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> doc =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            String docId = snapshot.data!.docs[index].id;
                            UsersModel userdetail =
                                UsersModel.fromJson(doc, docId);
                            return Card(
                              color: Colors.lightBlueAccent.shade100,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8 * 0.4, vertical: 6),
                              elevation: 0.7,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: InkWell(
                                onTap: () {
                                  Get.to(
                                      // ChatPage(userdetail: userdetail,)
                                      RoomsPage(),
                                  );
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                      // ignore: unnecessary_null_comparison
                                      child: userdetail.profileImageUrl == null
                                          ? Container(
                                              color: Colors.grey,
                                              child: const Icon(Icons.person),
                                            )
                                          : Image.network(
                                              userdetail.profileImageUrl,
                                              fit: BoxFit.fill,
                                            )),
                                  title: Text(
                                    userdetail.name,
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  subtitle: const Text(
                                    "Last User Message",
                                    maxLines: 1,
                                  ),
                                  trailing: const Text(
                                    "Time",
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                );
              },
            );
          }
          return const Text("Loading");
        });
  }

  void _showMessageDialoge() {
    String email = "";
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: const [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Add User",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              content: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.email),
                ),
                onChanged: (value) => email = value,
              ),
              actions: [
                MaterialButton(
                  onPressed: () {},
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    if (email.isNotEmpty) {
                      ChatScreenController()
                          .addChatUser(email)
                          .then((value) {
                        if (!value) {
                          final snackBar = SnackBar(
                            content: const Text('User Doesnot  Exist'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );

                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    }
                  },
                  child: const Text(
                    "Add ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ));
  }
}
