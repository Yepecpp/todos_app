// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app/models/todos.m.dart';
import 'package:todos_app/screens/popups/profile/AddTodo.p.dart';
import 'package:todos_app/services/todos.s.dart';

import '../blocs/todos/todos_bloc.dart';

class TodosView extends StatefulWidget {
  const TodosView({super.key});
  @override
  State<TodosView> createState() => _TodosViewState();
}

class _TodosViewState extends State<TodosView> {
  @override
  Widget build(BuildContext context) {
    addTodo(Todo todo) {
      context.read<TodosBloc>().add(TodosEventModify(todo));
    }

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text('Todos'),
                ),
                TodosService(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: AlignmentGeometry.lerp(
              Alignment.topLeft,
              Alignment.centerRight,
              0.9,
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddTodoPopup(
                      addTodo: addTodo,
                      todo: Todo(),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
              ),
              child: const Text('Add Todo'),
            ),
          ),
        ],
      ),
    );
  }
}
