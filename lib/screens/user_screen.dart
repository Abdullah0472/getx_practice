import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_practice/screens/home_screens.dart';
import 'package:getx_practice/screens/createpostScreen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../controller/imageScreenController.dart';
import '../models/user_profile_model.dart';
import '../widgets/text_widgets.dart';
import 'login.dart';
import 'login_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  CollectionReference uerRefrence =
      FirebaseFirestore.instance.collection("users");
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
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
            // Map<String, dynamic> data =
            //     snapshot.data!.data() as Map<String, dynamic>;
            // UsersModel detail = UsersModel.fromJson(data, snapshot.data!.id);
            UserProfileModel detail = UserProfileModel.fromDocumentSnapshot(snapshot: snapshot.data!);
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                centerTitle: true,
                title: const Text("Home SCREEN"),
                backgroundColor: Colors.cyan,
                actions: [
                  IconButton(
                      onPressed: () {
                        auth.signOut().then((value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                // LoginScreen() idhr dalo
                                  builder: (context) => LoginScree()));
                        }).onError((error, stackTrace) {});
                      },
                      icon: const Icon(Icons.logout_outlined)),
                ],
              ),
              drawer: Drawer(
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(
                        detail.firstName,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.bold),
                      ),
                      accountEmail: Text(detail.metadata.email,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      currentAccountPicture: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          width: 10,
                          height: 10,
                          child: Container(
                            color: Colors.grey.shade100,
                            child: Image.network(detail.profileImageUrl,
                                fit: BoxFit.cover),
                            // child: Center(child: Icon(Icons.image,color: Colors.black,),),
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          opacity: 50,
                          image: NetworkImage(detail.coverImageUrl),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    _createDrawerItem(
                      icon: Icons.person,
                      text: 'User Profile',
                      onTap: () {
                        Get.to(HomeScreen());
                      },
                    ),
                    _createDrawerItem(
                      icon: Icons.event,
                      text: 'Events',
                      onTap: () {},
                    ),
                    _createDrawerItem(
                      icon: Icons.note,
                      text: 'Notes',
                      onTap: () {},
                    ),
                    Divider(),
                    _createDrawerItem(
                        icon: Icons.collections_bookmark,
                        text: 'Steps',
                        onTap: () {}),
                    _createDrawerItem(
                        icon: Icons.face, text: 'Authors', onTap: () {}),
                    _createDrawerItem(
                        icon: Icons.account_box,
                        text: 'Flutter Documentation',
                        onTap: () {}),
                    _createDrawerItem(
                        icon: Icons.stars, text: 'Useful Links', onTap: () {}),
                    Divider(),
                    _createDrawerItem(
                        icon: Icons.bug_report,
                        text: 'Report an issue',
                        onTap: () {}),
                  ],
                ),
              ),
              body: GetBuilder<ImagePickerController>(
                  init: ImagePickerController(),
                  builder: (_) {
                    return SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 12.0, right: 12.0, bottom: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ///-----------By future<Document Snapshot>--------------------------///

                              FutureBuilder<DocumentSnapshot>(
                                future: uerRefrence.doc(user!.uid).get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text("Something went wrong");
                                  }

                                  if (snapshot.hasData &&
                                      !snapshot.data!.exists) {
                                    return const Text(
                                        "Document does not exist");
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    ///------------With Model--------------------------///
                                    // Map<String, dynamic> data = snapshot.data!
                                    //     .data() as Map<String, dynamic>;
                                    // UsersModel detail = UsersModel.fromJson(
                                    //     data, snapshot.data!.id);
                                    UserProfileModel detail = UserProfileModel.fromDocumentSnapshot(snapshot: snapshot.data!);
                                    return Card(
                                      elevation: 4,
                                      color: Colors.grey.shade200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Stack(children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      120),
                                                          child: SizedBox(
                                                            width: 120,
                                                            height: 120,
                                                            child: Image.network(
                                                                detail
                                                                    .profileImageUrl,
                                                                fit: BoxFit
                                                                    .cover),
                                                            // child: Image.file(log.imageFile!, fit: BoxFit.cover,)
                                                          ),
                                                        ),
                                                        Positioned(
                                                          right: -10,
                                                          top: -5,
                                                          child: IconButton(
                                                            onPressed:
                                                                () async {
                                                              Get.to(() =>
                                                                  HomeScreen());
                                                              // _.pickUserProfileImage(context);
                                                              // _.uploadImageToFirebase(context);
                                                            },
                                                            icon: const Icon(Icons
                                                                .camera_alt_outlined),
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ]),
                                                      Expanded(
                                                        child: IconButton(
                                                            onPressed: () {
                                                              Get.to(
                                                                  CreatePostScreen(
                                                                userdetail:
                                                                    detail,
                                                              ));
                                                            },
                                                            icon: Icon(
                                                              MdiIcons
                                                                  .plusCircle,
                                                              size: 35,
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                  TextWidget(
                                                      title: "Name",
                                                      detail: detail.firstName),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextWidget(
                                                      title: "Email",
                                                      detail: detail.metadata.email),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  return const Text("loading");
                                },
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: const [
                                  Expanded(
                                      child: Divider(
                                    color: Colors.black,
                                    thickness: 3,
                                    endIndent: 5,
                                  )),
                                  Text(
                                    "POSTS OF USERS",
                                    style: TextStyle(
                                        color: Colors.lightBlueAccent,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Divider(
                                        color: Colors.black,
                                        thickness: 3,
                                        indent: 5),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            );
          }
          return const Text("loading");
        });
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget CustomText({
    required String text,
    required Color textColor,
    required FontWeight textWeight,
    required dynamic textFontSize,
    required TextAlign textAlign,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: textFontSize,
        fontWeight: textWeight,
      ),
    );
  }
}
