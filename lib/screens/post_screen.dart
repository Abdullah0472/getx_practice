import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:getx_practice/controller/imageScreenController.dart';
import 'package:getx_practice/screens/createpostScreen.dart';
import 'package:getx_practice/screens/user_personal_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../Models/user_model.dart';
import '../models/post_models.dart';
import '../models/user_profile_model.dart';
import 'chat/rooms.dart';
import 'chat_user_card.dart';
import 'allGetPostScreen.dart';

import 'commentScreen2.dart';
import 'home_screens.dart';

void main() {
  runApp(const PostScreen());
}

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  CollectionReference uerRefrence =
      FirebaseFirestore.instance.collection("users");
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference postRefrence =
  FirebaseFirestore.instance.collection("post");

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return FutureBuilder<DocumentSnapshot>(
        future: uerRefrence.doc(user!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            ///------------With Model--------------------------///
          //  Map<String, dynamic> data =
         //       snapshot.data!.data() as Map<String, dynamic>;
           // UsersModel detail = UsersModel.fromJson(data, snapshot.data!.id);
            UserProfileModel detail = UserProfileModel.fromDocumentSnapshot(snapshot: snapshot.data!);
            return GetBuilder<ImagePickerController>(
                init: ImagePickerController(),
                builder: (_) {
                  return MaterialApp(
                    home: DefaultTabController(
                      length: 3,
                      child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        appBar: AppBar(
                          bottom: PreferredSize(
                            preferredSize: const Size.fromHeight(80.0),
                            child: Column(
                              children: [
                                const TabBar(
                                  tabs: [
                                    Tab(
                                        icon: Icon(
                                      MdiIcons.home,
                                    )),
                                    Tab(icon: Icon(MdiIcons.post)),
                                    Tab(icon: Icon(MdiIcons.video)),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(3.2),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Get.to(CreatePostScreen(
                                                  userdetail: detail));
                                            },
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: SizedBox(
                                                    height: 50,
                                                    width: 50,
                                                    child: Image.network(
                                                      detail.profileImageUrl,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets.symmetric(
                                                                vertical: 15.0,
                                                                horizontal: 15),
                                                        fillColor:
                                                            const Color.fromARGB(
                                                                255, 241, 240, 240),
                                                        filled: true,
                                                        hintText:
                                                            "    What's on your mind, ${detail.firstName}",
                                                        border:
                                                            InputBorder.none,
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    50),
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 1.3,
                                                                    color: Colors
                                                                        .grey)),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(50),
                                                            borderSide: const BorderSide(color: Colors.grey, width: 1.3))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ])),
                              ],
                            ),
                          ),
                          title: const Text(
                            'New Feed',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.white),
                          ),
                          backgroundColor: const Color(0xff345a98),
                          actions: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(MdiIcons.searchWeb)),
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
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                currentAccountPicture: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: Container(
                                      color: Colors.grey.shade100,
                                      child: Image.network(
                                          detail.profileImageUrl,
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
                              const Divider(),
                              _createDrawerItem(
                                  icon: Icons.collections_bookmark,
                                  text: 'Steps',
                                  onTap: () {}),
                              _createDrawerItem(
                                  icon: Icons.face,
                                  text: 'Authors',
                                  onTap: () {}),
                              _createDrawerItem(
                                  icon: Icons.account_box,
                                  text: 'Flutter Documentation',
                                  onTap: () {}),
                              _createDrawerItem(
                                  icon: Icons.stars,
                                  text: 'Useful Links',
                                  onTap: () {}),
                              const Divider(),
                              _createDrawerItem(
                                  icon: Icons.bug_report,
                                  text: 'Report an issue',
                                  onTap: () {}),
                            ],
                          ),
                        ),
                        body:  TabBarView(
                          children: [
                            AllPostScreen(),
                            UserPersonalScreen(),
                          //  ChatUserCardScreen(userdetail: detail,),
                               RoomsPage(),
                            // const Icon(Icons.directions_bike),
                          ],
                        ),
                        floatingActionButton: FloatingActionButton(
                          onPressed: () {
                            Get.to(CreatePostScreen(userdetail: detail));
                          },
                          child: const Icon(MdiIcons.bookEdit),
                        ),
                      ),
                    ),
                  );
                });
          }
          return const Text("Please Wait ");
        });
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

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
