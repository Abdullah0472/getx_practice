import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:getx_practice/controller/loginScreenController.dart';
import 'package:getx_practice/screens/post_screen.dart';
import 'package:getx_practice/screens/user_screen.dart';
import 'package:getx_practice/screens/home_screens.dart';
import 'package:password_field_validator/password_field_validator.dart';

import 'package:get/get.dart';
import '../controller/imageScreenController.dart';
import '../notificationservice/local_notification_service.dart';
import '../utils/utils.dart';
import '../widgets/reuseable_widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameControler = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginScreenContrroler>(
        init: LoginScreenContrroler(),
        builder: (_) {
          return Form(
            key: formkey,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xffc82893),
                title: const Text(
                  'Sign Up ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xffc82893),
                    Color(0xff9546c4),
                    Color(0xff5e61f4),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                    child: Column(
                      children: [
                        // GetBuilder<ImagePickerController>(
                        //     init: ImagePickerController(),
                        //     builder: (_){
                        //    _.imageUpdateKey;
                        //    return _.imageFile != null
                        //        ?
                        //        Stack(
                        //          children: [
                        //            Positioned(
                        //              bottom: -50,
                        //              child: Stack(
                        //                  clipBehavior: Clip.none, children: [
                        //
                        //                ClipRRect(
                        //
                        //                  borderRadius: BorderRadius.circular(100),
                        //                  child: SizedBox(
                        //                      width: 120,
                        //                      height: 120,
                        //
                        //                      child: Image.file(
                        //                        _.imageFile!,
                        //                        fit: BoxFit.cover,
                        //                      )),
                        //                ),
                        //                Positioned(
                        //                  right: -10,
                        //                  top: -5,
                        //                  child: IconButton(
                        //                    onPressed: () {
                        //                      _.pickUserProfileImage(context);
                        //                    },
                        //                    icon: Icon(Icons.camera_alt_outlined),
                        //                    color: Colors.white,
                        //                  ),
                        //                )
                        //              ]),
                        //            ),
                        //          ],
                        //        )
                        //        :
                        //       Stack(
                        //         children: [
                        //           Positioned(
                        //             bottom: -50,
                        //             child: Stack(
                        //                 clipBehavior: Clip.none, children: [
                        //               Container(
                        //                 height: 100,
                        //                 width: 100,
                        //                 decoration: BoxDecoration(
                        //                     borderRadius: BorderRadius.circular(100),
                        //                     color: Colors.tealAccent),
                        //                 child: Icon(Icons.camera_alt_outlined),
                        //               ),
                        //               Positioned(
                        //                 right: -10,
                        //                 top: -5,
                        //                 child: IconButton(
                        //                   onPressed: () {
                        //                     _.pickUserProfileImage(context);
                        //                   },
                        //                   icon: Icon(Icons.camera_alt_outlined),
                        //                   color: Colors.white,
                        //                 ),
                        //               )
                        //             ]),
                        //           ),
                        //         ],
                        //       );
                        // }),
                        reusableTextField(
                            _.textUser,
                            _.usericons,
                            _.passwordType = false,
                            _.userController,
                            _.userValidator),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                            _.textEmail,
                            _.emailicons,
                            _.passwordType = false,
                            _.emailController,
                            _.emailValidator),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                            _.textPass,
                            _.passicons,
                            _.passwordType = true,
                            _.passwordController,
                            _.passwordValidator),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: PasswordFieldValidator(
                            minLength: 8,
                            uppercaseCharCount: 2,
                            lowercaseCharCount: 1,
                            numericCharCount: 3,
                            specialCharCount: 2,
                            defaultColor: Colors.black,
                            successColor: Colors.green,
                            failureColor: Colors.red,
                            controller: passController,
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        signUpsignUpButton(context, _.titleSignup, () {
                          if (formkey.currentState!.validate()) {
                            LoginScreenContrroler.instance.signUpUser(
                                email: _.emailController.text,
                                password: _.passwordController.text,
                                userName: _.userController.text);
                            _.onLoginPressed();
                            Get.to(const PostScreen());
                          }
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
