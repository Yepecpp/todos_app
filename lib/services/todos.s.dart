import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app/blocs/todos/todos_bloc.dart';

class TodosService extends StatefulWidget {
  const TodosService({super.key});

  @override
  State<TodosService> createState() => _TodosServiceState();
}

class _TodosServiceState extends State<TodosService> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodosBloc, TodosState>(
      builder: (context, state) {
        if (state is TodosInitial) {
          context.read<TodosBloc>().add(TodosEventInitial());
          return const Center(child: Center(child: Text('No todos yet')));
        }
        final todosState = state as TodosLoaded;
        if (todosState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              semanticsLabel: 'Loading',
            ),
          );
        }
        if (todosState.err != null) {
          return Text(todosState.err!);
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: todosState.todos!.todos!.length,
          itemBuilder: (context, index) {
            final todo = todosState.todos!.todos![index];
            return ListTile(
                title: Text(todo.title ?? ''),
                subtitle: Text(todo.description ?? ''),
                leading: Checkbox(
                    value: todo.status!.isCompleted,
                    onChanged: (value) {
                      todo.status!.isCompleted = value!;
                      context.read<TodosBloc>().add(TodosEventModify(todo));
                    }),
                trailing: IconButton(
                  icon: const Icon(CupertinoIcons.trash, color: Colors.red),
                  onPressed: () {
                    context.read<TodosBloc>().add(TodosEventDelete(todo));
                  },
                ));
          },
        );
      },
    );
  }
}
