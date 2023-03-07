import 'package:flutter/material.dart';
import 'package:todos_app/components/global/buttonNavbar.c.dart';
//import 'package:todos_app/screens/index.s.dart';
import 'package:todos_app/screens/todos.s.dart';
import 'package:todos_app/screens/profile.s.dart';

class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  int currentPage = 0;
  static const List<Widget> views = [
    //IndexView(),
    TodosView(),
    ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: views[currentPage],
      bottomNavigationBar: ButtonNav(
        currentPage: currentPage,
        setCurrent: (int index) {
          setState(() {
            currentPage = index;
          });
        },
      ),
    );
  }
}
