import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../constants.dart';
import '../models/detalle_credito.dart';
import 'package:http/http.dart' as http;

class DetalleCreditoProvider with ChangeNotifier {
  DetalleCreditoProvider() {
    if (_id != null) {
      getDetalleCredito(_id);
    }
    //getCursos();
    //getEmployeeList();
  }
  String? _id;
  var total;
  List<DetalleCreditoModel> _detallecredito = [];

  List<DetalleCreditoModel> get todosDetalleCredito {
    return [..._detallecredito];
  }

  LocalStorage storage = LocalStorage('usertoken');

  Future<bool> addDetalleCredito(
      DetalleCreditoModel detallecredito, String idcredito) async {
    var token = storage.getItem('token');
    final response = await http.post(
        Uri.parse("http://${apiUrl}:8000/api/detallecredito/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(detallecredito));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      /*categoria.id = json.decode(response.body)['id'];
      print(categoria.id);
      _categoria.add(categoria);*/
      getDetalleCredito(idcredito);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateDetalleCredito(
      DetalleCreditoModel detallecredito, int id, String idcredito) async {
    var token = storage.getItem('token');
    final response = await http.put(
        Uri.parse("http://${apiUrl}:8000/api/detallecredito/${id}/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(detallecredito));
    print(response.statusCode);
    if (response.statusCode == 200) {
      detallecredito.id = id;
      getDetalleCredito(idcredito);
      notifyListeners();
      return true;
    }
    return false;
  }

  void delete(DetalleCreditoModel detallecredito) async {
    var token = storage.getItem('token');
    print("Entro");
    final response = await http.delete(
      Uri.parse(
          'http://${apiUrl}:8000/api/detallecredito/${detallecredito.id}/'),
      headers: {'Authorization': 'token $token'},
    );
    print(response.statusCode);
    print(detallecredito.id);
    if (response.statusCode == 204) {
      _detallecredito.remove(detallecredito);
      notifyListeners();
    }
  }

  getDetalleCredito(String? Id) async {
    var token = storage.getItem('token');
    final url = Uri.parse('http://${apiUrl}:8000/api/detallecredito/');
    final response = await http
        .get(url, headers: {'id': Id!, 'Authorization': 'token $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      print(data);
      _detallecredito = data
          .map<DetalleCreditoModel>(
              (json) => DetalleCreditoModel.fromJson(json))
          .toList();
      notifyListeners();
    }
  }
}
