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

class CategoriaModel {
  int? id;
  String? nombre;

  CategoriaModel({this.id, this.nombre});

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(id: json['id'], nombre: json['nombre']);
  }

  int? get Id => id;
  String? get Nombre => nombre;

  dynamic toJson() => {'id': id, 'nombre': nombre};
}
