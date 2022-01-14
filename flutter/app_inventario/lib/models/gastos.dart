class GastoModel {
  int? id;
  String? descripcion;
  String? total;

  GastoModel({this.id, this.descripcion, this.total});

  factory GastoModel.fromJson(Map<String, dynamic> json) {
    return GastoModel(
        id: json['id'], descripcion: json['descripcion'], total: json['total']);
  }

  int? get Id => id;
  String? get Descripcion => descripcion;

  dynamic toJson() => {'id': id, 'descripcion': descripcion, 'total': total};
}
