import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_practice/screens/post_screen.dart';
import 'package:getx_practice/screens/user_screen.dart';
import 'package:getx_practice/screens/home_screens.dart';
import 'package:getx_practice/screens/signup_screens.dart';
import '../controller/loginScreenController.dart';
import '../utils/utils.dart';
import '../widgets/reuseable_widgets.dart';
import 'package:password_field_validator/password_field_validator.dart';

class LoginScree extends StatelessWidget {
  LoginScree({Key? key}) : super(key: key);
  // GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginScreenContrroler>(
        init: LoginScreenContrroler(),
        builder: (_) {
          return Form(
            key: _.formkey,
            child: Scaffold(
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
                child: Column(
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    reusableTextField(
                      _.textEmail,
                      _.emailicons,
                      _.passwordType = false,
                      _.emailController,
                      _.emailValidator,
                    ),
                    SizedBox(
                      height: 25,
                    ),

                    reusableTextField(
                        _.textEmail,
                        _.passicons,
                        _.passwordType = true,
                        _.passwordController,
                        _.passwordValidator),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: PasswordFieldValidator(
                        minLength: 12,
                        uppercaseCharCount: 2,
                        lowercaseCharCount: 5,
                        numericCharCount: 3,
                        specialCharCount: 2,
                        defaultColor: Colors.black,
                        successColor: Colors.green,
                        failureColor: Colors.red,
                        controller: _.passwordController,
                      ),
                    ),

                    signUpsignUpButton(context, _.titleLogin, () async {
                      if (_.formkey.currentState!.validate()) {
                    bool status =   await _.loginUser(
                            email: _.emailController.text,
                            password: _.passwordController.text);
                        _.onLoginPressed();
                        if(status){
                          Get.to(PostScreen());

                        }
                        else {
                          utils().toastmessage("Failed to Login");
                        }

                      }
                    }),

                    signupOption(),

                  ],
                ),
              ),
            ),
          );
        });
  }

  Row signupOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an Account?  ",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(SignUpScreen());
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
