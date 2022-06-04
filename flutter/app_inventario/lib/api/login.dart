import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../constants.dart';
import '../models/usuario.dart';
import 'package:http/http.dart' as http;

class LoginProvider with ChangeNotifier {
  LocalStorage storage = LocalStorage('usertoken');

  Future<bool> login(String email, String password) async {
    final response =
        await http.post(Uri.parse("http://${apiUrl}/api/usuario/token/"),
            headers: {
              "Access-Control-Allow-Origin":
                  "*", // Required for CORS support to work
              "Access-Control-Allow-Credentials":
                  "true", // Required for cookies, authorization headers with HTTPS
              "Access-Control-Allow-Headers":
                  "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
              "Access-Control-Allow-Methods": "POST, OPTIONS",
              "Content-Type": "application/json"
            },
            body: json.encode({"email": email, "password": password}));
    var data = json.decode(response.body) as Map;
    print(data);
    if (data.containsKey("token")) {
      storage.setItem("token", data['token']);
      print(storage.getItem('token'));
      return true;
    }
    return false;
  }

  Future<bool> logOut() async {
    var token = storage.getItem('token');
    final response = await http.post(
      Uri.parse("http://${apiUrl}/api/usuario/logout/"),
      headers: {'Authorization': 'token $token'},
    );
    storage.deleteItem('token');
    return true;
  }
}
