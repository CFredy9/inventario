class GastoModel {
  int? id;
  String? cantidad;
  String? descripcion;
  String? fecha;

  GastoModel({this.id, this.cantidad, this.descripcion, this.fecha});

  factory GastoModel.fromJson(Map<String, dynamic> json) {
    return GastoModel(
        id: json['id'],
        cantidad: json['cantidad'],
        descripcion: json['descripcion'],
        fecha: json['creado']);
  }

  int? get Id => id;
  String? get Cantidad => cantidad;

  dynamic toJson() =>
      {'id': id, 'cantidad': cantidad, 'descripcion': descripcion};
}
