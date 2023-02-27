import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/bloc/bloc.dart';
import 'package:social_app/bloc/states.dart';
import 'package:social_app/shardprefrence/shardpref.dart';
import 'package:social_app/shared/components.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:social_app/pages/base.dart';
import 'package:social_app/pages/signup.dart';

class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  var formkey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passController = TextEditingController();

  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<cubit , States>(builder: (context , state)
        {
          return  Scaffold(
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
                          "Login",
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
                            suffixIcon: isPassword == true ? Icons.visibility : Icons
                                .visibility_off,
                            type: TextInputType.visiblePassword,
                            function: () {
                              setState(() {
                                isPassword = !isPassword;
                              });
                            }),
                        SizedBox(
                          height: 25,
                        ),
                        ConditionalBuilder(
                            condition:state is! LoadingLoginState,
                            builder:(context)=>  defaultButton(text: "Login", function: () {
                                if(formkey.currentState!.validate())
                                {
                                  cubit.get(context).login(email: emailController.text, password: passController.text) ;
                                }
                              }, context),

                            fallback:(context)=>Center(child: CircularProgressIndicator())),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forget password",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 17),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(
                                        builder: (context) => signup()), (
                                        route) => false);
                              },
                              child: Text(
                                "Signup",
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
        }, listener: (context , state){

      if(state is SuccessLoginState) {
        toast(message: "Login successfully") ;
        SharedPrefes.savedata(key: "login", value: true) ;
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => base()), (route) => false);
      }
      if( state is ErrorLoginState)
        toast(message:"Incorrect email or password" , color: Colors.red);

    }) ;
  }
}
