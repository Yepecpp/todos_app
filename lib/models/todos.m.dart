import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart' as local_s;

final String url = '${dotenv.env['HOSTAPI']!}/api/v1/todos';
local_s.LocalStorage storage = local_s.LocalStorage('auth');

class Todos {
  String? err;
  String? msg;
  List<Todo>? todos;
  Todos({this.err, this.msg, this.todos});
  static Future<Todos> getTodos() async {
    await storage.ready;
    final token = storage.getItem('token');
    final response = await http.get(
      Uri.parse(url),
      headers: {"authorization": "Bearer $token"},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load todos');
    }
    return Todos.fromJson(jsonDecode(response.body));
  }

  Todos.fromJson(Map<String, dynamic> json) {
    err = json['err'];
    msg = json['msg'];
    if (json['todos'] != null) {
      todos = <Todo>[];
      json['todos'].forEach((v) {
        todos!.add(Todo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['err'] = err;
    data['msg'] = msg;
    if (todos != null) {
      data['todos'] = todos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Todo {
  String? id;
  String? title;
  String? description;
  Status? status;
  List<String>? flags;

  Todo({
    this.id,
    this.title,
    this.description,
    this.status,
    this.flags,
  });

  Todo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    flags = json['flags']!.cast<String>();
  }
  Future<Map<String, dynamic>> modifyTodo() async {
    final data = toJson();
    await storage.ready;
    final token = storage.getItem('token');
    final http.Response response = await (id != null
        ? http.put(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              "authorization": "Bearer $token"
            },
            body: jsonEncode({'todo': data}),
          )
        : http.post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              "authorization": "Bearer $token"
            },
            body: jsonEncode({'todo': data}),
          ));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'todo': Todo.fromJson(jsonDecode(response.body)['todo']),
        'status': response.statusCode
      };
    }
    debugPrint('failed to modify todo: ${response.body}');
    return {'todo': this, 'status': response.statusCode};
  }

  Future<bool> deleteTodo() async {
    final data = toJson();
    await storage.ready;
    final token = storage.getItem('token');
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        "authorization": "Bearer $token"
      },
      body: jsonEncode({'todo': data}),
    );
    if (response.statusCode != 200) {
      debugPrint('failed to delete todo: ${response.body}');
      return false;
    }
    return true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    data['flags'] = flags;
    return data;
  }
}

class Status {
  bool isCompleted = false;
  DateTime? createdAt;
  DateTime? completedAt;
  Status({this.isCompleted = false, this.createdAt, this.completedAt});

  Status.fromJson(Map<String, dynamic> json) {
    isCompleted = json['isCompleted'];
    createdAt = DateTime.tryParse(json['createdAt']) ?? DateTime.now();
    completedAt = DateTime.tryParse(json['completedAt'] ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isCompleted'] = isCompleted;
    data['createdAt'] = createdAt!.toIso8601String();
    data['completedAt'] = completedAt?.toIso8601String();
    return data;
  }
}
