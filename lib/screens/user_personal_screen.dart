import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../Models/user_model.dart';
import '../controller/imageScreenController.dart';
import '../models/post_models.dart';
import 'commentScreen2.dart';

class UserPersonalScreen extends StatefulWidget {
  const UserPersonalScreen({Key? key}) : super(key: key);

  @override
  State<UserPersonalScreen> createState() => _UserPersonalScreenState();
}

class _UserPersonalScreenState extends State<UserPersonalScreen> {
  CollectionReference uerRefrence =
      FirebaseFirestore.instance.collection("users");
  CollectionReference postRefrence =
      FirebaseFirestore.instance.collection("post");
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: uerRefrence.doc(user!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            ///------------With Model--------------------------///
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            UsersModel detail = UsersModel.fromJson(data, snapshot.data!.id);
            return GetBuilder<ImagePickerController>(
              init: ImagePickerController(),
              initState: (_) {},
              builder: (_) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await _.pickCoverImage(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 160,
                        color: Colors.grey.shade300,
                        child: Image.network(
                          detail.coverImageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Positioned(
                          bottom: -50,
                          child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: Image.network(detail.profileImageUrl,
                                      fit: BoxFit.cover)),
                            ),
                            Positioned(
                              right: -10,
                              top: -5,
                              child: IconButton(
                                onPressed: () async {
                                  _.pickUserProfileImage(context);
                                },
                                icon: const Icon(Icons.camera_alt_outlined),
                                color: Colors.white,
                              ),
                            )
                          ]),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              detail.name,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              detail.email,
                              style: const TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 70,
                        ),
                        Column(
                          children: [
                            IconButton(
                                onPressed: () {
                                  _.uploadImageToFirebase(context);
                                  _.uploadCoverToFirebase(context);
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.red,
                                )),
                            const Text("Upload Image \n and Cover "),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 380,
                      child: FutureBuilder<QuerySnapshot>(
                          future: postRefrence
                              .get(),
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
                                physics: ScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> doc =
                                      snapshot.data!.docs[index].data()
                                          as Map<String, dynamic>;
                                  String docId = snapshot.data!.docs[index].id;
                                  postModel postdetail =
                                      postModel.fromJson(doc, docId);
                                  return Card(
                                    child: Container(
                                      height: 350,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: CircleAvatar(
                                                child: postdetail
                                                            .userImageUrl ==
                                                        null
                                                    ? Container(
                                                        color: Colors.grey,
                                                      )
                                                    : Image.network(
                                                        postdetail.userImageUrl,
                                                        fit: BoxFit.fill,
                                                      )),
                                            title: Text(postdetail.username),
                                            subtitle: Text(postdetail.posttext),
                                          ),
                                          Expanded(
                                              child: postdetail.postImageUrl ==
                                                      null
                                                  ? Container(
                                                      color: Colors.grey,
                                                    )
                                                  : Container(
                                                      decoration: BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                        image: NetworkImage(
                                                            postdetail
                                                                .postImageUrl),
                                                        fit: BoxFit.cover,
                                                      )),
                                                    )),
                                          const SizedBox(
                                            height: 15,
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
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        MdiIcons.thumbUp,
                                                        color: Colors.grey,
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
                                                          postdetail:
                                                              postdetail,
                                                          userdetail: detail,
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
                            return Text("Loading....");
                          }),
                    ),
                  ],
                );
              },
            );
          }
          return const Text("loading");
        });
  }
}
