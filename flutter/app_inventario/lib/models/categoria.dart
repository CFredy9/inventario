/*import 'package:firebase_database/firebase_database.dart';

class CategoriaModel {
  String? id;
  String? nombre;

  CategoriaModel({
    this.id,
    this.nombre,
  });
  CategoriaModel.map(dynamic obj) {
    id = obj['id'];
    nombre = obj['nombre'];
  }

  String? get Id => id;
  String? get Nombre => nombre;

  //Crea tabla en firebase
  CategoriaModel.fromSnapShot(DataSnapshot snapshot) {
    id = snapshot.key;
    nombre = snapshot.value['nombre'];
  }
} */

import 'dart:ui';

class CategoriaModel {
  int? id;
  String? nombre;
  String? imagen;

  CategoriaModel({this.id, this.nombre, this.imagen});

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
        id: json['id'], nombre: json['nombre'], imagen: json['imagen']);
  }

  int? get Id => id;
  String? get Nombre => nombre;
  String? get Imagen => imagen;

  dynamic toJson() => {'id': id, 'nombre': nombre, 'imagen': imagen};
}
