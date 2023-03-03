import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/bloc/bloc.dart';
import 'package:social_app/bloc/states.dart';

class chats extends StatelessWidget {
  const chats({Key? key}) : super(key: key);

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
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "${cubit.get(context).users[index].profileImage}"),
                              radius: 25,
                            ),
                            SizedBox(width: 15,) ,
                            Expanded(
                              child: Text(
                                "${cubit.get(context).users[index].name}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
}
