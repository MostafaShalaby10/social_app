import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/bloc/bloc.dart';
import 'package:social_app/bloc/states.dart';
import 'package:social_app/pages/login.dart';
import 'package:social_app/shardprefrence/shardpref.dart';

class base extends StatelessWidget {
  const base({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => cubit()..getPosts() ..getUserData()  ,
      child: BlocConsumer<cubit, States>(
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Text(
                    cubit.get(context).labels[cubit.get(context).currentIndex],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  actions: [

                    IconButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>login()), (route) => false);
                        SharedPrefes.removedata(key: "login") ;
                      },
                      icon: Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  unselectedItemColor: Colors.blue,
                  selectedItemColor: Colors.black,
                  items: cubit.get(context).items,
                  currentIndex: cubit.get(context).currentIndex,
                  onTap: (value) {
                    cubit.get(context).changeBottom(value);
                  },
                ),
                body: ConditionalBuilder(
                  builder: (context) =>
                      cubit.get(context).pages[cubit.get(context).currentIndex],
                  condition: state is! LoadingGetUserDataState,
                  fallback: (context) =>
                      Center(child: CircularProgressIndicator()),
                ));
          },
          listener: (context, state) {}),
    );
  }
}
