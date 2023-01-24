import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getx_practice/Models/user_model.dart';
import 'package:getx_practice/controller/homeScreenController.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:getx_practice/models/post_models.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../controller/imageScreenController.dart';
import 'commentScreen2.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);
  HomeScreenController controller = Get.put(HomeScreenController());
  CollectionReference uerRefrence =
      FirebaseFirestore.instance.collection("users");
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImagePickerController>(
        init: ImagePickerController(),
        builder: (_) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Text("User Personal Screen"),
                actions: [
                  TextButton(
                      onPressed: () async {
                        await _.uploadImageToFirebase(context);
                        await _.uploadCoverToFirebase(context);
                      },
                      child: const Text(
                        "upload",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
              body: FutureBuilder<DocumentSnapshot>(
                  future: uerRefrence.doc(user!.uid).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text("Document does not exist");
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      ///------------With Model--------------------------///
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      UsersModel detail =
                          UsersModel.fromJson(data, snapshot.data!.id);
                      postModel postdetail = postModel.fromJson(data, snapshot.data!.id);
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
                                  child:
                                  // _.coverFile != null
                                  //     ? Image.file(
                                  //   _ .coverFile!,
                                  //         fit: BoxFit.cover,
                                  //       )
                                  //     :
                                 Image.network(detail.coverImageUrl,fit: BoxFit.cover,),),),
                          Row(
                            children: [
                              Positioned(
                                bottom: -50,
                                child:
                                    Stack(clipBehavior: Clip.none, children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: SizedBox(
                                            width: 70,
                                            height: 70,
                                            child: Image.network(
                                                detail.profileImageUrl,
                                                fit: BoxFit.cover)),
                                  ),
                                  Positioned(
                                    right: -10,
                                    top: -5,
                                    child: IconButton(
                                      onPressed: () async {
                                        _.pickUserProfileImage(context);
                                      },
                                      icon:
                                          const Icon(Icons.camera_alt_outlined),
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
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 70,
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.share,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 500,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: 12,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Container(
                                    height: 350,
                                    child: Column(
                                      children: [

                                        ListTile(
                                          leading: CircleAvatar(
                                            child: Image.network(
                                              detail.profileImageUrl,
                                              fit: BoxFit.fill,),
                                          ),
                                          title: Text(detail.name),
                                          subtitle: Text(detail.email),
                                        ),
                                        Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        detail.coverImageUrl),
                                                    fit: BoxFit.cover,
                                                  )
                                              ),
                                            )),
                                        SizedBox(height: 15,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 8,),
                                                IconButton(onPressed: () {},
                                                    icon: Icon(MdiIcons.thumbUp,
                                                      color: Colors.grey,)),
                                                Text("Like", style: TextStyle(
                                                    color: Colors.grey),),
                                              ],
                                            ),
                                            SizedBox(width: 8,),
                                            Row(
                                              children: [
                                                IconButton(onPressed: () {
                                                  Get.to(CommentsBoxScreen(postdetail: postdetail,userdetail: detail,));
                                                },
                                                    icon: Icon(MdiIcons.comment,
                                                      color: Colors.grey,)),
                                                Text("Comments", style: TextStyle(
                                                    color: Colors.grey),),
                                              ],
                                            ),
                                            SizedBox(width: 8,),
                                            Row(
                                              children: [
                                                IconButton(onPressed: () {},
                                                    icon: Icon(MdiIcons.share,
                                                      color: Colors.grey,)),
                                                Text("Share", style: TextStyle(
                                                    color: Colors.grey),),
                                              ],
                                            ),

                                          ],
                                        ),
                                        SizedBox(height: 15,),
                                      ],
                                    ),
                                  ),
                                );
                              },

                            ),
                          ),
                        ],
                      );
                    }
                    return Text("loading");
                  }));
        });
  }
}
