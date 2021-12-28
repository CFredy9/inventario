class UbicacionModel {
  int? id;
  String? almacen;

  UbicacionModel({this.id, this.almacen});

  factory UbicacionModel.fromJson(Map<String, dynamic> json) {
    return UbicacionModel(id: json['id'], almacen: json['almacen']);
  }

  int? get Id => id;
  String? get Almacen => almacen;

  dynamic toJson() => {'id': id, 'almacen': almacen};
}
