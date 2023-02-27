import 'package:flutter/material.dart';
import 'package:todos_app/models/todos.m.dart';

class TodosService extends StatefulWidget {
  const TodosService({super.key});
  @override
  State<TodosService> createState() => _TodosServiceState();
}

class _TodosServiceState extends State<TodosService> {
  late Future<Todos> todosObj;
  @override
  void initState() {
    super.initState();
    todosObj = Todos.getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Todos>(
      future: todosObj,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.todos!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data!.todos![index].title ?? ''),
                subtitle: Text(snapshot.data!.todos![index].description ?? ''),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          semanticsLabel: 'Loading',
        ));
      },
    );
  }
}
