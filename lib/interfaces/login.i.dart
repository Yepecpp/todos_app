import 'package:localstorage/localstorage.dart' as local_s;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import './auth.i.dart';

final storage = local_s.LocalStorage('auth');

class ILogin {
  String username;
  String password;
  String? token;
  static final uri = Uri.parse('${dotenv.env['HOSTAPI']}/auth');

  ILogin({required this.username, required this.password});
  Future<Auth> getAuth() async {
    if (token == null) {
      debugPrint('estabamos muerto');
      return Auth();
    }
    final resp = await http.get(uri, headers: {
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
    Auth auth = Auth();

    if (username.isEmpty || password.isEmpty) {
      return auth;
    }
    var resp = await http.post(
      uri,
      body: jsonEncode({
        'login': {
          'username': username,
          'password': password,
        }
      }),
      headers: {"Content-Type": "application/json"},
    );
    auth = Auth.fromJson(jsonDecode(resp.body));
    auth.status = resp.statusCode;
    if (auth.status == 200) {
      debugPrint("Login successful");
      debugPrint(auth.user!.name);
      storage.setItem('token', auth.token);
    } else {
      storage.deleteItem('token');
      debugPrint(resp.body);
    }
    return auth;
  }
}
