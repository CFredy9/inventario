import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import '../constants.dart';
import '../models/usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider with ChangeNotifier {
  UsuarioProvider() {
    getUsuario();
  }
  String? id;
  List<UsuarioModel> _usuario = [];

  List<UsuarioModel> get todosUsuario {
    return [..._usuario];
  }

  LocalStorage storage = LocalStorage('usertoken');

  Future<bool> addUsuario(UsuarioModel usuario) async {
    var token = storage.getItem('token');
    final response = await http.post(
        Uri.parse("http://${apiUrl}:8000/api/usuario/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(usuario));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 201) {
      getUsuario();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> updateUsuario(UsuarioModel usuario, int id) async {
    var token = storage.getItem('token');
    final response = await http.put(
        Uri.parse("http://${apiUrl}:8000/api/usuario/${id}/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(usuario));
    print(response.statusCode);
    if (response.statusCode == 200) {
      usuario.id = id;
      print(id);
      var ante = _usuario.singleWhere((usu) => usu.id == id);
      print(_usuario.indexOf(ante));
      _usuario[_usuario.indexOf(ante)] = usuario;
      notifyListeners();
      return true;
    }
    return false;
  }

  void delete(UsuarioModel usuario) async {
    var token = storage.getItem('token');
    final response = await http.delete(
      Uri.parse('http://${apiUrl}:8000/api/usuario/${usuario.id}/'),
      headers: {'Authorization': 'token $token'},
    );
    print(response.statusCode);
    if (response.statusCode == 204) {
      _usuario.remove(usuario);
      notifyListeners();
    }
  }

  getUsuario() async {
    var token = storage.getItem('token');
    //_usuario = [];
    final url = Uri.parse('http://${apiUrl}:8000/api/usuario/');
    final response = await http.get(
      url,
      headers: {'Authorization': 'token $token'},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      print(data);
      _usuario = data
          .map<UsuarioModel>((json) => UsuarioModel.fromJson(json))
          .toList();
      notifyListeners();
    }
  }
}

class MeProvider with ChangeNotifier {
  MeProvider() {
    getUsuario();
  }

  LocalStorage storage = LocalStorage('usertoken');
  LocalStorage codigoT = LocalStorage('usercodigo');
  UsuarioModel me = UsuarioModel();
  UsuarioModel get Me {
    return me;
  }

  List<UsuarioModel> _usuario = [];

  List<UsuarioModel> get todosUsuario {
    return [..._usuario];
  }

  getUsuario() async {
    var token = storage.getItem('token');
    //_usuario = [];
    final url = Uri.parse('http://${apiUrl}:8000/api/usuario/');
    final response = await http.get(
      url,
      headers: {'Authorization': 'token $token'},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      print(data);
      _usuario = data
          .map<UsuarioModel>((json) => UsuarioModel.fromJson(json))
          .toList();
      notifyListeners();
    }
  }

  void updateMe(UsuarioModel usuario, int id) async {
    var token = storage.getItem('token');
    final response = await http.put(
        Uri.parse("http://${apiUrl}:8000/api/usuario/${id}/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(usuario));
    print(response.statusCode);
    if (response.statusCode == 200) {
      getMe();
      notifyListeners();
    }
  }

  getMe() async {
    var token = storage.getItem('token');
    final url = Uri.parse('http://${apiUrl}:8000/api/usuario/me/');
    final response = await http.get(
      url,
      headers: {'Authorization': 'token $token'},
    );

    if (response.statusCode == 200) {
      _usuario = [];
      var data = json.decode(response.body) as Map;
      print(data);
      /*_usuario = data
          .map<UsuarioModel>((json) => UsuarioModel.fromJson(json))
          .toList();*/
      me.first_name = data['first_name'];
      me.last_name = data['last_name'];
      me.phone = data['phone'];
      me.email = data['email'];
      me.id = data['id'];
      notifyListeners();
    }
  }

  void updateContra(UsuarioModel usuario) async {
    var token = storage.getItem('token');
    final response = await http.patch(
        Uri.parse("http://${apiUrl}:8000/api/usuario/update_contraseña/"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'token $token'
        },
        body: json.encode(usuario));
    print(response.statusCode);
    if (response.statusCode == 200) {
      //getMe();
      notifyListeners();
    }
  }

  void enviarCorreo(String correo) async {
    bool bandera = false;
    //var token = storage.getItem('token');
    final url = Uri.parse('http://${apiUrl}:8000/api/usuario/');
    final responseusuario = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        //'Authorization': 'token $token'
      },
    );
    print(responseusuario.statusCode);
    if (responseusuario.statusCode == 200) {
      var data = json.decode(responseusuario.body) as List;
      _usuario = data
          .map<UsuarioModel>((json) => UsuarioModel.fromJson(json))
          .toList();
      for (var i = 0; i < _usuario.length; i++) {
        if (_usuario[i].email == correo) {
          bandera = true;
        }
      }
    }
    print(bandera);
    if (bandera == true) {
      String c = "";
      Random random = Random();
      for (var i = 0; i < 6; i++) {
        c = c + random.nextInt(10).toString();
      }
      print(c);
      codigoT.deleteItem('codigo');
      codigoT.setItem("codigo", c);
      List aux = [correo, c];
      final response = await http.post(
          Uri.parse("http://${apiUrl}:8000/api/usuario/enviarCorreo/"),
          headers: {
            "Content-Type": "application/json",
            //'Authorization': 'token $token'
          },
          body: json.encode(aux));
      //print(response.statusCode);
      if (response.statusCode == 201) {
        //getMe();
        notifyListeners();
        Fluttertoast.showToast(msg: "Contraseña actualizada ");
      }
    } else {
      Fluttertoast.showToast(msg: "Ingrese un correo válido ");
    }
  }

  void verificarCodigo(String codigo) async {
    if (codigo == codigoT.getItem('codigo')) {
      Fluttertoast.showToast(msg: "Codigo correcto ");
    } else {
      Fluttertoast.showToast(msg: "Codigo incorrecto ");
    }
    /*final response = await http.post(
        Uri.parse("http://192.168.0.9:8000/api/usuario/enviarCorreo/"),
        headers: {
          "Content-Type": "application/json",
          //'Authorization': 'token $token'
        },
        body: json.encode(codigo));
    //print(response.statusCode);
    if (response.statusCode == 201) {
      //getMe();
      notifyListeners();
      Fluttertoast.showToast(msg: "Codigo correcto ");
    } */
  }

  void recuperacionContra(UsuarioModel usuario) async {
    final response = await http.patch(
        Uri.parse("http://${apiUrl}:8000/api/usuario/recuperacion_contraseña/"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(usuario));
    print(response.statusCode);
    if (response.statusCode == 200) {
      codigoT.deleteItem('codigo');
      //getMe();
      notifyListeners();
    }
  }
}
