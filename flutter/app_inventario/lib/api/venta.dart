import 'dart:convert';
import 'package:app_inventario/api/detalle_producto.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import '../models/venta.dart';
import 'package:http/http.dart' as http;

class VentaProvider with ChangeNotifier {
  VentaProvider() {
    getVenta();
  }
  List<VentaModel> _venta = [];

  List<VentaModel> get todosVenta {
    return [..._venta];
  }

  LocalStorage storage = LocalStorage('usertoken');
  String apiUrl = '192.168.0.9';
  //String apiUrl = '192.168.43.83';

  Future<bool> addVenta(VentaModel venta) async {
    var token = storage.getItem('token');
    final response = await http.post(
        Uri.parse("http://${apiUrl}:8000/api/venta/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(venta));
    print(response.statusCode);
    if (response.statusCode == 200) {
      //getVenta();
      notifyListeners();
      return true;
    }
    return false;
  }

  getVenta() async {
    var token = storage.getItem('token');
    _venta = [];
    final url = Uri.parse('http://${apiUrl}:8000/api/venta/');
    final response =
        await http.get(url, headers: {'Authorization': 'token $token'});

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      print(data);
      _venta =
          data.map<VentaModel>((json) => VentaModel.fromJson(json)).toList();
      notifyListeners();
    }
  }
}
