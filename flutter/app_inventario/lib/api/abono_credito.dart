import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../constants.dart';
import '../models/abono_credito.dart';
import 'package:http/http.dart' as http;

class AbonoCreditoProvider with ChangeNotifier {
  AbonoCreditoProvider() {
    if (_id != null) {
      getAbonoCredito(_id);
    }
    //getCursos();
    //getEmployeeList();
  }
  String? _id;
  var total;
  List<AbonoCreditoModel> _abonocredito = [];

  List<AbonoCreditoModel> get todosAbonoCredito {
    return [..._abonocredito];
  }

  LocalStorage storage = LocalStorage('usertoken');

  Future<bool> addAbonoCredito(
      AbonoCreditoModel abonocredito, String idcredito) async {
    var token = storage.getItem('token');
    final response = await http.post(
        Uri.parse("http://${apiUrl}:8000/api/abonocredito/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(abonocredito));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      /*categoria.id = json.decode(response.body)['id'];
      print(categoria.id);
      _categoria.add(categoria);*/
      getAbonoCredito(idcredito);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateAbonoCredito(
      AbonoCreditoModel abonocredito, int id, String idcredito) async {
    var token = storage.getItem('token');
    final response = await http.put(
        Uri.parse("http://${apiUrl}:8000/api/abonocredito/${id}/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(abonocredito));
    print(response.statusCode);
    if (response.statusCode == 200) {
      abonocredito.id = id;
      getAbonoCredito(idcredito);
      notifyListeners();
      return true;
    }
    return false;
  }

  void delete(AbonoCreditoModel abonocredito) async {
    var token = storage.getItem('token');
    print("Entro");
    final response = await http.delete(
      Uri.parse('http://${apiUrl}:8000/api/abonocredito/${abonocredito.id}/'),
      headers: {'Authorization': 'token $token'},
    );
    print(response.statusCode);
    print(abonocredito.id);
    if (response.statusCode == 204) {
      _abonocredito.remove(abonocredito);
      notifyListeners();
    }
  }

  getAbonoCredito(String? Id) async {
    var token = storage.getItem('token');
    final url = Uri.parse('http://${apiUrl}:8000/api/abonocredito/');
    final response = await http
        .get(url, headers: {'id': Id!, 'Authorization': 'token $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      print(data);
      _abonocredito = data
          .map<AbonoCreditoModel>((json) => AbonoCreditoModel.fromJson(json))
          .toList();
      notifyListeners();
    }
  }
}
