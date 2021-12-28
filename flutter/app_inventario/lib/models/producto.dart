class ProductoModel {
  int? id;
  String? nombre;
  int? unidadesFardo;
  int? existenciasT;
  String? total_costo;
  String? total_venta;
  String? ganancia;
  var categoria;

  ProductoModel(
      {this.id,
      this.nombre,
      this.unidadesFardo,
      this.existenciasT,
      this.total_costo,
      this.total_venta,
      this.ganancia,
      this.categoria});

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
        id: json['id'],
        nombre: json['nombre'],
        unidadesFardo: json['unidadesFardo'],
        existenciasT: json['existenciasT'],
        total_costo: json['total_costo'],
        total_venta: json['total_venta'],
        ganancia: json['ganancia'],
        categoria: json['categoria']);
  }

  int? get Id => id;
  String? get Nombre => nombre;
  int? get UnidadesFardo => unidadesFardo;
  int? get ExistenciasT => existenciasT;
  String? get Total_Costo => total_costo;
  String? get Total_Venta => total_venta;
  String? get Ganancia => ganancia;

  dynamic toJson() => {
        'id': id,
        'nombre': nombre,
        'unidadesFardo': unidadesFardo,
        'existenciasT': existenciasT,
        'total_costo': total_costo,
        'total_venta': total_venta,
        'ganancia': ganancia,
        'categoria': categoria
      };
}
