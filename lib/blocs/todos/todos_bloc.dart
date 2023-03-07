import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos_app/models/todos.m.dart';
part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc() : super(const TodosInitial()) {
    on<TodosEvent>((event, emit) {});
    on<TodosEventInitial>((event, emit) async {
      emit(const TodosLoaded(
        isLoading: true,
      ));
      final Todos todos = await event.getTodos();
      if (todos.err != null) {
        emit(TodosLoaded(todos: todos));
      } else {
        emit(TodosLoaded(todos: todos, isLoading: false, err: todos.err));
      }
    });
    on<TodosEventRefresh>((event, emit) async {
      emit(const TodosLoaded(
        isLoading: true,
      ));
      final Todos todos = await event.getTodos();
      if (todos.err != null) {
        emit(TodosLoaded(todos: todos));
      } else {
        emit(TodosLoaded(todos: todos, isLoading: false, err: todos.err));
      }
    });
    on<TodosEventDelete>(((event, emit) async {
      if (state is TodosLoaded == false) {
        return;
      }
      final todo = state as TodosLoaded;
      if (todo.todos == null) {
        return;
      }
      if (todo.isLoading || todo.err != null) {
        return;
      }
      final result = await event.todo.deleteTodo();
      if (!result) {
        emit(TodosLoaded(todos: todo.todos, isLoading: false));
        return;
      }
      todo.todos!.todos = todo.todos!.todos!.where((Todo todo) {
        return todo.id != event.todo.id;
      }).toList();
      emit(TodosLoaded(todos: todo.todos, isLoading: false));
    }));
    on<TodosEventModify>(((event, emit) async {
      if (state is TodosLoaded == false) {
        return;
      }
      final todo = state as TodosLoaded;
      if (todo.todos == null) {
        return;
      }
      if (todo.isLoading || todo.err != null) {
        return;
      }
      final newTodo = await event.todo.modifyTodo();
      if (newTodo['status'] > 202) {
        emit(TodosLoaded(todos: todo.todos, isLoading: false));
        return;
      }
      todo.todos!.todos = todo.todos!.todos!.map((Todo todo) {
        if (todo.id == newTodo['todo']!.id) {
          return event.todo;
        }
        return todo;
      }).toList();
      emit(TodosLoaded(todos: todo.todos, isLoading: false));
    }));
  }
}
