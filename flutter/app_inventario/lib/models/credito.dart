class CreditoModel {
  int? id;
  String? nombreCredito;
  String? total;

  CreditoModel({this.id, this.nombreCredito, this.total});

  factory CreditoModel.fromJson(Map<String, dynamic> json) {
    return CreditoModel(
        id: json['id'],
        nombreCredito: json['nombreCredito'],
        total: json['total']);
  }

  int? get Id => id;
  String? get NombreCredito => nombreCredito;

  dynamic toJson() =>
      {'id': id, 'nombreCredito': nombreCredito, 'total': total};
}
