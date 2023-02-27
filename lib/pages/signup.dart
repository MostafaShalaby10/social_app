import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/bloc/bloc.dart';
import 'package:social_app/bloc/states.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/pages/login.dart';

class signup extends StatefulWidget {
  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  var formkey = GlobalKey<FormState>();

  var nameController = TextEditingController();

  var emailController = TextEditingController();

  var confPassController = TextEditingController();

  var phoneController = TextEditingController();

  var passController = TextEditingController();

  bool isPassword = true;
  bool isPasswordConf = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<cubit, States>(
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Signup",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      editBox(
                          isPassword: false,
                          controller: nameController,
                          text: "Name",
                          type: TextInputType.text,
                          prefixIcon: Icons.person_outline),
                      SizedBox(
                        height: 20,
                      ),
                      editBox(
                          isPassword: false,
                          text: "Email",
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined),
                      SizedBox(
                        height: 20,
                      ),
                      editBox(
                          isPassword: isPassword,
                          text: "Password",
                          controller: passController,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: isPassword == true
                              ? Icons.visibility
                              : Icons.visibility_off,
                          type: TextInputType.visiblePassword,
                          function: () {
                            setState(() {
                              isPassword = !isPassword;
                            });
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      editBox(
                          isPassword: isPasswordConf,
                          text: "ConfPassword",
                          controller: confPassController,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: isPasswordConf == true
                              ? Icons.visibility
                              : Icons.visibility_off,
                          type: TextInputType.visiblePassword,
                          function: () {
                            setState(() {
                              isPasswordConf = !isPasswordConf;
                            });
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      editBox(
                          isPassword: false,
                          text: "Phone",
                          type: TextInputType.phone,
                          controller: phoneController,
                          prefixIcon: Icons.phone_outlined),
                      SizedBox(
                        height: 25,
                      ),
                      ConditionalBuilder(
                        condition: state is! LoadingSignupState,
                        builder: (context) => Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 13,
                          child: defaultButton(
                            context,
                              text: "Signup",
                              function: () {
                                if (formkey.currentState!.validate()) {
                                  if (passController.text ==
                                      confPassController.text) {
                                    cubit.get(context).signup(
                                        email: emailController.text,
                                        password: passController.text,
                                        name: nameController.text,
                                        phone: phoneController.text);
                                  }
                                }
                              }),
                        ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          Text(
                            "already have an account?",
                            style: TextStyle(
                              fontSize: 17,
                            ),
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
                                  fontWeight: FontWeight.w700, fontSize: 17),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if(state is SuccessSignupState) {
toast(message: "Created account successfully");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => login()),
              (route) => false);

        }
        if(state is ErrorSignupState)
          toast(message: "Created account failed" , color: Colors.red);

      },
    );
  }
}
