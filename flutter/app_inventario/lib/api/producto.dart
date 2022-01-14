import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../models/producto.dart';
import 'package:http/http.dart' as http;

class ProductoProvider with ChangeNotifier {
  ProductoProvider() {
    getProducto();
  }

  List<ProductoModel> _producto = [];

  List<ProductoModel> get todosProducto {
    return [..._producto];
  }

  LocalStorage storage = LocalStorage('usertoken');
  String apiUrl = '192.168.0.10';
  //String apiUrl = '192.168.43.83';

  void addProducto(ProductoModel producto) async {
    var token = storage.getItem('token');
    final response = await http.post(
        Uri.parse("http://${apiUrl}:8000/api/producto/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(producto));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      getProducto();
      notifyListeners();
    }
  }

  void updateProducto(ProductoModel producto, int id) async {
    var token = storage.getItem('token');
    final response = await http.put(
        Uri.parse("http://${apiUrl}:8000/api/producto/${id}/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(producto));
    print(response.statusCode);
    if (response.statusCode == 200) {
      producto.id = id;
      print(id);
      var ante = _producto.singleWhere((produc) => produc.id == id);
      print(_producto.indexOf(ante));
      _producto[_producto.indexOf(ante)] = producto;
      notifyListeners();
    }
  }

  void delete(ProductoModel producto) async {
    var token = storage.getItem('token');
    final response = await http.delete(
      Uri.parse('http://${apiUrl}:8000/api/producto/${producto.id}/'),
      headers: {'Authorization': 'token $token'},
    );
    print(response.statusCode);
    if (response.statusCode == 204) {
      _producto.remove(producto);
      notifyListeners();
    }
  }

  getProducto() async {
    var token = storage.getItem('token');
    final url = Uri.parse('http://${apiUrl}:8000/api/producto/');
    final response = await http.get(
      url,
      headers: {'Authorization': 'token $token'},
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      print(data);
      _producto = data
          .map<ProductoModel>((json) => ProductoModel.fromJson(json))
          .toList();
      notifyListeners();
    }
  }
}
