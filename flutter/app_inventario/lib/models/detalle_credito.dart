class DetalleCreditoModel {
  int? id;
  var credito;
  String? cantidad;
  //String? fecha;

  DetalleCreditoModel({this.id, this.credito, this.cantidad});

  factory DetalleCreditoModel.fromJson(Map<String, dynamic> json) {
    return DetalleCreditoModel(
      id: json['id'],
      credito: json['credito'],
      cantidad: json['cantidad'],
    );
  }

  int? get Id => id;
  String? get Cantidad => cantidad;

  dynamic toJson() => {'id': id, 'credito': credito, 'cantidad': cantidad};
}
