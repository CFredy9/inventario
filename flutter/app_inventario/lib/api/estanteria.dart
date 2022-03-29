import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../constants.dart';
import '../models/estanteria.dart';
import 'package:http/http.dart' as http;

class EstanteriaProvider with ChangeNotifier {
  EstanteriaProvider() {
    if (id != null) {
      getEstanteria(id);
    }
  }
  String? id;
  List<EstanteriaModel> _estanteria = [];

  List<EstanteriaModel> get todosEstanteria {
    return [..._estanteria];
  }

  LocalStorage storage = LocalStorage('usertoken');

  void addEstanteria(EstanteriaModel estanteria) async {
    var token = storage.getItem('token');
    final response = await http.post(
        Uri.parse("http://${apiUrl}:8000/api/estanteria/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(estanteria));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      getEstanteria(id);
      notifyListeners();
    }
  }

  void updateEstanteria(EstanteriaModel estanteria, int id) async {
    var token = storage.getItem('token');
    final response = await http.put(
        Uri.parse("http://${apiUrl}:8000/api/estanteria/${id}/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(estanteria));
    print(response.statusCode);
    if (response.statusCode == 200) {
      estanteria.id = id;
      print(id);
      var ante = _estanteria.singleWhere((estan) => estan.id == id);
      print(_estanteria.indexOf(ante));
      _estanteria[_estanteria.indexOf(ante)] = estanteria;
      notifyListeners();
    }
  }

  void delete(EstanteriaModel estanteria) async {
    var token = storage.getItem('token');
    final response = await http.delete(
      Uri.parse('http://${apiUrl}:8000/api/estanteria/${estanteria.id}/'),
      headers: {'Authorization': 'token $token'},
    );
    print(response.statusCode);
    if (response.statusCode == 204) {
      _estanteria.remove(estanteria);
      notifyListeners();
    }
  }

  getEstanteria(String? Id) async {
    var token = storage.getItem('token');
    _estanteria = [];
    final url = Uri.parse('http://${apiUrl}:8000/api/estanteria/');
    final response = await http
        .get(url, headers: {'id': Id!, 'Authorization': 'token $token'});

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      print(data);
      _estanteria = data
          .map<EstanteriaModel>((json) => EstanteriaModel.fromJson(json))
          .toList();
      notifyListeners();
    }
  }
}
