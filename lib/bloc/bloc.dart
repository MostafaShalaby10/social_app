import 'dart:ffi';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/bloc/states.dart';
import 'package:social_app/model/userModel.dart';
import 'package:social_app/pages/chats.dart';
import 'package:social_app/pages/home.dart';
import 'package:social_app/pages/profile.dart';
import 'package:social_app/pages/settings.dart';
import 'package:social_app/shardprefrence/shardpref.dart';
import 'package:social_app/shared/components.dart';
import 'package:social_app/shared/constants.dart';

class cubit extends Cubit<States> {
  cubit() : super(InitialState());

  static cubit get(context) => BlocProvider.of(context);
  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
    BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: "Chats"),
    BottomNavigationBarItem(
        icon: Icon(Icons.settings_outlined), label: "Settings"),
  ];
  List pages = [home(), profile(), chats(), settings()];
  List labels = ["Home", "Profile", "Chats", "Settings"];
  UserModel? userModel;

  int currentIndex = 0;

  void changeBottom(int index) {
    currentIndex = index;
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
        .then((value) {
      print("1");
      createUser(
        name: name,
        email: email,
        id: value.user!.uid,
        phone: phone,
      );
      print("2");
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
  }) {
    userModel = UserModel(
      email: email,
      name: name,
      id: id,
      phone: phone,
    );
    print("hdqwhbwqdwqkjnkjsdan");
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
        .then((value) {
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

  String? profileURL;
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
  }) async{
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
      print("Update success") ;
      emit(SuccessUpdateDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorUpdateDataState());
    });
  }
}
