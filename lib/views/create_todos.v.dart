import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todos_app/interfaces/todos.i.dart';
class CreateTodos extends StatefulWidget {
  const CreateTodos({super.key});

  @override
  State<CreateTodos> createState() => _CreateTodosState();
}

class _CreateTodosState extends State<CreateTodos> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
void postTodos(
   Todo todo,
){
  final String url = '${dotenv.env['HOSTAPI']!}/todos';
  http.post(Uri.parse(url), body: todo.toJson());

}

