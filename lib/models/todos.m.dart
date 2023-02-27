import 'dart:convert';
import 'package:todos_app/models/profile.m.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Todos {
  String? err;
  String? msg;
  List<Todo>? todos;
  static final String url = '${dotenv.env['HOSTAPI']!}/todos';
  Todos({this.err, this.msg, this.todos});
  static Future<Todos> getTodos() async {
    final response = await http.get(Uri.parse(url));
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
  CreatedBy? createdBy;

  Todo(
      {this.id,
      this.title,
      this.description,
      this.status,
      this.flags,
      this.createdBy});

  Todo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    flags = json['flags'].cast<String>();
    createdBy = json['createdBy'] != null
        ? CreatedBy.fromJson(json['createdBy'])
        : null;
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
    if (createdBy != null) {
      data['createdBy'] = createdBy!.toJson();
    }
    return data;
  }
}

class Status {
  bool isCompleted = false;
  DateTime? createdAt;

  Status({this.isCompleted = false, this.createdAt});

  Status.fromJson(Map<String, dynamic> json) {
    isCompleted = json['isCompleted'];
    createdAt = DateTime.tryParse(json['createdAt']) ?? DateTime.now();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isCompleted'] = isCompleted;
    data['createdAt'] = createdAt;
    return data;
  }
}

class CreatedBy {
  Profile? profile;

  CreatedBy({this.profile});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}
