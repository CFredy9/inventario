import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../constants.dart';
import '../models/detalle_producto.dart';
import 'package:http/http.dart' as http;

class VencimientoProvider with ChangeNotifier {
  VencimientoProvider() {
    //getVentaProducto('', '');
  }

  List<DetalleProductoModel> _vencimientoProducto = [];

  List<DetalleProductoModel> get todosVencimientoProducto {
    return [..._vencimientoProducto];
  }

  var totales;
  /*Map get todoTotales {
    return [...totales];
  }*/

  LocalStorage storage = LocalStorage('usertoken');

  getVencimientoProducto(String start, String end) async {
    _vencimientoProducto = [];
    var token = storage.getItem('token');
    final url =
        Uri.parse('http://${apiUrl}:8000/api/vencimientodetalleproducto/');
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
      _vencimientoProducto = data
          .map<DetalleProductoModel>(
              (json) => DetalleProductoModel.fromJson(json))
          .toList();
      notifyListeners();
    }
  }
}
