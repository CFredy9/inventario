import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../constants.dart';
import '../models/detalle_producto.dart';
import 'package:http/http.dart' as http;

class DetalleProductoProvider with ChangeNotifier {
  DetalleProductoProvider() {
    if (_id != null) {
      getdetalleProducto(_id);
    }
  }
  String? _id;
  List<DetalleProductoModel> _detalleproducto = [];

  List<DetalleProductoModel> get todosdetalleProducto {
    return [..._detalleproducto];
  }

  LocalStorage storage = LocalStorage('usertoken');

  Future<bool> addDetalleProducto(
      DetalleProductoModel detalleproducto, String idproducto) async {
    var token = storage.getItem('token');
    final response = await http.post(
        Uri.parse("http://${apiUrl}:8000/api/detalleproducto/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(detalleproducto));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      getdetalleProducto(idproducto);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateDetalleProducto(
      DetalleProductoModel detalleproducto, int id, String idproducto) async {
    var token = storage.getItem('token');
    print(id);
    final response = await http.put(
        Uri.parse("http://${apiUrl}:8000/api/detalleproducto/${id}/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(detalleproducto));
    print(response.statusCode);
    print('Aqui pasa una y otra vez');
    if (response.statusCode == 200) {
      detalleproducto.id = id;
      print(id);
      /*var ante = _detalleproducto.singleWhere((produc) => produc.id == id);
      print(_detalleproducto.indexOf(ante));
      _detalleproducto[_detalleproducto.indexOf(ante)] = detalleproducto;*/
      getdetalleProducto(idproducto);
      notifyListeners();
      return true;
    }
    return false;
  }

  void delete(DetalleProductoModel detalle) async {
    var token = storage.getItem('token');
    final response = await http.delete(
      Uri.parse('http://${apiUrl}:8000/api/detalleproducto/${detalle.id}/'),
      headers: {'Authorization': 'token $token'},
    );
    print(response.statusCode);
    if (response.statusCode == 204) {
      _detalleproducto.remove(detalle);
      notifyListeners();
    }
  }

  getdetalleProducto(String? Id) async {
    var token = storage.getItem('token');
    final url = Uri.parse('http://${apiUrl}:8000/api/detalleproducto/');
    final response = await http
        .get(url, headers: {'id': Id!, 'Authorization': 'token $token'});
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      print(data);
      _detalleproducto = data
          .map<DetalleProductoModel>(
              (json) => DetalleProductoModel.fromJson(json))
          .toList();
      notifyListeners();
    }
  }
}
