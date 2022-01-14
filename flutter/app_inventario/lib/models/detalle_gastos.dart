class DetalleGastoModel {
  int? id;
  var descripcion;
  String? cantidad;
  String? fecha;

  DetalleGastoModel({this.id, this.descripcion, this.cantidad, this.fecha});

  factory DetalleGastoModel.fromJson(Map<String, dynamic> json) {
    return DetalleGastoModel(
        id: json['id'],
        descripcion: json['descripcion'],
        cantidad: json['cantidad'],
        fecha: json['creado']);
  }

  int? get Id => id;
  String? get Cantidad => cantidad;

  dynamic toJson() =>
      {'id': id, 'descripcion': descripcion, 'cantidad': cantidad};
}
