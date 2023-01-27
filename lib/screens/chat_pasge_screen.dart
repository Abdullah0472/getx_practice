import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/user_profile_model.dart';


class ChatPageScreen extends StatefulWidget {
  final UserProfileModel userdetail;
  const ChatPageScreen({Key? key, required this.userdetail}) : super(key: key);

  @override
  State<ChatPageScreen> createState() => _ChatPageScreenState();
}

class _ChatPageScreenState extends State<ChatPageScreen> {
  CollectionReference uerRefrence =
      FirebaseFirestore.instance.collection("users");
  User? user = FirebaseAuth.instance.currentUser;
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
            return SizedBox(
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  flexibleSpace: _appBar(),
                ),
                body: Column(
                  children: [
                 ListView.builder(
                     shrinkWrap: true,
                     //  scrollDirection: Axis.vertical,
                     physics: const ScrollPhysics(),
                     itemCount: snapshot.data!.docs.length,
                     itemBuilder: (context, index){
             return Text("Hi ");
                 }),
                    _chatInput(),
                  ],
                ),
              ),
            );
          }
          return const Text("Loading");
        });
  }

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
          ),
          ClipRect(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: CachedNetworkImage(
                width: 50,
                height: 50,
                imageUrl: widget.userdetail.profileImageUrl,
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userdetail.firstName,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              const Text(
                "Last Seen",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),
                  Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: "Type Something....",
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(

                      Icons.camera,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          /// Send Message Button

          MaterialButton(
            padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 5),
            shape: CircleBorder(),
            minWidth: 0,
            color: Colors.green,
            child: Icon(Icons.send,color: Colors.white,size: 28,),
              onPressed: (){}

          ),
        ],
      ),
    );
  }
}
