class AbonoCreditoModel {
  int? id;
  var credito;
  String? cantidad;
  //String? fecha;

  AbonoCreditoModel({this.id, this.credito, this.cantidad});

  factory AbonoCreditoModel.fromJson(Map<String, dynamic> json) {
    return AbonoCreditoModel(
      id: json['id'],
      credito: json['credito'],
      cantidad: json['cantidad'],
    );
  }

  int? get Id => id;
  String? get Cantidad => cantidad;

  dynamic toJson() => {'id': id, 'credito': credito, 'cantidad': cantidad};
}
