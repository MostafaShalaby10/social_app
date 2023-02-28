import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/bloc/bloc.dart';
import 'package:social_app/bloc/states.dart';
import 'package:social_app/pages/base.dart';
import 'package:social_app/shared/constants.dart';

import '../shared/components.dart';

class NewPost extends StatelessWidget {
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<cubit, States>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            actions: [
              TextButton(
                  onPressed: () {
                    cubit.get(context).createPost(
                        text: controller.text ?? "",
                        date: DateTime.now().toString());
                  },
                  child: Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(profileImageConst),
                      radius: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              Icon(
                                Icons.verified,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            DateTime.now().toString(),
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.more_horiz_outlined),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      controller: controller,
                      maxLines: 2,
                      decoration: InputDecoration(
                          hintText: "What's happening", border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (cubit.get(context).postImage != null)
                  Expanded(
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Image(
                          image:
                              FileImage(cubit.get(context).postImage as File),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 7, right: 4),
                          child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.black,
                              child: IconButton(
                                  onPressed: () {
                                    cubit.get(context).removePostImage();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    size: 15,
                                  ))),
                        )
                      ],
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          cubit.get(context).addPostPhotoGallery();
                        },
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  cubit.get(context).addPostPhotoGallery();
                                },
                                icon: Icon(Icons.photo_library)),
                            Text("Photos")
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          cubit.get(context).addPostPhotoCamera();
                        },
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                cubit.get(context).addPostPhotoCamera();
                              },
                              icon: Icon(Icons.camera_alt),
                            ),
                            Text("Camera")
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is SuccessCreatePostState) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => base()),
              (route) => false);
          toast(message: "Create Post successfully");
        } else if (state is ErrorCreatePostState) {
          toast(message: "Create Post failed", color: Colors.red);
        }
      },
    );
  }
}
