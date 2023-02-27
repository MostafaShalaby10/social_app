import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/bloc/bloc.dart';
import 'package:social_app/bloc/states.dart';
import 'package:social_app/pages/base.dart';
import 'package:social_app/pages/profile.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/constants.dart';

class EditProfile extends StatelessWidget {
  Widget build(BuildContext context) {
    var profileImage = cubit.get(context).profileImage;
    var coverImage = cubit.get(context).coverImage;
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var bioController = TextEditingController();
    var formkey = GlobalKey<FormState>();
    return BlocConsumer<cubit, States>(builder: (context, state) {
      nameController.text = name;
      phoneController.text = phone;
      bioController.text = bio;

      return Scaffold(
        body: SafeArea(
          child: ConditionalBuilder(
            condition: state is! LoadingUploadProfileImageState ||
                state is! LoadingUploadCoverImageState,
            builder: (context) => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 3.5,
                        child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Align(
                              child: Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        image: DecorationImage(
                                            image: coverImage != null
                                                ? FileImage(coverImage)
                                                : NetworkImage(coverImageConst)
                                                    as ImageProvider,
                                            fit: BoxFit.cover)),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      cubit.get(context).changeCoverPhoto();
                                    },
                                    icon: CircleAvatar(
                                      child: Icon(
                                        Icons.mode_edit_outlined,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              alignment: AlignmentDirectional.topCenter,
                            ),
                            Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: profileImage != null
                                      ? FileImage(profileImage)
                                      : NetworkImage(profileImageConst)
                                          as ImageProvider,
                                ),
                                IconButton(
                                  onPressed: () {
                                    cubit.get(context).changeProfilePhoto();
                                  },
                                  icon: CircleAvatar(
                                    child: Icon(
                                      Icons.mode_edit_outlined,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      editBox(
                        isPassword: false,
                        text: "Bio",
                        prefixIcon: Icons.cloud,
                        type: TextInputType.text,
                        controller: bioController,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      editBox(
                          isPassword: false,
                          text: "Name",
                          prefixIcon: Icons.person_outline,
                          type: TextInputType.name,
                          controller: nameController),
                      SizedBox(
                        height: 20,
                      ),
                      editBox(
                          isPassword: false,
                          text: "phone",
                          prefixIcon: Icons.phone_outlined,
                          type: TextInputType.phone,
                          controller: phoneController),
                      SizedBox(
                        height: 30,
                      ),
                        defaultButton(context, text: "Update",
                            function: () {
                          if (formkey.currentState!.validate()) {
                            // cubit.get(context).uploadProfileImage();
                            cubit.get(context).updateData(
                                  phone: phoneController.text,
                                  name: nameController.text,
                                  bio: bioController.text,
                                );
                          }
                        }),
                    ],
                  ),
                ),
              ),
            ),
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }, listener: (context, state) {
      if (state is SuccessUpdateDataState) {
        toast(message: "Update Successfully");
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => base()), (route) => false);
      } else if (state is ErrorUpdateDataState) {
        toast(message: "Update Failed");
      }
    });
  }
}
