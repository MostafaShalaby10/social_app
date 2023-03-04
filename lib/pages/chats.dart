import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/bloc/bloc.dart';
import 'package:social_app/bloc/states.dart';
import 'package:social_app/model/userModel.dart';
import 'package:social_app/pages/chat_screen.dart';

class chats extends StatelessWidget {
late UserModel userModel ;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<cubit, States>(
        builder: (context, state) {
          return Scaffold(
            body: ConditionalBuilder(
              builder: (context)=>SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => buildChatItem(cubit.get(context).users[index], context),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  ),
                  itemCount: cubit.get(context).users.length,
                ),
              ),
              condition: state is! LoadingGetUsersState,
              fallback: (context)=>Center(child: CircularProgressIndicator()),
            ),
          );
        },
        listener: (context, state) {});
  }
Widget buildChatItem(UserModel model, context) => InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>ChatScreen(
        userModel: model,
      ),)
    );
  },
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 25.0,
          backgroundImage: NetworkImage(
            '${model.profileImage}',
          ),
        ),
        SizedBox(
          width: 15.0,
        ),
        Text(
          '${model.name}',
          style: TextStyle(
            height: 1.4,
          ),
        ),
      ],
    ),
  ),
);

}

