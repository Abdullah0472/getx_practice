import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getx_practice/controller/loginScreenController.dart';
import 'package:getx_practice/screens/post_screen.dart';
import 'package:getx_practice/screens/user_screen.dart';
import 'package:getx_practice/screens/home_screens.dart';
import 'package:password_field_validator/password_field_validator.dart';

import 'package:get/get.dart';
import '../controller/imageScreenController.dart';
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
  Widget build(BuildContext context) {
    return GetBuilder<LoginScreenContrroler>(
        init: LoginScreenContrroler(),
        builder: (_) {
          return Form(
            key: formkey,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xffc82893),
                title: Text(
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
                decoration: BoxDecoration(
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
                        SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                            _.textEmail,
                            _.emailicons,
                            _.passwordType = false,
                            _.emailController,
                            _.emailValidator),
                        SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                            _.textPass,
                            _.passicons,
                            _.passwordType = true,
                            _.passwordController,
                            _.passwordValidator),
                        SizedBox(
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

                        SizedBox(
                          height: 20,
                        ),
                        signUpsignUpButton(context, _.titleSignup, () {
                          if (formkey.currentState!.validate()) {
                            LoginScreenContrroler.instance.signUpUser(
                                email: _.emailController.text,
                                password: _.passwordController.text,
                                userName: _.userController.text);
                            _.onLoginPressed();
                            Get.to(
                                PostScreen()
                            );
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
