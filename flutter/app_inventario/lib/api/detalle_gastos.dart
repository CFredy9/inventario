import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../constants.dart';
import '../models/detalle_gastos.dart';
import 'package:http/http.dart' as http;

class DetalleGastosProvider with ChangeNotifier {
  DetalleGastosProvider() {
    if (_id != null) {
      getDetalleGasto(_id);
    }
    //getCursos();
    //getEmployeeList();
  }
  String? _id;
  var total;
  List<DetalleGastoModel> _detallegasto = [];

  List<DetalleGastoModel> get todosDetalleGasto {
    return [..._detallegasto];
  }

  LocalStorage storage = LocalStorage('usertoken');

  Future<bool> addDetalleGasto(
      DetalleGastoModel detallegasto, String idgasto) async {
    var token = storage.getItem('token');
    final response = await http.post(
        Uri.parse("http://${apiUrl}/api/detallegasto/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(detallegasto));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      /*categoria.id = json.decode(response.body)['id'];
      print(categoria.id);
      _categoria.add(categoria);*/
      getDetalleGasto(idgasto);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateDetalleGasto(
      DetalleGastoModel detallegasto, int id, String idgasto) async {
    var token = storage.getItem('token');
    final response = await http.put(
        Uri.parse("http://${apiUrl}/api/detallegasto/${id}/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(detallegasto));
    print(response.statusCode);
    if (response.statusCode == 200) {
      detallegasto.id = id;
      print(id);
      /*var ante = _detallegasto.singleWhere((categori) => categori.id == id);
      _detallegasto[_detallegasto.indexOf(ante)] = detallegasto;*/
      getDetalleGasto(idgasto);
      notifyListeners();
      return true;
    }
    return false;
  }

  void delete(DetalleGastoModel detallegasto) async {
    var token = storage.getItem('token');
    print("Entro");
    final response = await http.delete(
      Uri.parse('http://${apiUrl}/api/detallegasto/${detallegasto.id}/'),
      headers: {'Authorization': 'token $token'},
    );
    print(response.statusCode);
    print(detallegasto.id);
    if (response.statusCode == 204) {
      _detallegasto.remove(detallegasto);
      notifyListeners();
    }
  }

  getDetalleGasto(String? Id) async {
    var token = storage.getItem('token');
    final url = Uri.parse('http://${apiUrl}/api/detallegasto/');
    final response = await http
        .get(url, headers: {'id': Id!, 'Authorization': 'token $token'});
    if (response.statusCode == 200) {
      String body = const Utf8Decoder().convert(response.bodyBytes);
      var data = json.decode(body) as List;
      print(data);
      _detallegasto = data
          .map<DetalleGastoModel>((json) => DetalleGastoModel.fromJson(json))
          .toList();
      notifyListeners();
    }
  }

  getTotales(String? Id) async {
    total = {'total': 0};
    var token = storage.getItem('token');
    final url = Uri.parse('http://${apiUrl}/api/detallegasto/total');
    final response = await http.get(
      url,
      headers: {
        'id': Id!,
        'Authorization': 'token $token',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = const Utf8Decoder().convert(response.bodyBytes);
      var data = json.decode(body);
      print(data);
      total = data;
      notifyListeners();
    }
  }
}
