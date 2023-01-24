import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CreateCommentController extends GetxController {
  GlobalKey<FormState> _postformke = GlobalKey();

  TextEditingController commenttextcontroller = TextEditingController();
  static CollectionReference commentReference =
      FirebaseFirestore.instance.collection("comment");
  static CollectionReference postReference =
  FirebaseFirestore.instance.collection("post");
  User? currentuser = FirebaseAuth.instance.currentUser;


  ///////////////if Create Directory in Firestore////////////////////////
  CollectionReference imagecommentReference =
      FirebaseFirestore.instance.collection("commentImages");
  //////////////////////////////////////////////////////////////////////////////////////////

  File? commentImageFile;
  String commentImageUpdateKey = "commentImageUpdatekey";

  pickPostImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    // final XFile? video = await _picker.pickVideo(source: ImageSource.camera);

    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      if (croppedFile != null) {
        commentImageFile = File(croppedFile.path);
        print("image.path: ${image.path}");
        update([commentImageUpdateKey]);
        onInit();
        // await  uploadCommentToFirebase(context);
      }
    }
  }

  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();
  }

  Future uploadCommentToFirebase(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    String UniqueName = DateTime.now().microsecondsSinceEpoch.toString();

    /// UPLOAD IMAGE TO FIREBASE
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference ref =
        storage.ref().child("comment").child(UniqueName);
    try {
      // store the file
      await ref.putFile(commentImageFile!);

      /// Send Image URL to Firestore
      String commentImageUrl = "";
      commentImageUrl = await ref.getDownloadURL();
      if (commentImageUrl != null) {
        String uid = '';
        //print("uid:$uid");
        if (user != null) {
          uid = user!.uid;
        }
        print("uid:$uid");
        try {
          DocumentReference currentcommentReference = commentReference.doc(uid);
          await currentcommentReference
              .update({"commentImageUrl": commentImageUrl});
          return true;
        } on Exception catch (e) {
          print("comment img error");
          return false;
        }
        Map<String, dynamic> data = {
          "uid": uid,
          "image url": commentImageUrl.toString(),
        };

        print(data);
        imagecommentReference
            .add(data)
            .then((value) => print("Successfully add to firestore"))
            .onError((error, stackTrace) => print('Error'));
      }
    } catch (e) {
      print("cover img m error");
      print(e);
    }
  }

  void addCommentToFirestore(
      {required String commenttext,
      required String profileImageUrl,
      required String username,
      required String postid,
      required String datetimepost}) async {
    int commentlen = 0;
    User? currentUser = FirebaseAuth.instance.currentUser;
    // CollectionReference postReference = FirebaseFirestore.instance.collection("post");
    String uid = "";
    if (currentUser != null) {
      uid = currentUser.uid;
    }
    String nowdatetime = DateTime.now().microsecondsSinceEpoch.toString();
    // DocumentReference currentUserRefrence = commentReference.doc(currentUser!.uid);
    Map<String, dynamic> data = {
      "uid": uid,
      "commenttext": commenttext,
      "userImageUrl": profileImageUrl,
      "datetimecomment": nowdatetime,
      "username": username,
      "postid": postid,
      "datetimepostid": datetimepost
    };
    commentReference
        .add(data)
        .then((value) => print("Successfully add to firestore"))
        .onError((error, stacktrace) => print("Error $error"));
    QuerySnapshot snap=await commentReference.where("postid" ,isEqualTo: postid ).get();
    commentlen=snap.docs.length;
    await postReference.doc(postid).update({"commentcount": commentlen});
  }

}
