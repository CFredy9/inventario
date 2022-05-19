import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../constants.dart';
import '../models/producto.dart';
import 'package:http/http.dart' as http;

class ReportesProvider with ChangeNotifier {
  ReportesProvider() {
    //getVentaProducto('', '');
  }

  List<ProductoModel> _ventaproducto = [];
  List<ProductoModel> _productocantidad = [];
  List<ProductoModel> _productoganancia = [];

  List<ProductoModel> get todosVentaProducto {
    return [..._ventaproducto];
  }

  List<ProductoModel> get todosProductosVendidosCantidad {
    return [..._productocantidad];
  }

  List<ProductoModel> get todosProductosVendidosGanancia {
    return [..._productoganancia];
  }

  var totales;
  /*Map get todoTotales {
    return [...totales];
  }*/

  LocalStorage storage = LocalStorage('usertoken');

  getVentaProducto(String start, String end) async {
    _ventaproducto = [];
    var token = storage.getItem('token');
    final url = Uri.parse('http://${apiUrl}:8000/api/ventaproducto/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'token $token',
        'start': start,
        'end': end,
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      print(data);
      _ventaproducto = data
          .map<ProductoModel>((json) => ProductoModel.fromJson(json))
          .toList();
      notifyListeners();
    }
  }

  getTotales(String start, String end) async {
    totales = {'total_costo': 0, 'total_venta': 0, 'ganancia': 0};
    var token = storage.getItem('token');
    final url = Uri.parse('http://${apiUrl}:8000/api/ventaproducto/totales');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'token $token',
        'start': start,
        'end': end,
      },
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      totales = data;
      notifyListeners();
    }
  }

  getProductoVendidoFardos(String start, String end) async {
    _productocantidad = [];
    var token = storage.getItem('token');
    final url = Uri.parse(
        'http://${apiUrl}:8000/api/ventaproducto/productoVendidoFardos');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'token $token',
        'start': start,
        'end': end,
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      print(data);
      _productocantidad = data
          .map<ProductoModel>((json) => ProductoModel.fromJson(json))
          .toList();
      notifyListeners();
    }
  }

  getProductoVendidoGanancia(String start, String end) async {
    _productoganancia = [];
    var token = storage.getItem('token');
    final url = Uri.parse(
        'http://${apiUrl}:8000/api/ventaproducto/productoVendidoGanancia');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'token $token',
        'start': start,
        'end': end,
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      print(data);
      _productoganancia = data
          .map<ProductoModel>((json) => ProductoModel.fromJson(json))
          .toList();
      notifyListeners();
    }
  }
}
