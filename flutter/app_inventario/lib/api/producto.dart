import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import '../constants.dart';
import '../models/producto.dart';
import 'package:http/http.dart' as http;

class ProductoProvider with ChangeNotifier {
  ProductoProvider() {
    getProducto("");
  }
  bool bandera = false;
  List<ProductoModel> _producto = [];

  List<ProductoModel> get todosProducto {
    return [..._producto];
  }

  LocalStorage storage = LocalStorage('usertoken');

  void addProducto(ProductoModel producto) async {
    var token = storage.getItem('token');
    final response = await http.post(
        Uri.parse("http://${apiUrl}/api/producto/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(producto));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      getProducto("");
      notifyListeners();
    }
  }

  void updateProducto(ProductoModel producto, int id) async {
    var token = storage.getItem('token');
    final response = await http.put(
        Uri.parse("http://${apiUrl}/api/producto/${id}/"),
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
      Uri.parse('http://${apiUrl}/api/producto/${producto.id}/'),
      headers: {'Authorization': 'token $token'},
    );
    print(response.statusCode);
    if (response.statusCode == 204) {
      _producto.remove(producto);
      notifyListeners();
    }
  }

  Future<bool> getProducto(String? Id) async {
    var token = storage.getItem('token');
    final url = Uri.parse('http://${apiUrl}/api/producto/?ordering=nombre');
    final response = await http.get(
      url,
      headers: {'id': Id!, 'Authorization': 'token $token'},
    );
    if (response.statusCode == 200) {
      String body = const Utf8Decoder().convert(response.bodyBytes);
      var data = json.decode(body) as List;
      print(data);
      _producto = data
          .map<ProductoModel>((json) => ProductoModel.fromJson(json))
          .toList();
      notifyListeners();
      countProduct = _producto.length;
      if (countProduct == 0) {
        Fluttertoast.showToast(
            msg: "No se encontraron datos",
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      return true;
    }
    return false;
  }

  searchProducto(String? Id, String? query, String? ordering) async {
    var token = storage.getItem('token');
    final url = Uri.parse(
        'http://${apiUrl}/api/producto/?search=$query&ordering=$ordering');
    final response = await http.get(
      url,
      headers: {'id': Id!, 'Authorization': 'token $token'},
    );
    if (response.statusCode == 200) {
      String body = const Utf8Decoder().convert(response.bodyBytes);
      var data = json.decode(body) as List;
      print(data);
      _producto = data
          .map<ProductoModel>((json) => ProductoModel.fromJson(json))
          .toList();
      notifyListeners();
    }
  }

  Future<bool> getProductosAgotados() async {
    var token = storage.getItem('token');
    final url = Uri.parse('http://${apiUrl}/api/producto/productosAgotados');
    final response = await http.get(
      url,
      headers: {'Authorization': 'token $token'},
    );
    if (response.statusCode == 200) {
      String body = const Utf8Decoder().convert(response.bodyBytes);
      var data = json.decode(body) as List;
      print(data);
      _producto = data
          .map<ProductoModel>((json) => ProductoModel.fromJson(json))
          .toList();
      notifyListeners();
      countProduct = _producto.length;
      if (countProduct == 0) {
        Fluttertoast.showToast(
            msg: "No se encontraron datos",
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      return true;
    }
    return false;
  }

  searchProductosAgotados(String? query) async {
    var token = storage.getItem('token');
    final url = Uri.parse(
        'http://${apiUrl}/api/producto/productosAgotados/?search=$query');
    final response = await http.get(
      url,
      headers: {'Authorization': 'token $token'},
    );
    if (response.statusCode == 200) {
      String body = const Utf8Decoder().convert(response.bodyBytes);
      var data = json.decode(body) as List;
      print(data);
      _producto = data
          .map<ProductoModel>((json) => ProductoModel.fromJson(json))
          .toList();
      notifyListeners();
    }
  }

  getProductoCategoria(String? Id) async {
    var token = storage.getItem('token');
    final url = Uri.parse('http://${apiUrl}/api/producto/?ordering=nombre');
    final response = await http.get(
      url,
      headers: {'id': Id!, 'Authorization': 'token $token'},
    );
    if (response.statusCode == 200) {
      String body = const Utf8Decoder().convert(response.bodyBytes);
      var data = json.decode(body) as List;
      print(data);
      _producto = data
          .map<ProductoModel>((json) => ProductoModel.fromJson(json))
          .toList();
      notifyListeners();
    }
  }
}
