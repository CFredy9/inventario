import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../models/gastos.dart';
import 'package:http/http.dart' as http;

class GastosProvider with ChangeNotifier {
  GastosProvider() {
    getGasto();
    //getCursos();
    //getEmployeeList();
  }

  List<GastoModel> _gasto = [];

  List<GastoModel> get todosGasto {
    return [..._gasto];
  }

  LocalStorage storage = LocalStorage('usertoken');
  String apiUrl = '192.168.0.9';
  //String apiUrl = '192.168.43.83';

  void addGasto(GastoModel gasto) async {
    var token = storage.getItem('token');
    final response = await http.post(
        Uri.parse("http://${apiUrl}:8000/api/gasto/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(gasto));
    print(response.body);
    if (response.statusCode == 201) {
      /*categoria.id = json.decode(response.body)['id'];
      print(categoria.id);
      _categoria.add(categoria);*/
      getGasto();
      notifyListeners();
    }
  }

  void updateGasto(GastoModel gasto, int id) async {
    var token = storage.getItem('token');
    final response = await http.put(
        Uri.parse("http://${apiUrl}:8000/api/gasto/${id}/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(gasto));
    print(response.statusCode);
    if (response.statusCode == 200) {
      gasto.id = id;
      print(id);
      var ante = _gasto.singleWhere((categori) => categori.id == id);
      print(_gasto.indexOf(ante));
      _gasto[_gasto.indexOf(ante)] = gasto;
      notifyListeners();
    }
  }

  void delete(GastoModel gasto) async {
    var token = storage.getItem('token');
    print("Entro");
    final response = await http.delete(
      Uri.parse('http://${apiUrl}:8000/api/gasto/${gasto.id}/'),
      headers: {'Authorization': 'token $token'},
    );
    print(response.statusCode);
    print(gasto.id);
    if (response.statusCode == 204) {
      _gasto.remove(gasto);
      notifyListeners();
    }
  }

  getGasto() async {
    var token = storage.getItem('token');
    final url = Uri.parse('http://${apiUrl}:8000/api/gasto/');
    final response = await http.get(
      url,
      headers: {'Authorization': 'token $token'},
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      print(data);
      _gasto =
          data.map<GastoModel>((json) => GastoModel.fromJson(json)).toList();
      notifyListeners();
    }
  }
}
