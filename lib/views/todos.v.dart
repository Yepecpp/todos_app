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
    return Stack(
      children: [
        const TodosService(),
        Positioned(
          bottom: 0,
          right: 0,
          child: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
