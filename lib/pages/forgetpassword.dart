import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/pages/login.dart';
import 'package:social_app/shared/components.dart';

class ForgetPassword extends StatelessWidget {
  var formkey = GlobalKey<FormState>();
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    editBox(
                        isPassword: false,
                        text: "E-mail",
                        controller: controller,
                        function: () {},
                        type: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined),
                    SizedBox(
                      height: 25,
                    ),
                    defaultButton(context, text: "Reset Password",
                        function: () {
                      if (formkey.currentState!.validate()) {
                        FirebaseAuth.instance
                            .sendPasswordResetEmail(email: controller.text)
                            .then((value) {
                          Fluttertoast.showToast(
                            msg: "Check your email",
                            backgroundColor: Colors.green,
                            toastLength: Toast.LENGTH_SHORT,
                            textColor: Colors.white,
                            timeInSecForIosWeb: 1,
                            gravity: ToastGravity.BOTTOM,
                          );
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => login()),
                              (route) => false);
                        }).catchError((error) {
                          print(error.toString());
                        });
                      }
                    }),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Remember password",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => login()),
                                  (route) => false);
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
