part of 'todos_bloc.dart';

@immutable
abstract class TodosState {
  const TodosState();
}

class TodosInitial extends TodosState {
  final Todos? todos;
  const TodosInitial({this.todos});
}

class TodosLoaded extends TodosState {
  final bool isLoading;
  final Todos? todos;
  final String? err;
  const TodosLoaded({this.todos, this.isLoading = false, this.err});
}
