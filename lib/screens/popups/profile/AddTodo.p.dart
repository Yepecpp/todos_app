import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:todos_app/components/login/Input.c.dart';
import 'package:todos_app/models/todos.m.dart';

const flags = [
  'Important',
  'Urgent',
  'Private',
  'Public',
  'Completed',
  'Incomplete',
  'Renegated'
];

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
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: MultiSelectDialogField(
                          initialValue:
                              widget.todo.flags ?? List<String>.empty(),
                          itemsTextStyle: GoogleFonts.rubik(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          selectedItemsTextStyle: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          searchable: true,
                          searchIcon: const Icon(Icons.search),
                          listType: MultiSelectListType.CHIP,
                          items: flags
                              .map((e) =>
                                  MultiSelectItem<String>(e.toLowerCase(), e))
                              .toList(),
                          title: const Text("Flags"),
                          selectedColor: Colors.black,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red.shade900,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          buttonIcon: const Icon(
                            Icons.flag,
                            color: Colors.red,
                          ),
                          buttonText: Text(
                            "Select Flags",
                            style: GoogleFonts.rubik(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          onConfirm: (results) {
                            widget.todo.flags = results;
                          },
                        ),
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
