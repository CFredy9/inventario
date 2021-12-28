import 'ubicacion.dart';

class EstanteriaModel {
  int? id;
  String? estanteria;
  var almacen;

  EstanteriaModel({this.id, this.estanteria, this.almacen});

  factory EstanteriaModel.fromJson(Map<String, dynamic> json) {
    return EstanteriaModel(
        id: json['id'],
        estanteria: json['estanteria'],
        almacen: json['almacen']);
  }

  int? get Id => id;
  String? get Estanteria => estanteria;
  //UbicacionModel? get Almacen => almacen;

  dynamic toJson() => {'id': id, 'estanteria': estanteria, 'almacen': almacen};
}
