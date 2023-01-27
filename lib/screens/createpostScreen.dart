import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_practice/screens/post_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../controller/imageScreenController.dart';
import '../controller/postScreenController.dart';
import '../models/user_profile_model.dart';
import 'commentScreen2.dart';


class CreatePostScreen extends StatefulWidget {
  final UserProfileModel userdetail;
  CreatePostScreen({Key? key, required this.userdetail}) : super(key: key);
  TextEditingController postController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey();

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<CreatePostController>(
          init: CreatePostController(),
          initState: (_) {},
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        }, icon: const Icon(Icons.arrow_back)),
                    const Text(
                      'Create Post',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      onPressed: () {
                        // Get.to(TestMe());
                        Get.to(const PostScreen());
                        // _.uploadPostImageToFirebase(context);
                        _.addPostToFirestore(
                            posttext: _.posttextcontroller.text,
                            userimageurl: widget.userdetail.profileImageUrl,
                            username: widget.userdetail.metadata.name);
                      },
                      child: const Text('Post'),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Image.network(widget.userdetail.profileImageUrl),
                  title: Text(
                    widget.userdetail.firstName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey),
                            onPressed: () {},
                            icon: const Icon(Icons.group),
                            label: Row(
                              children: const [
                                Text('Friends'),
                                Expanded(
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey),
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                            label: Row(
                              children: const [
                                Text('Album'),
                                Expanded(
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _.pickPostImage(context);
                  },
                  child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                      child: _.postImageFile != null
                          ? Image.file(
                              _.postImageFile!,
                              fit: BoxFit.fill,
                            )
                          : const Icon(
                              MdiIcons.camera,
                              size: 35,
                              color: Colors.black,
                            )),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'What\'s on your Mind?',
                    hintStyle: TextStyle(fontSize: 20),
                  ),
                  controller: _.posttextcontroller,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
