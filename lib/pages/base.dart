import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/bloc/bloc.dart';
import 'package:social_app/bloc/states.dart';

class base extends StatelessWidget {
  const base({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => cubit()..getUserData() ,
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
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.search_outlined,
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
