import 'dart:ffi';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/api/api.dart';
import 'package:social_app/bloc/states.dart';
import 'package:social_app/model/messageModel.dart';
import 'package:social_app/model/postModel.dart';
import 'package:social_app/model/userModel.dart';
import 'package:social_app/pages/chats.dart';
import 'package:social_app/pages/home.dart';
import 'package:social_app/pages/profile.dart';
import 'package:social_app/shardprefrence/shardpref.dart';
import 'package:social_app/shared/constants.dart';

class cubit extends Cubit<States> {
  cubit() : super(InitialState());

  static cubit get(context) => BlocProvider.of(context);
  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
    BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: "Chats"),
  ];
  List pages = [home(), profile(), chats()];
  List labels = ["Home", "Profile", "Chats"];
  UserModel? userModel;

  int currentIndex = 0;

  void changeBottom(int index) {
    currentIndex = index;
    if (currentIndex == 2) getUsers();
    emit(ChangeBottomBar());
  }

  void signup({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(LoadingSignupState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
          print("signup success");
      createUser(
        name: name,
        email: email,
        id: value.user!.uid,
        phone: phone,
        token: await FirebaseMessaging.instance.getToken(),
      );
      print("after create user") ;
      emit(SuccessSignupState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorSignupState());
    });
  }

  void createUser({
    required String name,
    required String email,
    required String id,
    required String phone,
     dynamic token,
  }) {
    userModel = UserModel(
      email: email,
      name: name,
      id: id,
      phone: phone,
      token: token,
      bio: "Write something about you",
      coverImage:
          "https://img.freepik.com/free-photo/solid-maroon-concrete-textured-wall_53876-95067.jpg?w=996&t=st=1677874794~exp=1677875394~hmac=e65d31fd0f6c57d564e477af90712f42545cb65e3fe20a2717d281d5d93a070c",
      profileImage:
          "https://img.freepik.com/free-photo/bohemian-man-with-his-arms-crossed_1368-3542.jpg?w=740&t=st=1677874707~exp=1677875307~hmac=bb2263da613e46addfff827f2aa404c192b3ac7b1707f7442dcc7de4b5d459f0",
    );
    print("in create user 1");
    emit(LoadingCreateUserState());
    FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .set(userModel!.tomap())
        .then((value) {
      print("Create user successfully");
      emit(SuccessCreateUserState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCreateUserState());
    });
  }

  void login({
    required String email,
    required String password,
  }) {
    emit(LoadingLoginState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      SharedPrefes.savedata(key: "UID", value: value.user!.uid);
      emit(SuccessLoginState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorLoginState());
    });
  }

  void getUserData() {
    // profileFlag =false ;
    // coverFlag =false ;
    emit(LoadingGetUserDataState());
    FirebaseFirestore.instance
        .collection("Users")
        .doc(SharedPrefes.getdata(key: "UID"))
        .get()
        .then((value) async {
      name = value.data()!['name'];
      phone = value.data()!['phone'];
      bio = value.data()!['bio'];

      id = value.data()!['id'];
      profileImageConst = value.data()!['profileImage'];
      coverImageConst = value.data()!['coverImage'];
      print(profileImageConst);
      print(coverImageConst);
      emit(SuccessGetUserDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorGetUserDataState());
    });
  }

  File? profileImage;
  File? postImage;

  File? coverImage;

  var picker = ImagePicker();

  Future<void> changeProfilePhoto() async {
    final profilePhoto = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (profilePhoto != null) {
      profileImage = File(profilePhoto.path);
      uploadProfileImage();
      emit(SuccessGetProfileImageState());
    } else {
      print("There is no image");
      emit(ErrorGetProfileImageState());
    }
  }

  Future<void> changeCoverPhoto() async {
    final coverPhoto = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (coverPhoto != null) {
      coverImage = File(coverPhoto.path);
      uploadCoverImage();
      emit(SuccessGetCoverImageState());
    } else {
      print("There is no image");
      emit(ErrorGetCoverImageState());
    }
  }

  Future<void> addPostPhotoGallery() async {
    final postPhoto = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (postPhoto != null) {
      postImage = File(postPhoto.path);
      uploadPostImage();
      emit(SuccessGetPostImageGalleryState());
    } else {
      print("There is no image");
      emit(ErrorGetPostImageGalleryState());
    }
  }

  Future<void> addPostPhotoCamera() async {
    final postPhoto = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (postPhoto != null) {
      postImage = File(postPhoto.path);
      uploadPostImage();
      // emit(SuccessGetPostImageCameraState());
    } else {
      print("There is no image");
      // emit(ErrorGetPostImageCameraState());
    }
  }

  String? profileURL;
  String? postURL;
  String? coverURL;

  void uploadProfileImage() {
    // profileFlag = true ;
    emit(LoadingUploadProfileImageState());
    FirebaseStorage.instance
        .ref()
        .child("Users/${Uri.file(profileImage!.path).pathSegments.last}")
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        profileURL = value;
        print("Profile URL is : ${profileURL}");
        emit(SuccessUploadProfileImageState());
      }).catchError((error) {
        print(error.toString());
        emit(ErrorUploadProfileImageState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(ErrorUploadProfileImageState());
    });
  }

  void uploadCoverImage() {
    // coverFlag = true ;
    emit(LoadingUploadCoverImageState());
    FirebaseStorage.instance
        .ref()
        .child("Users/${Uri.file(coverImage!.path).pathSegments.last}")
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        coverURL = value;
        print("Cover URL IS : ${coverURL}");
        emit(SuccessUploadCoverImageState());
      }).catchError((error) {
        print(error.toString());
        emit(ErrorUploadCoverImageState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(ErrorUploadCoverImageState());
    });
  }

  void updateData({
    required String name,
    required String phone,
    required String bio,
  }) async {
    // uploadCoverImage();
    emit(LoadingUpdateDataState());
    //  uploadProfileImage();
    // print("fasiasjkashfifailjflasjdsa");
    FirebaseFirestore.instance
        .collection("Users")
        .doc(SharedPrefes.getdata(key: "UID"))
        .update({
      "name": name,
      "phone": phone,
      "bio": bio,
      "profileImage": profileURL ?? profileImageConst,
      "coverImage": coverURL ?? coverImageConst,
    }).then((value) {
      print("Update success");
      emit(SuccessUpdateDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorUpdateDataState());
    });
  }

  void uploadPostImage() {
    emit(LoadingUploadPostImageState());
    FirebaseStorage.instance
        .ref()
        .child("Posts/${Uri.file(postImage!.path).pathSegments.last}")
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        postURL = value;
        print("Post URL is : ${postURL}");
        emit(SuccessUploadPostImageState());
      }).catchError((error) {
        print(error.toString());
        emit(ErrorUploadPostImageState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(ErrorUploadPostImageState());
    });
  }

  PostModel? postModel;

  void createPost({
    required String date,
    required String text,
  }) {
    emit(LoadingCreatePostState());
    postModel = PostModel(
      name: name,
      id: id,
      dateTime: date,
      photo: profileImageConst,
      postPhoto: postURL ?? "",
      text: text,
    );
    FirebaseFirestore.instance
        .collection("Posts")
        .add(postModel!.tomap())
        .then((value) {
      print("Create post successfully");
      removePostImage();
      emit(SuccessCreatePostState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCreatePostState());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(SuccessRemovePostImageState());
  }

  List<dynamic> posts = [];
  List<dynamic> users = [];

  void getPosts() {
    emit(LoadingGetPostState());
    FirebaseFirestore.instance
        .collection("Posts")
        .orderBy("dateTime")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        posts.add(PostModel.fromjson(element.data()));
      });
      emit(SuccessGetPostState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorGetPostState());
    });
  }

  void getUsers() {
    emit(LoadingGetUsersState());
    users = [];
    FirebaseFirestore.instance.collection("Users").get().then((value) {
      value.docs.forEach((element) {
        if (id != element.data()["id"])
          users.add(UserModel.fromjson(element.data()));
      });
      emit(SuccessGetUsersState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorGetUsersState());
    });
  }

  MessageModel? messageModel;

  void sendMessage({
    required String date,
    required String text,
    String? receiverId,
  }) {
    messageModel = MessageModel(
      date: date,
      text: text,
      receiverId: receiverId,
      senderId: id,
    );
    FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .collection("Chats")
        .doc(receiverId)
        .collection("Messages")
        .add(messageModel!.tomap())
        .then((value) {
      emit(SuccessSendMessageState());
    }).catchError((error) {
      emit(ErrorSendMessageState());
    });

    FirebaseFirestore.instance
        .collection("Users")
        .doc(receiverId)
        .collection("Chats")
        .doc(id)
        .collection("Messages")
        .add(messageModel!.tomap())
        .then((value) {
      emit(SuccessSendMessageState());
    }).catchError((error) {
      emit(ErrorSendMessageState());
    });
  }

  List<dynamic> messages = [];

  void getMessages({
    String? receiverId,
  }) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .collection("Chats")
        .doc(receiverId)
        .collection("Messages")
        .orderBy("date")
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromjson(element.data()));
      });
      // emit(SuccessGetMessageState());
    });
  }

  void sendNotifications({
    required String user ,
    required String title,
    required String body,
  }) {
    emit(LoadingSendNotificationsState());
    Api.post(user: user, title: title, body: body).then((value)
    {
      print("Send message Successfully") ;
      emit(SuccessSendNotificationsState());
    }).catchError((error){
      emit(ErrorSendNotificationsState());
    });
  }
  void notifications()
  {
    FirebaseMessaging.onMessage.listen((event) {
      print("Event :  ${event.data.toString()}");
      print("Event :  ${event.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("Event :  ${event.data.toString()}");
      print("Event :  ${event.notification?.title}");
    });
  }
}
