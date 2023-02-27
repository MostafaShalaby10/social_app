import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/bloc/bloc.dart';
import 'package:social_app/bloc/states.dart';
import 'package:social_app/pages/base.dart';
import 'package:social_app/pages/login.dart';
import 'package:social_app/pages/signup.dart';
import 'package:social_app/shardprefrence/shardpref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await SharedPrefes.init();

  dynamic isLogin = SharedPrefes.getdata(key: "login");
  if (isLogin == null) {
    runApp(MyApp(start: signup()));
  } else {
    runApp(MyApp(start: base()));
  }
}

class MyApp extends StatelessWidget {
  final Widget start;

  MyApp({required this.start});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => cubit(),
      child: BlocConsumer<cubit, States>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: start,
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
