import 'package:flutter/material.dart';
import 'package:todos_app/components/login/Input.c.dart';
import 'package:todos_app/models/todos.m.dart';

class AddTodoPopup extends StatefulWidget {
  final Todo todo;
  final Function(Todo) addTodo;
  const AddTodoPopup({super.key, required this.todo, required this.addTodo});

  @override
  State<AddTodoPopup> createState() => _AddTodoPopupState();
}

class _AddTodoPopupState extends State<AddTodoPopup> {
  final key = GlobalKey<FormState>();
  bool validate() {
    return key.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: const Text('Add Todo'),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputFormText(
                        setInput: (value) {
                          widget.todo.title = value;
                        },
                        validate: validate,
                        label: 'Title',
                        initialValue: widget.todo.title ?? "",
                        icon: const Icon(Icons.title),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        }),
                    InputFormText(
                        setInput: (value) {
                          widget.todo.description = value;
                        },
                        validate: validate,
                        label: 'Description',
                        initialValue: widget.todo.description ?? "",
                        icon: const Icon(Icons.description),
                        max: 6,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        }),
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: AlignmentGeometry.lerp(
                        Alignment.topLeft,
                        Alignment.centerRight,
                        0.9,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (validate()) {
                            widget.addTodo(widget.todo);
                            Navigator.pop(context);
                          }
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
