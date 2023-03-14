import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/bloc/bloc.dart';
import 'package:social_app/bloc/states.dart';
import 'package:social_app/model/userModel.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/constants.dart';

class ChatScreen extends StatelessWidget {
  UserModel userModel;
  var controller = TextEditingController();

  ChatScreen({required this.userModel});

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        cubit.get(context).getMessages(receiverId: userModel.id);
        return BlocConsumer<cubit, States>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                elevation: 5.0,
                titleSpacing: 0.0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage("${userModel.profileImage}"),
                      radius: 25,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        "${userModel.name}",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ConditionalBuilder(
                        condition: cubit.get(context).messages.length > 0,
                        builder: (context) => Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                // physics: NeverScrollableScrollPhysics(),
                                // shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  if (id !=
                                      cubit
                                          .get(context)
                                          .messages[index]
                                          .senderId)
                                    return Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadiusDirectional.only(
                                              bottomEnd: Radius.circular(
                                                10.0,
                                              ),
                                              topStart: Radius.circular(
                                                10.0,
                                              ),
                                              topEnd: Radius.circular(
                                                10.0,
                                              ),
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 5.0,
                                            horizontal: 10.0,
                                          ),
                                          child: Wrap(children: [
                                            Text(
                                              "${cubit.get(context).messages[index].text}",
                                              style: TextStyle(
                                                fontSize: 17,
                                              ),
                                            )
                                          ]),
                                        ),
                                      ),
                                    );
                                  return Align(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadiusDirectional.only(
                                            bottomEnd: Radius.circular(
                                              10.0,
                                            ),
                                            topStart: Radius.circular(
                                              10.0,
                                            ),
                                            topEnd: Radius.circular(
                                              10.0,
                                            ),
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5.0,
                                          horizontal: 10.0,
                                        ),
                                        child: Wrap(children: [
                                          Text(
                                            "${cubit.get(context).messages[index].text}",
                                            style: TextStyle(
                                              fontSize: 17,
                                            ),
                                          )
                                        ]),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, state) => SizedBox(
                                  height: 5,
                                ),
                                itemCount: cubit.get(context).messages.length,
                              ),
                            ),
                          ],
                        ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: controller,
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Message can't be empty";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: Text("Message"),
                          ),
                        )),
                        SizedBox(
                          width: 7,
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height / 13,
                            child: MaterialButton(
                              color: Colors.black,
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              onPressed: () {
                                cubit.get(context).sendMessage(
                                      date: DateTime.now().toString(),
                                      text: controller.text,
                                      receiverId: userModel.id,
                                    );
                              },
                              child: Text(
                                "Send",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          listener: (context, state) {
            if (state is SuccessSendMessageState) {
              print("Success") ;
              cubit.get(context).sendNotifications(user: "${userModel.token}" , title: "${userModel.name}", body: controller.text);
            }
            ;
          },
        );
      },
    );
    // });
  }
}
