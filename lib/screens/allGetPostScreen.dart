import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:getx_practice/models/post_models.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../controller/postScreenController.dart';
import '../models/user_profile_model.dart';
import 'commentScreen2.dart';

class AllPostScreen extends StatefulWidget {
  const AllPostScreen({Key? key}) : super(key: key);

  @override
  State<AllPostScreen> createState() => _AllPostScreenState();
}

class _AllPostScreenState extends State<AllPostScreen> {
  CollectionReference uerRefrence =
      FirebaseFirestore.instance.collection("users");

  CollectionReference postRefrence =
      FirebaseFirestore.instance.collection("post");

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreatePostController>(
        init: CreatePostController(),
        builder: (_) {
          return FutureBuilder(
              future: uerRefrence.doc(user!.uid).get(),
              builder: (BuildContext context,
                  AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return const Text("Document does not exist");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  ///------------With Model--------------------------///
                  UserProfileModel userdetail = UserProfileModel.fromDocumentSnapshot(snapshot: snapshot.data);
                  return Scaffold(
                      body: SingleChildScrollView(
                    child: Column(
                      children: [
                        FutureBuilder<QuerySnapshot>(
                            future: postRefrence.get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text("Something went wrong");
                              }

                              // if (snapshot.hasData && snapshot != null) {
                              //   return const Text("Document does not exist");
                              // }
                              if (snapshot.hasData) {
                                ///------------With Model--------------------------///
                                return ListView.builder(
                                  shrinkWrap: true,
                                  //  scrollDirection: Axis.vertical,
                                  physics: const ScrollPhysics(),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> doc =
                                        snapshot.data!.docs[index].data()
                                            as Map<String, dynamic>;
                                    String docId =
                                        snapshot.data!.docs[index].id;
                                    postModel detail =
                                        postModel.fromJson(doc, docId);
                                    return Card(
                                      child: Container(
                                        height: 350,
                                        child: Column(
                                          children: [
                                            ListTile(
                                              leading: CircleAvatar(
                                                  child: detail.userImageUrl ==
                                                          null
                                                      ? Container(
                                                          color: Colors.grey,
                                                        )
                                                      : Image.network(
                                                          detail.userImageUrl,
                                                          fit: BoxFit.fill,
                                                        )),
                                              title: Text(detail.username),
                                              subtitle: Text(detail.posttext),
                                            ),
                                            Expanded(
                                                child:
                                                    detail.postImageUrl == null
                                                        ? Container(
                                                            color: Colors.grey,
                                                          )
                                                        : Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                              image: NetworkImage(
                                                                  detail
                                                                      .postImageUrl),
                                                              fit: BoxFit.cover,
                                                            )),
                                                          )),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      // Get.to(() =>
                                                      //     Like(
                                                      //       postdetail: detail,));
                                                    },
                                                    child: Text(
                                                        "${detail.likecount} Likes")),
                                                Text("${detail.commentcount} Comments"),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  children: [
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          _.likespost(
                                                              detail.id,
                                                              detail.uid,
                                                              detail.likes);
                                                        },
                                                        icon: detail.likes
                                                                .contains(
                                                                    user!.uid)
                                                            ? const Icon(
                                                                MdiIcons
                                                                    .thumbUp,
                                                                color: Colors
                                                                    .blueAccent,
                                                              )
                                                            : const Icon(
                                                                MdiIcons
                                                                    .thumbUp,
                                                                color:
                                                                    Colors.grey,
                                                              )),
                                                    const Text(
                                                      "Like",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          Get.to(
                                                              CommentsBoxScreen(
                                                            postdetail: detail,
                                                            userdetail:
                                                                userdetail,
                                                          ));
                                                        },
                                                        icon: const Icon(
                                                          MdiIcons.comment,
                                                          color: Colors.grey,
                                                        )),
                                                    const Text(
                                                      "Comments",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                          MdiIcons.share,
                                                          color: Colors.grey,
                                                        )),
                                                    const Text(
                                                      "Share",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                              return const Text("Loading....");
                            })
                      ],
                    ),
                  ));
                }
                return const Text("Please Wait");
              });
        });
  }
}
