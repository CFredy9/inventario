import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../constants.dart';
import '../models/ubicacion.dart';
import 'package:http/http.dart' as http;

class UbicacionProvider with ChangeNotifier {
  UbicacionProvider() {
    getUbicacion();
  }

  List<UbicacionModel> _ubicacion = [];

  List<UbicacionModel> get todosUbicacion {
    return [..._ubicacion];
  }

  LocalStorage storage = LocalStorage('usertoken');

  void addUbicacion(UbicacionModel ubicacion) async {
    var token = storage.getItem('token');
    final response = await http.post(
        Uri.parse("http://${apiUrl}:8000/api/ubicacion/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(ubicacion));
    if (response.statusCode == 201) {
      getUbicacion();
      notifyListeners();
    }
  }

  void updateUbicacion(UbicacionModel ubicacion, int id) async {
    var token = storage.getItem('token');
    final response = await http.put(
        Uri.parse("http://${apiUrl}:8000/api/ubicacion/${id}/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(ubicacion));
    print(response.statusCode);
    if (response.statusCode == 200) {
      ubicacion.id = id;
      print(id);
      var ante = _ubicacion.singleWhere((ubica) => ubica.id == id);
      print(_ubicacion.indexOf(ante));
      _ubicacion[_ubicacion.indexOf(ante)] = ubicacion;
      notifyListeners();
    }
  }

  void delete(UbicacionModel ubicacion) async {
    var token = storage.getItem('token');
    final response = await http.delete(
      Uri.parse('http://${apiUrl}:8000/api/ubicacion/${ubicacion.id}/'),
      headers: {'Authorization': 'token $token'},
    );
    print(response.statusCode);
    print(ubicacion.id);
    if (response.statusCode == 204) {
      _ubicacion.remove(ubicacion);
      notifyListeners();
    }
  }

  getUbicacion() async {
    var token = storage.getItem('token');
    final url = Uri.parse('http://${apiUrl}:8000/api/ubicacion/');
    final response = await http.get(
      url,
      headers: {'Authorization': 'token $token'},
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      print(data);
      _ubicacion = data
          .map<UbicacionModel>((json) => UbicacionModel.fromJson(json))
          .toList();
      notifyListeners();
    }
  }
}
