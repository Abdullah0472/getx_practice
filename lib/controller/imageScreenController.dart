import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getx_practice/Models/user_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

import '../models/post_models.dart';

class ImagePickerController extends GetxController {
  postModel? detail;
  File? imageFile;
  File? coverFile;
  String imageUpdateKey = "imageUpdatekey";
  String coverUpdateKey = "coverUpdateKey";
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference imageReference =
      FirebaseFirestore.instance.collection("images");
  CollectionReference userReference = FirebaseFirestore.instance.collection("users");
  String imageUrl = "";
  String CoverUrl = "";
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String UniqueName = DateTime.now().microsecondsSinceEpoch.toString();
  String UniqueCoverName = DateTime.now().microsecondsSinceEpoch.toString();

  pickUserProfileImage(BuildContext context) async {
    ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    final filename = basename(image!.path);
    final destination = 'files/$filename';
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
              toolbarTitle: 'Profile Image Crop',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Profile Image Crop',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      if (croppedFile != null) {
        imageFile = File(croppedFile.path);
        print("image.path: ${image.path}");
        update([imageUpdateKey]);
        _picker = File(image.path) as ImagePicker;
        uploadImageToFirebase(context);
      }
    }
  }

  uploadImageToFirebase(BuildContext context) async {
    /// UPLOAD IMAGE TO FIREBASE

    // get reference to storage root
    firebase_storage.Reference referenceRoot =
        firebase_storage.FirebaseStorage.instance.ref();
    firebase_storage.Reference referenceDirectory =
        referenceRoot.child("images");

    // create reference for image to be stores
    firebase_storage.Reference referenceImageToUpload =
        referenceDirectory.child(UniqueName);

    try {
      // store the file
      await referenceImageToUpload.putFile(imageFile!);
      imageUrl = await referenceImageToUpload.getDownloadURL();

      if (imageUrl != null) {
        String uid = "";
        print("uid:$uid");
        if (user != null) {
          uid = user!.uid;
        }
        print("uid:$uid");
        try {

          DocumentReference currentUserReference = userReference.doc(uid);
          await currentUserReference.update({"profileImageUrl":imageUrl});
          return true;
        } on Exception catch (e) {
          return false;
        }
        // Map<String, dynamic> data = {
        //   "uid": uid,
        //   "image url": imageUrl.toString(),
        // };
        //
        // print(data);
        // imageReference
        //     .add(data)
        //     .then((value) => print("Successfully add to firestore"))
        //     .onError((error, stackTrace) => print('Error'));
      }
    } catch (e) {
      print(e);
    }
  }

/// Get Image from Firebase
  // FutureBuilder<DocumentSnapshot> getImagefromFirebase() async {
  //   future: userReference.doc(user!.uid).get();
  //   await imageReference
  //   .where("uid", isEqualTo: detail?.uid)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     for (var doc in querySnapshot.docs) {
  //       Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
  //       userList.add(UsersModel.fromJson(docData, doc.id));
  //     }
  //   })
  //       .catchError((error, stackTrace) {
  //     print(error);
  //   });
  //
  // }

  pickCoverImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

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
              toolbarTitle: 'Cover Image Crop',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cover Image Crop',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      if (croppedFile != null) {
        coverFile = File(croppedFile.path);
        print("image.path: ${image.path}");
        update([coverUpdateKey]);

        uploadImageToFirebase(context);
      }
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }


  uploadCoverToFirebase(BuildContext context) async {
    /// UPLOAD IMAGE TO FIREBASE

    // get reference to storage root
    firebase_storage.Reference referenceRoot =
    firebase_storage.FirebaseStorage.instance.ref();
    firebase_storage.Reference referenceDirectory =
    referenceRoot.child("cover");

    // create reference for image to be stores
    firebase_storage.Reference referenceImageToUpload =
    referenceDirectory.child(UniqueCoverName);

    try {
      // store the file
      await referenceImageToUpload.putFile(coverFile!);
      CoverUrl = await referenceImageToUpload.getDownloadURL();

      if (CoverUrl != null) {
        String uid = "";
        print("uid:$uid");
        if (user != null) {
          uid = user!.uid;
        }
        print("uid:$uid");
        try {

          DocumentReference currentUserReference = userReference.doc(uid);
          await currentUserReference.update({"coverImageUrl":CoverUrl});
          return true;
        } on Exception catch (e) {
          return false;
        }
        // Map<String, dynamic> data = {
        //   "uid": uid,
        //   "image url": imageUrl.toString(),
        // };
        //
        // print(data);
        // imageReference
        //     .add(data)
        //     .then((value) => print("Successfully add to firestore"))
        //     .onError((error, stackTrace) => print('Error'));
      }
    } catch (e) {
      print(e);
    }
  }
}
