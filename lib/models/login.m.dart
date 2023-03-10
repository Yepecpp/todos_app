import 'package:localstorage/localstorage.dart' as local_s;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todos_app/utils/biometric.dart';
import 'auth.m.dart';

class ILogin {
  String username;
  String password;
  String? token;
  final storage = local_s.LocalStorage('auth');
  static final url = '${dotenv.env['HOSTAPI']}/api/v1/auth';

  ILogin({required this.username, required this.password});
  Future<Auth> getAuth() async {
    if (token == null) {
      debugPrint('estabamos muerto');
      await storage.ready;
      token = storage.getItem('token');
      if (token == null) {
        debugPrint('siempre estabamos muerto');
        return Auth();
      }
    }
    if (!await bioAuth()) {
      return Auth();
    }

    final resp = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "authorization": "Bearer $token"
    });
    if (resp.statusCode == 200) {
      debugPrint('tamo vivo');
      return Auth.fromJson(jsonDecode(resp.body));
    } else {
      debugPrint('estabamos vivo');
      storage.deleteItem('token');
      return Auth();
    }
  }

  Future<Auth> login() async {
    Auth auth = Auth(status: 400);

    if (username.isEmpty || password.isEmpty) {
      return auth;
    }
    var resp = await http.post(
      Uri.parse('$url/login'),
      body: jsonEncode({
        'login': {
          'username': username,
          'password': password,
        }
      }),
      headers: {"Content-Type": "application/json"},
    );
    //debugPrint(resp.body);
    auth = Auth.fromJson(jsonDecode(resp.body), status: resp.statusCode);
    if (auth.status == 200) {
      debugPrint("Login successful");
      debugPrint(auth.user!.name);
      storage.setItem('token', auth.token);
    } else {
      debugPrint(resp.body);
    }
    return auth;
  }
}
