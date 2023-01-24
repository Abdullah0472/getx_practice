import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:getx_practice/screens/user_screen.dart';
import 'package:getx_practice/screens/home_screens.dart';
import 'package:getx_practice/screens/login_screen.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../screens/login.dart';
import '../screens/post_screen.dart';

class LoginScreenContrroler extends GetxController {
  // TextEditingController for Email and Password

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey();

  // Hint Text and Label Text of Email TextFormField and Password TextFormField
  String textUser = "Enter Your Name";
  String textEmail = "Enter Your Email ";
  String textPass = "Enter Your Password ";

  // Icons of Email TextFormField and Password TextFormField
  IconData usericons = Icons.person;
  IconData emailicons = Icons.email_outlined;
  IconData passicons = Icons.lock_outline;

  // Password Type
  bool passwordType = true;

// Validator of Email
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter email in TextFormField";
    }
    if (!GetUtils.isEmail(value)) {
      return "Enter proper email address";
    }
    return null;
  }

  // Validator of Password
  //  String? passwordValidator(String? value) {
  //    if (value == null || value.isEmpty) {
  //      return "Enter the password in TextFormField";
  //    }
  //    if ((!RegExp(
  //        r'^(?=.*?[A-Z]{2})(?=.*?[a-z]{5})(?=.*?[0-9]{3})(?=.*?[!@#\$&*~]{2}).{}$')
  //        .hasMatch(value))) {
  //      return 'Please Enter valid password';
  //    }
  //
  //    return null;
  //  }
  String? passwordValidator(String? value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value!.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  String? userValidator(String? value) {
    if (!value!.contains(RegExp(r'^[a-zA-Z0-9 ]+$'))) {
      return 'Enter Some Alphabets ';
    }
  }

  onLoginPressed() {
    Get.snackbar("Login Status", "Successfully Logged in",
        backgroundColor: Colors.pink, colorText: Colors.white);
    Get.defaultDialog(title: "Status", content: Text("Successfully Logged in"));
  }

  String titleLogin = "Login";
  String titleSignup = "Sign-Up";

  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  // }


  /// fireBase wala Kaam

  static CollectionReference userReference =
      FirebaseFirestore.instance.collection("users");
  static LoginScreenContrroler instance = Get.find();
// Include Email, Password, Name of the user......
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    _user = Rx<User?>(auth.currentUser);
    //   the user is bind with stream just like stream builder whatever
    // change will happen our app/user will be notifed that change is happened
    // Login and Logout change will be getting notfied be bindstream
    _user.bindStream(auth.userChanges());
    // This take listner and function to interavtivate
    // user will be notified
    // What happened in user the initial finction will be notified
    ever(_user, _initalScreeen);
  }

  _initalScreeen(User? user) {
    if (user != null) {
      Get.offAll(() => PostScreen());
    } else {
     Get.offAll(() => LoginScree());
     //Ye apna wala kaam ha
     // Get.offAll(() => LoginPage() );

    }
  }

  Future<bool> signUpUser({
    required String email,
    required String password,
    required String userName,
  }) async {
    bool status = false;
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? currentUser = credential.user;

      if (currentUser != null) {
        Map<String, dynamic> userProfileData = {
          "name": userName,
          "email": email,
           "uid" : currentUser.uid,

        };
        await FirebaseChatCore.instance.createUserInFirestore(
          types.User(
            id: credential.user!.uid,
            firstName: userName,
            metadata: userProfileData,
          )
        );
      //   DocumentReference currentUserReference =
      //       userReference.doc(currentUser.uid);
      //   Map<String, dynamic> userProfileScreen = {
      //     "name": userName,
      //     "email": email,
      //     "uid": currentUser.uid,
      //
      //   };
      //   await currentUserReference.set(userProfileScreen);
      }
      status = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      Get.snackbar(
        "About User",
        "User Massage",
        backgroundColor: Colors.amber,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          "Account Creation Failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return status;
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    bool status = false;
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? currentUser = credential.user;

      status = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      Get.snackbar(
        "About User",
        "User Massage",
        backgroundColor: Colors.amber,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text(
          "Account Creation Failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return status;
  }
}
