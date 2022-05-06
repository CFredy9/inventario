import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../constants.dart';
import '../models/producto.dart';
import 'package:http/http.dart' as http;

class CapitalProvider with ChangeNotifier {
  var totales;
  /*Map get todoTotales {
    return [...totales];
  }*/

  LocalStorage storage = LocalStorage('usertoken');

  getTotales() async {
    totales = {'total_costo': 0, 'total_credito': 0, 'capital': 0};
    var token = storage.getItem('token');
    final url = Uri.parse('http://${apiUrl}:8000/api/reportecapital/capital');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'token $token',
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
}
