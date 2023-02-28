// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:todos_app/services/todos.s.dart';

class TodosView extends StatefulWidget {
  const TodosView({super.key});
  @override
  State<TodosView> createState() => _TodosViewState();
}

class _TodosViewState extends State<TodosView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Stack(
            fit: StackFit.loose,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                child: IconButton(
                  onPressed: (() {}),
                  icon: Icon(Icons.add, color: Colors.red),
                ),
              )
            ],
          ),
          Text('Todos'),
          TodosService(),
        ],
      ),
    );
  }
}
