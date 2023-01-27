import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';

class CreatePostController extends GetxController {
  GlobalKey<FormState> _postformke = GlobalKey();

  TextEditingController posttextcontroller = TextEditingController();
  static CollectionReference postReference =
      FirebaseFirestore.instance.collection("post");

  CollectionReference imagepostReference =
      FirebaseFirestore.instance.collection("postImages");

  User? currentuser = FirebaseAuth.instance.currentUser;

  File? postImageFile;
  String postImageUpdateKey = "postImageUpdatekey";

  pickPostImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
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
        postImageFile = File(croppedFile.path);
        print("image.path: ${image.path}");
        update([postImageUpdateKey]);
        onInit();
        // await  uploadPostImageToFirebase(context);
      }
    }
  }

  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();
  }

  void addPostToFirestore(
      {required String posttext,
      required String userimageurl,
      required String username}) async {
    User? user = FirebaseAuth.instance.currentUser;
    String UniqueName = DateTime.now().microsecondsSinceEpoch.toString();

    /// UPLOAD IMAGE TO FIREBASE
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    firebase_storage.Reference ref =
        storage
            .ref()
            .child("post")
            .child(UniqueName);
    try {
      // store the file
      await ref.putFile(postImageFile!);

      /// Send Image URL to Firestore
      String imagePostUrl = "";
      imagePostUrl = await ref.getDownloadURL();

      if (imagePostUrl != null) {
        String uid = '';
        //print("uid:$uid");
        if (user != null) {
          uid = user!.uid;
        }
        print("uid:$uid");
        // var format = DateFormat.yMd('ar');
        // var nowdatetime = format.format(DateTime.now());
        String nowdatetime = DateTime.now().microsecondsSinceEpoch.toString();
        Map<String, dynamic> data = {
          "uid": uid,
          "posttext": posttext,
          "userImageUrl": userimageurl,
          "datetimepost": nowdatetime,
          "username": username,
          "postImageUrl": imagePostUrl
        };

        postReference
            .add(data)
            .then((value) => print("Successfully add to firestore"))
            .onError((error, stacktrace) => print("Error $error"));
        // try {
        //   DocumentReference currentPostReference = postReference.doc(uid);
        //   await currentPostReference.update({"postImageUrl": imagePostUrl});
        //   return true;
        // } on Exception catch (e) {
        //   print("post img error");
        //   return false;
        // }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> likespost(String postid, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await postReference.doc(postid).update({
          // if the likes list contains the user uid, we need to remove it
          'likes': FieldValue.arrayRemove([uid]),
          "likecount": FieldValue.increment(-1),
        });
      } else {
        await postReference.doc(postid).update({
          // else we need to add uid to the likes array
          'likes': FieldValue.arrayUnion([uid]),
          "likecount": FieldValue.increment(1),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Future uploadPostImageToFirebase(BuildContext context) async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   String UniqueName = DateTime.now().microsecondsSinceEpoch.toString();
  //   /// UPLOAD IMAGE TO FIREBASE
  //   firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  //   firebase_storage.Reference ref = storage.ref().child("post").child(UniqueName);
  //   try {
  //     // store the file
  //     await ref.putFile(postImageFile!);
  //     /// Send Image URL to Firestore
  //     String imagePostUrl = "";
  //     imagePostUrl = await ref.getDownloadURL();
  //     if(imagePostUrl != null){
  //       String uid='';
  //       //print("uid:$uid");
  //       if(user!= null){
  //         uid=user!.uid;
  //       }
  //       print("uid:$uid");
  //       try {
  //         DocumentReference currentPostReference = postReference.doc(uid);
  //         await currentPostReference.update({"postImageUrl":imagePostUrl});
  //         return true;
  //       } on Exception catch (e) {
  //         print("post img error");
  //         return false;
  //       }
  //       Map<String, dynamic> data = {
  //         "uid": uid,
  //         "image url": imagePostUrl.toString(),
  //       };
  //
  //       print(data);
  //       imagepostReference
  //           .add(data)
  //           .then((value) => print("Successfully add to firestore"))
  //           .onError((error, stackTrace) => print('Error'));
  //     }
  //   }
  //   catch(e){
  //     print("cover img m error");
  //     print(e);
  //   }
  //
  // }
  //
  //
  // void addPosttToFirestore({required String posttext,required String userimageurl,required String username})async{
  //   User? currentUser=FirebaseAuth.instance.currentUser;
  //   // CollectionReference postReference = FirebaseFirestore.instance.collection("post");
  //   String uid="";
  //   if(currentUser!=null){
  //     uid=currentUser.uid;
  //   }
  //
  //   // var format = DateFormat.yMd('ar');
  //   // var nowdatetime = format.format(DateTime.now());
  //   String nowdatetime = DateTime.now().microsecondsSinceEpoch.toString();
  //   Map<String, dynamic> data={"uid": uid,"posttext":posttext,"userImageUrl":userimageurl,"datetimepost":nowdatetime,"username":username};
  //   postReference
  //       .add(data).then((value)
  //   => print("Successfully add to firestore"))
  //       .onError((error, stacktrace)
  //   =>print("Error $error"));
  // }
}
