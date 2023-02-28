part of 'todos_bloc.dart';

@immutable
abstract class TodosEvent {
  Future<Todos> getTodos() async {
    return await Todos.getTodos();
  }
}

class TodosEventInitial extends TodosEvent {
  TodosEventInitial();
}

class TodosEventRefresh extends TodosEvent {
  TodosEventRefresh();
}

class TodosEventModify extends TodosEvent {
  final Todo todo;
  TodosEventModify(
    this.todo,
  );
}

class TodosEventDelete extends TodosEvent {
  final Todo todo;
  TodosEventDelete(
    this.todo,
  );
}
