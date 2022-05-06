import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../constants.dart';
import '../models/credito.dart';
import 'package:http/http.dart' as http;

class CreditoProvider with ChangeNotifier {
  CreditoProvider() {
    getCredito();
    //getCursos();
    //getEmployeeList();
  }

  List<CreditoModel> _credito = [];

  List<CreditoModel> get todosCredito {
    return [..._credito];
  }

  LocalStorage storage = LocalStorage('usertoken');

  void addCredito(CreditoModel credito) async {
    var token = storage.getItem('token');
    final response = await http.post(
        Uri.parse("http://${apiUrl}:8000/api/credito/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(credito));
    print(response.body);
    if (response.statusCode == 201) {
      getCredito();
      notifyListeners();
    }
  }

  void updateCredito(CreditoModel credito, int id) async {
    var token = storage.getItem('token');
    final response = await http.put(
        Uri.parse("http://${apiUrl}:8000/api/credito/${id}/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(credito));
    print(response.statusCode);
    if (response.statusCode == 200) {
      credito.id = id;
      print(id);
      var ante = _credito.singleWhere((credi) => credi.id == id);
      print(_credito.indexOf(ante));
      _credito[_credito.indexOf(ante)] = credito;
      notifyListeners();
    }
  }

  void delete(CreditoModel credito) async {
    var token = storage.getItem('token');
    final response = await http.delete(
      Uri.parse('http://${apiUrl}:8000/api/credito/${credito.id}/'),
      headers: {'Authorization': 'token $token'},
    );
    print(response.statusCode);
    print(credito.id);
    if (response.statusCode == 204) {
      _credito.remove(credito);
      notifyListeners();
    }
  }

  getCredito() async {
    var token = storage.getItem('token');
    final url = Uri.parse('http://${apiUrl}:8000/api/credito/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'token $token',
        'start': '',
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      print(data);
      _credito = data
          .map<CreditoModel>((json) => CreditoModel.fromJson(json))
          .toList();
      notifyListeners();
    }
  }
}
